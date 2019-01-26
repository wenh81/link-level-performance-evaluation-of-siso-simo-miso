clear; close all;
load('ber_set.mat')
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
