function [gain] = channel_rayleigh(nChannels)
% Function: 
%   - generate Rayleigh channels
%   
% InputArg(s):
%   - nChannels: number of channels
%
% OutputArg(s):
%   - gain: fading coefficient (channel impulse response)
%
% Restraint(s):
%   - does not consider multipath effect
%
% Comments:
%   - channels with CSCG distribution
%
% Author & Date: Yang (i@snowztail.com) - 23 Jan 19

gain = sqrt(1 / 2) * (randn(nChannels, 1) + 1i * randn(nChannels, 1));
end

