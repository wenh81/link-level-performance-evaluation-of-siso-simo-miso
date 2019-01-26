function [symbolBpsk] = bpsk(bitStream, powerBit)
% Function: 
%   - map bit stream to uncoded BPSK symbols
%
% InputArg(s):
%   - bitStream: bit stream in 0 and 1
%   - powerBit: average bit power
%
% OutputArg(s):
%   - symbolBpsk: uncoded BPSK symbols
%
% Restraints:
%   - plain output symbol without error detection and correction coding
%
% Comments:
%   - signal space is 1-D
%   - assume initial phase is 0
%   - 0 -> sqrt(p), 1 -> -sqrt(p)
%
% Author & Date: Yang (i@snowztail.com) - 21 Jan 19

symbolBpsk = sqrt(powerBit) * (1 - 2 * bitStream);
end

