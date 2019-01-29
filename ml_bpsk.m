function [bitBpsk, snrAvgBpsk] = ml_bpsk(symbolBpsk)
% Function: 
%   - maximum-likelihood detector for BPSK symbols
%
% InputArg(s):
%   - symbolBpsk: BPSK symbol stream
%
% OutputArg(s):
%   - bitBpsk: recovered bit stream
%   - snrAvgBpsk: average output SNR
%
% Comments:
%   - signal space should be 1-d but is actually 2-d due to complex noise
%   - does not influence system performance
%   - real part positive -> symbol closed to sqrt(p) -> bit 0
%   - real part negative -> symbol closed to -sqrt(p) -> bit 1
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

powerNoise = 1;
% compute average received bit power
powerBitAvg = norm(symbolBpsk) ^ 2 / length(symbolBpsk);
% and average output SNR
snrAvgBpsk = powerBitAvg / powerNoise;
% demap to bits
bitBpsk = 1 / 2 * (1 - sign(real(symbolBpsk)));
end

