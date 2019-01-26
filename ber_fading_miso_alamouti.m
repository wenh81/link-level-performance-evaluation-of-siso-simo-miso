clear; close all;
%% Initialisation
snrPerBitDb = 0: 1: 20;
nSnr = length(snrPerBitDb);
nTxs = 2;
nRxs = 1;
nChannels = nTxs * nRxs;
nRepeats = 2e3;
nBits = 1e4;
nSymbolsQpsk = nBits / 2;
nPairs = nSymbolsQpsk / 2;
powerNoise = 1;
anaBerMrcQpsk = zeros(nSnr, 1);
anaBerAlamoutiQpsk = zeros(nSnr, 1);
numBerQpsk = zeros(nSnr, 1);
%% Bit generation, symbol mapping, channel, ML estimation, and BER
% generate raw bit stream
bitStream = round(rand(1, nBits));
for iSnr = 1: nSnr
    % calculate bit power by SNR
    powerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % map bits to symbols
    symbolQpsk = qpsk(bitStream, powerBit);
    % reset error count
    errorQpsk = 0;
    for iRepeat = 1: nRepeats
        % generate CSCG noise of 2 consecutive slots
        noiseQpsk = sqrt(powerNoise / 2) * (randn(nRxs, nSymbolsQpsk) + 1i * randn(nRxs, nSymbolsQpsk));
        % channel
        [gain] = channel_rayleigh(nChannels);
        gain = gain.';
        gainEff = [gain(1), gain(2); gain(2)', -gain(1)'];
        % Alamouti coding
        [alamoutiSymbolQpsk] = alamouti(symbolQpsk);
        % receiver
        rxSymbolQpsk = gain * alamoutiSymbolQpsk + noiseQpsk;
        rxSymbolQpsk(2: 2: end) = conj(rxSymbolQpsk(2: 2: end));
        % filter by symbol pairs
        for iPair = 1: nPairs
            recSymbolQpsk(2 * iPair - 1: 2 * iPair) = rxSymbolQpsk(2 * iPair - 1: 2 * iPair) * conj(gainEff);
        end
        % decode by maximum-likelihood estimation
        [bitQpsk] = ml_qpsk(recSymbolQpsk);
        % count errors
        errorQpsk = errorQpsk + sum(xor(bitStream, bitQpsk));
    end
    numBerQpsk(iSnr) = errorQpsk / nRepeats / nBits;
    % analytical BER approximation
    snrPerBit = powerBit / powerNoise;
    probMrc = 1 / 2 - 1 / 2 * (1 + 1 / snrPerBit) ^ (- 1 / 2);
    anaBerMrcQpsk(iSnr) = probMrc ^ 2 * (1 + 2 * (1 - probMrc));
    probAlamouti = 1 / 2 - 1 / 2 * (1 + 2 / snrPerBit) ^ (- 1 / 2);
    anaBerAlamoutiQpsk(iSnr) = probAlamouti ^ 2 * (1 + 2 * (1 - probAlamouti));
end
%% Result plots
figure;
semilogy(snrPerBitDb, anaBerMrcQpsk, 'k-o');
hold on;
semilogy(snrPerBitDb, anaBerAlamoutiQpsk, 'k-x');
hold on;
semilogy(snrPerBitDb, numBerQpsk, 'r-.+');
grid on;
legend('Analytical BER: MRC / MRT', 'Analytical BER: Alamouti', 'Numerical BER: Alamouti');
title('BER vs SNR of QPSK over a MISO Rayleigh fading channel with Alamouti coding');
xlabel('SNR (dB)');
ylabel('BER');
% save data
numBerQpskAlamouti = numBerQpsk;
save('ber_set.mat', 'numBerQpskAlamouti', '-append');
