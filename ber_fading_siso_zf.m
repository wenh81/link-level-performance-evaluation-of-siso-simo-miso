clear; close all;
%% Initialisation
snrPerBitDb = 0: 1: 20;
nSnr = length(snrPerBitDb);
nTxs = 1;
nRxs = 1;
nChannels = nTxs * nRxs;
nRepeats = 1e4;
nBits = 1e4;
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
    % reset error count
    errorBpsk = 0;
    errorQpsk = 0;
    for iRepeat = 1: nRepeats
        % generate CSCG noise
        noiseBpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsBpsk) + 1i * randn(nRxs, nSymbolsBpsk));
        noiseQpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsQpsk) + 1i * randn(nRxs, nSymbolsQpsk));
        % channel
        [gain] = channel_rayleigh(nChannels);
        % receiver
        rxSymbolBpsk = gain * txSymbolBpsk + noiseBpsk;
        rxSymbolQpsk = gain * txSymbolQpsk + noiseQpsk;
        % zero-forcing (inverse channel)
        zfSymbolBpsk = rxSymbolBpsk / gain;
        zfSymbolQpsk = rxSymbolQpsk / gain;
        % decode by maximum-likelihood estimation
        [bitBpsk] = ml_bpsk(zfSymbolBpsk);
        [bitQpsk] = ml_qpsk(zfSymbolQpsk);
        % count errors
        errorBpsk = errorBpsk + sum(xor(bitStream, bitBpsk));
        errorQpsk = errorBpsk + sum(xor(bitStream, bitQpsk));
    end
    numBerBpsk(iSnr) = errorBpsk / nRepeats / nBits;
    numBerQpsk(iSnr) = errorQpsk / nRepeats / nBits;
    % calculate SNR per bit
    snrPerBit = powerBit / powerNoise;
    % analytical BER
    anaBerBpskQpsk(iSnr) = 1 / 2 * (1 - sqrt(snrPerBit / (1 + snrPerBit)));
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
title('BER vs SNR of BPSK & QPSK over a SISO Rayleigh fading channel');
xlabel('SNR (dB)');
ylabel('BER');
% save data
numBerQpskZf = numBerQpsk;
save('ber_set.mat', 'numBerQpskZf', '-append');
