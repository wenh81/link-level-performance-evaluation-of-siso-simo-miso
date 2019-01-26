function [mrtSymbol] = mrt(symbol, gain)
% Function: 
%   - maximal ratio transmission on multiple transmitters
%
% InputArg(s):
%   - symbol: symbol to be transmitted on multiple transmit antennas
%   - gain: corresponding fading coefficient (channel impulse response)
%
% OutputArg(s):
%   - mrtSymbol: transmit symbols on multiple transmitters to utilise
%   channel diversity
%
% Comments:
%   - same performance with MRC but require CSIT
%   - hard to obtain CSIT, thus not popular
%   - fixed capacity, enhanced BER
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

mrtSymbol = gain' / norm(gain) * symbol;
end

