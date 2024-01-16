
h_BB_reversedOrder = [.000537807;
        .00139463;
        .00220996;
        .00295945;
        .00362085;
        .00417414;
        .00460335;
        .00489553;
        .00504176;
        .00503797;
        .00488403;
        .00458461;
        .00414875;
        .00358932;
        .00292296;
        .00216946;
        .0013514;
        .00049311;
        -.000379862;
        -.00124158;
        -.00206633;
        -.00282944;
        -.00350827;
        -.00408273;
        -.00453525;
        -.0048529;
        -.00502589;
        -.00504943;
        -.00492232;
        -.00464884;
        -.00423704;
        -.00369884;
        -.00305057;
        -.00231154;
        -.00150365;
        -.000650971;
        .000221087;
        .00108654;
        .0019197;
        .00269563;
        .00339127;
        .00398589;
        .0044619;
        .00480486;
        .0050048;
        .00505555;
        .00495592;
        .00470857;
        .00432106;
        .00380498;
        .00317551;
        .00245142;
        .00165434;
        .000808048;
        -6.23614e-5;
        -.000930938;
        -.00177177;
        -.00255987;
        -.0032717;
        -.00388605;
        -.00438477;
        -.00475272;
        -.00497915;
        -.00505752;
        -.00498501;
        -.00476439;
        -.00440193;
        -.00390802;
        -.003298;
        -.00258968;
        -.0018043;
        -.000965141;
        -9.72931e-5;
        .00077345;
        .00162114;
        .00242062;
        .00314802;
        .00378162;
        .00430254;
        .00469537;
        .00494842;
        .00505407;
        .00500906;
        .00481495;
        .00447745;
        .00400657;
        .00341646;
        .00272461;
        .00195155;
        .00112039;
        .000255874;
        -.000616274;
        -.00147005;
        -.00227998;
        -.00302204;
        -.00367403;
        -.00421675;
        -.00463378;
        -.00491255;
        -.0050453;
        -.00502765;
        -.00486018;
        -.004548;
        -.00410044;
        -.00353067;
        -.00285577;
        -.0020958;
        -.00127338;
        -.0004131;
        .000459508;
        .00131844;
        .00213818;
        .00289422;
        .00356417;
        .00412776;
        .00456858;
        .00487341;
        .00503285;
        .00504256;
        .00490218;
        .00461552;
        .00419148;
        .00364279;
        .00298553;
        .00223929;
        .00142634;
        .000570916;
        -.0003015];

h_sin_reversedOrder = [.0144606;
        -.000314483;
        -.00608996;
        -.00712673;
        -.000692584;
        -.00307861;
        -.0054675;
        -.00417178;
        -.00118382;
        -.00170319;
        -.000219989;
        .000818487;
        -.00123056;
        -.000836062;
        -.000166637;
        -.00207855;
        -.00523423;
        -.00949282;
        -.0112936;
        -.00763129;
        -.00348116;
        -.000934621;
        -.00152648;
        -.0095105;
        -.0128603;
        -.00573485;
        .00105271;
        .00325648;
        -.000228997;
        -.0124861;
        -.0166891;
        -.00282491;
        .0108438;
        .0130692;
        .00027329;
        -.00876356;
        .00525654;
        .0178071;
        .00974529;
        -.0055429;
        -.00798799;
        .00690822;
        .0259709;
        .0220115;
        -.00907921;
        -.0189456;
        .0164405;
        .0477176;
        .0304314;
        -.00633842;
        -.0252037;
        -.00794697;
        .0207013;
        .0170969;
        -.000886977;
        -.0136608;
        -.00831999;
        .015091;
        .0144988;
        -.013666;
        -.0166695;
        .000431226;
        -.00905359;
        -.0144652;
        -.0117696;
        -.0398389;
        -.0454608;
        -.0212377;
        -.0164207;
        -.0155493;
        -.0193871;
        -.0453413;
        -.0268813;
        .0225865;
        .0592996;
        .0679631;
        .0230767;
        -.00328988;
        -.00817222;
        -.00282927;
        .00816974;
        .0007412;
        -.00504165;
        -.00185918;
        .00282672;
        .00122222;
        -.0013299;
        -.00048056;
        .0014094;
        .000832965;
        -.000425268;
        8.22721e-5;
        .00132031;
        .00134825;
        .000267748;
        -.000351102;
        .000206359;
        .00112321;
        .00117956;
        .000523323;
        -.000105814;
        -.000302185;
        -.00082242;
        -.0015134;
        -.00161569;
        -.000986189;
        -.000137549;
        -1.42559e-5;
        -.000210092;
        -5.43118e-6;
        .000661242;
        .00131065;
        .00121281;
        .000508224;
        .000250269;
        .000568651;
        .00039995;
        .000190335;
        .000286376;
        .00060808;
        .00076524;
        .000329223;
        -.000473204;
        -.00098742;
        .000474324;
        .000379436;
        -.00107056;
        -.00397354];

h_BB = flip(h_BB_reversedOrder');
h_sin = flip(h_sin_reversedOrder');

close all

% h_BB: Plot the filter coefficiencts:
figure(1);
stem(h_BB);
title('Filter coefficients of h_{BB}');
xlabel('Samples'); % Added
ylabel('Amplitude'); % Added
axis([0 325 -0.04 0.04])

% H_BB: Plot the magnitude
figure(2);
N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(abs(fft(h_BB, N_fft)));
title('Filter magnitude response of H_{BB}');
xlabel('Frequency f´ = 325f/fs'); %A frequency unit (which?)
ylabel('|H_{BB}|');
axis([0 325 -4 4])

% H_BB: Plot the magnitude
figure(3);
N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(angle(fft(h_BB,N_fft)));
title('Filter phase response of H_{BB}');
xlabel('Frequency f´ = 325f/fs'); %A frequency unit (which?)
ylabel('Phase [rad]');
axis([0 325 -4 4])

%%
close all
figure(4)

subplot(3,1,1)
stem(h_BB);
title('Filter coefficients of h_{BB}(n)');
xlabel('Sample index [n]'); % Added
ylabel('h_{BB}(n)'); % Added
axis([0 325 -0.032 0.032])

fs=16000;

subplot(3,1,2)
%N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(abs(fft(h_BB,fs))); hold on;
title('Filter magnitude response of H_{BB}(n)');
xlabel('Frequency [Hz]'); %A frequency unit (which?)
ylabel('Magnitude |H_{BB}(n)|');
%axis([0 fs 0 0.35])

subplot(3,1,3)
N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(angle(fft(h_BB,fs)));
title('Filter phase response of H_{BB}(n)');
xlabel('Frequency [Hz]'); %A frequency unit (which?)
ylabel('Phase [rad]');
%axis([0 fs -4 4])

figure(5)

subplot(3,1,1)
stem(h_sin);
title('Filter coefficients of h_{sin}(n)');
xlabel('Sample index (n)'); % Added
ylabel('h_{sin}(n)'); % Added
axis([0 325 -0.0012 0.0012])

fs=16000;

subplot(3,1,2)
%N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(abs(fft(h_sin,fs))); hold on;
title('Filter magnitude response of H_{sin}(n)');
xlabel('Frequency [Hz]'); %A frequency unit (which?)
ylabel('Magnitude |H_{sin}(n)|');
%axis([0 fs 0 0.2])

subplot(3,1,3)
N_fft = 325;   %Zero-pad FFT for increased frequency resolution
plot(angle(fft(h_sin,fs)));
title('Filter phase response of H_{sin}(n)');
xlabel('Frequency [Hz]'); %A frequency unit (which?)
ylabel('Phase [rad]');
%axis([0 fs -4 4])

