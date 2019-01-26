function [bitQpsk] = ml_qpsk(symbolQpsk)
% Function: 
%   - maximum-likelihood detector for QPSK symbols
%
% InputArg(s):
%   - symbolQpsk: QPSK symbol stream
%
% OutputArg(s):
%   - bitQpsk: recovered bit stream
%
% Comments:
%   - signal space is 2-d
%   - real part positive -> 1st bit closed to sqrt(p / 2) -> 1st bit 0
%   - real part negative -> 1st bit closed to -sqrt(p / 2) -> 1st bit 1
%   - imag part positive -> 2nd bit closed to i * sqrt(p / 2) -> 2nd bit 0
%   - imag part negative -> 2nd bit closed to i * -sqrt(p / 2) -> 2nd bit 1
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

bitQpsk = zeros(1, 2 * length(symbolQpsk));
% demap to bits
bitQpsk(1: 2: end - 1) = 1 / 2 * (1 - sign(real(symbolQpsk)));
bitQpsk(2: 2: end) = 1 / 2 * (1 - sign(imag(symbolQpsk)));
end

