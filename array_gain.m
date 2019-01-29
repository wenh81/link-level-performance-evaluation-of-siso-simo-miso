function [arrayGain] = array_gain(snrPerBit, snrAvg)
% Function: 
%   - compute the array gain based on single-branch SNR and average output
%   SNR
%
% InputArg(s):
%   - snrPerBit: signal-to-noise ratio per bit 
%   - snrAvg: average output SNR per bit
%
% OutputArg(s):
%   - arrayGain: array gain
%
% Comments:
%   - array gain measures the increase in average output SNR relative to 
%   the single-branch average SNR
%
% Author & Date: Yang (i@snowztail.com) - 28 Jan 19

arrayGain = snrAvg / snrPerBit;
end
