
clc
close all

% Load student-written functions
funs = student_sols();

% Call your function to get the generated filter coefficients
h = funs.gen_filter();

figure();
stem(h);
title('Filter coefficients');

figure();
N_fft = 1e3;   
plot(abs(fft(h, N_fft)));
title('Filter magnitude response');

figure();
plot(unwrap(angle(fft(h, N_fft))));
title('Filter phase response');
