function [alamoutiSymbol] = alamouti(symbol)
% Function: 
%   - space-time coding based on Alamouti scheme
%   - encode the symbols on multiple antennas before transmission
%
% InputArg(s):
%   - symbol: symbol to be transmitted on multiple transmit antennas
%
% OutputArg(s):
%   - alamoutiSymbol: transmit symbol on transmitters
%
% Restraint(s):
%   - suitable for 2-transmitter case
%   - requires rebuild for more than 2 transmitters
%
% Comments:
%   - assume channel is unchanged over 2 consecutive slots
%   - does not require CSIT but require CSIR
%   - no spatial diversity -> array(beamforming) gain = 1
%   - 3dB worse than MRC, MRT
%   - fixed capacity, enhanced BER
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

alamoutiSymbol = zeros(2, length(symbol));
% data on tx 1
alamoutiSymbol(1, 1: 2: end) = symbol(1: 2: end);
alamoutiSymbol(1, 2: 2: end) = -symbol(2: 2: end)';
% data on tx 2
alamoutiSymbol(2, 1: 2: end) = symbol(2: 2: end);
alamoutiSymbol(2, 2: 2: end) = symbol(1: 2: end)';
alamoutiSymbol = sqrt(1 / 2) * alamoutiSymbol;
end

