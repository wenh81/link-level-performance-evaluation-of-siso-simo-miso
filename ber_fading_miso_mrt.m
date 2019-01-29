clear; close all;
%% Initialisation
snrPerBitDb = 0: 1: 20;
nSnr = length(snrPerBitDb);
nTxs = 2;
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
snrAvgBpsk = zeros(nSnr, 1);
snrAvgQpsk = zeros(nSnr, 1);
arrayGainMrt = zeros(nSnr, 1);
divGainMrt = zeros(nSnr, 1);
%% Bit generation, symbol mapping, channel, ML estimation, and BER
% generate raw bit stream
bitStream = round(rand(1, nBits));
for iSnr = 1: nSnr
    % calculate bit power by SNR
    powerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % map bits to symbols
    symbolBpsk = bpsk(bitStream, powerBit);
    symbolQpsk = qpsk(bitStream, powerBit);
    % reset error count
    errorBpsk = 0;
    errorQpsk = 0;
    snrBpsk = zeros(nRepeats, 1);
    snrQpsk = zeros(nRepeats, 1);
    for iRepeat = 1: nRepeats
        % generate CSCG noise
        noiseBpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsBpsk) + 1i * randn(nRxs, nSymbolsBpsk));
        noiseQpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsQpsk) + 1i * randn(nRxs, nSymbolsQpsk));
        % channel
        [gain] = channel_rayleigh(nChannels);
        gain = gain.';
        % maximum ratio transmission
        [txSymbolBpsk] = mrt(symbolBpsk, gain);
        [txSymbolQpsk] = mrt(symbolQpsk, gain);
        % receiver
        rxSymbolBpsk = gain * txSymbolBpsk + noiseBpsk;
        rxSymbolQpsk = gain * txSymbolQpsk + noiseQpsk;
        % decode by maximum-likelihood estimation
        [bitBpsk, snrBpsk(iRepeat)] = ml_bpsk(rxSymbolBpsk);
        [bitQpsk, snrQpsk(iRepeat)] = ml_qpsk(rxSymbolQpsk);
        % count errors
        errorBpsk = errorBpsk + sum(xor(bitStream, bitBpsk));
        errorQpsk = errorBpsk + sum(xor(bitStream, bitQpsk));
    end
    snrAvgBpsk(iSnr) = mean(snrBpsk);
    snrAvgQpsk(iSnr) = mean(snrQpsk);
    numBerBpsk(iSnr) = errorBpsk / nRepeats / nBits;
    numBerQpsk(iSnr) = errorQpsk / nRepeats / nBits;
    % analytical BER (BPSK = QPSK)
    snrPerBit = powerBit / powerNoise;
%     % approximated value
%     anaBerApprox(iSnr) = (4 * snrPerBit) ^ (-nTxs) * nchoosek(2 * nTxs - 1, nTxs);
    % accurate value
    prob = 1 / 2 - 1 / 2 * (1 + 1 / snrPerBit) ^ (- 1 / 2);
    anaBerBpskQpsk(iSnr) = prob ^ 2 * (1 + 2 * (1 - prob));
    arrayGainMrt(iSnr) = snrAvgQpsk(iSnr) / snrPerBit;
    divGainMrt(iSnr) = diversity_gain(snrPerBit, numBerQpsk(iSnr));
end
%% Result plots
% BER comparison
figure(1);
semilogy(snrPerBitDb, anaBerBpskQpsk, 'k-o');
hold on;
semilogy(snrPerBitDb, numBerBpsk, 'b-.x');
hold on;
semilogy(snrPerBitDb, numBerQpsk, 'r-.+');
grid on;
legend('Analytical BER: BPSK / QPSK', 'Numerical BER: BPSK', 'Numerical BER: QPSK');
title('BER vs SNR of BPSK & QPSK over a MISO Rayleigh fading channel with MRT transmission');
xlabel('SNR (dB)');
ylabel('BER');
% array and diversity gains
figure(2);
plot(snrPerBitDb, arrayGainMrt, 'k-o');
hold on;
plot(snrPerBitDb, divGainMrt, 'r-.x');
grid on;
legend('Array gain', 'Diversity gain');
title('Array and diversity gains of MISO MRT');
xlabel('SNR (dB)');
ylabel('Gain');
% save data
numBerQpskMrt = numBerQpsk;
save('ber_set.mat', 'numBerQpskMrt', 'arrayGainMrt', 'divGainMrt', '-append');
