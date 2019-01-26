clear; close all;
%% Initialisation
snrPerBitDb = 0: 1: 20;
nSnr = length(snrPerBitDb);
nTxs = 1;
nRxs = 1;
nChannels = nTxs * nRxs;
nBits = 1e6;
nSymbolsBpsk = nBits;
nSymbolsQpsk = nBits / 2;
powerNoise = 1;
anaBerBpskQpsk = zeros(nSnr, 1);
numBerBpsk = zeros(nSnr, 1);
numBerQpsk = zeros(nSnr, 1);
%% Bit generation, symbol mapping, channel, ML estimation, and BER
% generate raw bit stream
bitStream = round(rand(1, nBits));
for iSnr = 1: nSnr
    % calculate bit power by SNR
    powerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % map bits to symbols
    txSymbolBpsk = bpsk(bitStream, powerBit);
    txSymbolQpsk = qpsk(bitStream, powerBit);
    % generate CSCG noise
    noiseBpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsBpsk) + 1i * randn(nRxs, nSymbolsBpsk));
    noiseQpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsQpsk) + 1i * randn(nRxs, nSymbolsQpsk));
    % receiver
    rxSymbolBpsk = txSymbolBpsk + noiseBpsk;
    rxSymbolQpsk = txSymbolQpsk + noiseQpsk;
    % decode by maximum-likelihood estimation
    [bitBpsk] = ml_bpsk(rxSymbolBpsk);
    [bitQpsk] = ml_qpsk(rxSymbolQpsk);
    % compare result and calculate BER
    numBerBpsk(iSnr) = sum(xor(bitStream, bitBpsk)) / nBits;
    numBerQpsk(iSnr) = sum(xor(bitStream, bitQpsk)) / nBits;
    % calculate SNR per bit
    snrPerBit = powerBit / powerNoise;
    % analytical BER (BPSK = QPSK) by Q-function
    anaBerBpskQpsk(iSnr) = qfunc(sqrt(2 * snrPerBit));
end
%% Result plots
figure;
semilogy(snrPerBitDb, anaBerBpskQpsk, 'k-o');
hold on;
semilogy(snrPerBitDb, numBerBpsk, 'b-.x');
hold on;
semilogy(snrPerBitDb, numBerQpsk, 'r-.+');
grid on;
legend('Analytical BER: BPSK / QPSK', 'Numerical BER: BPSK', 'Numerical BER: QPSK');
title('BER vs SNR of BPSK & QPSK over AWGN channel');
xlabel('SNR (dB)');
ylabel('BER');
% save data
numBerQpskAwgn = numBerQpsk;
save('ber_set.mat', 'snrPerBitDb', 'numBerQpskAwgn', '-append');
