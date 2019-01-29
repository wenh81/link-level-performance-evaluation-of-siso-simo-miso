clear; close all;
load('ber_set.mat')
nSnr = length(snrPerBitDb);
anaBerBpskQpsk = zeros(nSnr, 1);
%% SIMO MRC
divGainMrc = zeros(nSnr, 1);
for iSnr = 1: nSnr
    % calculate SNR per bit
    snrPerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % analytical BER
    anaBerBpskQpsk(iSnr) = 1 / 2 * (1 - sqrt(snrPerBit / (1 + snrPerBit)));
    divGainMrc(iSnr) = diversity_gain(snrPerBit, numBerQpskMrc(iSnr));
end
figure;
semilogy(snrPerBitDb, anaBerBpskQpsk, 'k:s');
hold on;
semilogy(snrDb, numBerQpskMrc, '-.^');
grid on;
legend('SISO - ZF', 'SIMO - MRC');
title('BER vs SNR comparison of SISO ZF and SIMO MRC');
xlabel('SNR (dB)');
ylabel('BER');
%% MISO MRT
divGainMrt = zeros(nSnr, 1);
for iSnr = 1: nSnr
    % calculate SNR per bit
    snrPerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % analytical BER
    anaBerBpskQpsk(iSnr) = 1 / 2 * (1 - sqrt(snrPerBit / (1 + snrPerBit)));
    divGainMrt(iSnr) = diversity_gain(snrPerBit, numBerQpskMrt(iSnr));
end
figure;
semilogy(snrPerBitDb, anaBerBpskQpsk, 'k:s');
hold on;
semilogy(snrDb, numBerQpskMrt, '-.v');
grid on;
legend('SISO - ZF', 'MISO - MRT');
title('BER vs SNR comparison of SISO ZF and MISO MRT');
xlabel('SNR (dB)');
ylabel('BER');
close;
%% MISO Alamouti
divGainAlamouti = zeros(nSnr, 1);
for iSnr = 1: nSnr
    % calculate SNR per bit
    snrPerBit = 10 .^ (snrPerBitDb(iSnr) / 10);
    % analytical BER
    anaBerBpskQpsk(iSnr) = 1 / 2 * (1 - sqrt(snrPerBit / (1 + snrPerBit)));
    divGainAlamouti(iSnr) = diversity_gain(snrPerBit, numBerQpskAlamouti(iSnr));
end
figure;
semilogy(snrPerBitDb, anaBerBpskQpsk, 'k:s');
hold on;
semilogy(snrDb, numBerQpskAlamouti, '-.v');
grid on;
legend('SISO - ZF', 'MISO - Alamouti');
title('BER vs SNR comparison of SISO ZF and MISO Alamouti');
xlabel('SNR (dB)');
ylabel('BER');
close;
figure;
plot(snrPerBitDb, divGainAlamouti, 'r-.x');
grid on;
legend('Diversity gain');
title('Diversity gain of MISO Alamouti');
xlabel('SNR (dB)');
ylabel('Gain');
close;
%% BER comparison
semilogy(snrDb, numBerQpskAwgn, '-o');
hold on;
semilogy(snrDb, numBerQpskZf, '-*');
hold on;
semilogy(snrDb, numBerQpskMrc, '-.^');
hold on;
semilogy(snrDb, numBerQpskMrt, '-.v');
hold on;
semilogy(snrDb, numBerQpskAlamouti, '--x');
grid on;
legend('SISO - AWGN', 'SISO - ZF', 'SIMO - MRC', 'MISO - MRT', 'MISO - Alamouti');
title('BER vs SNR of QPSK over SISO, SIMO and MISO channels');
xlabel('SNR (dB)');
ylabel('BER');
