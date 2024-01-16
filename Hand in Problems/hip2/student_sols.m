
function [funs, student_id] = student_sols()

student_id = 19980501;

ls = load('hip2.mat');

fs   = 1;   

fcut  = 0.01 ;
fstop = 0.02;
N = 300;

Hf = [0, fcut, fstop, fs/2] /(fs/2);        
Ha = [0,1,0,0] .*Hf*pi *fs;    
hd = firpm(N,Hf,Ha,'differentiator');

figure();
stem(0:N,hd)
xlabel('samples');
ylabel('Amplitude');
title('Impulse response of FIR filter');
hold on 
grid on
xlim([0 N])
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','h_imp_resp'),'epsc')

[H,w] = freqz(hd,1,512);
figure();
plot(Hf,Ha, w/pi,abs(H),'LineWidth',2);
legend('Ideal','firpm Design')
xlabel('Normalized frequency');
ylabel('Magnitude');
title('Frequency response of FIR filter');
hold on 
grid on
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','Habs'),'epsc')


Nsamples = length(ls.observation);

dt=1;
he = [1/dt , -1/dt];
vob = conv(ls.observation, he) *3600;
vob = vob(1:Nsamples) ;
vsi = conv(ls.signal, he) *3600;
vsi = vsi(1:Nsamples);
te = (0:Nsamples-1)/dt;

vfo = conv(ls.observation, hd) *3600;
vfs = conv(ls.signal, hd) *3600;
tfl   = (0:length(vfo)-1)/dt;

lc = lines(6);

figure();
axis([0 600 0 220])
xlabel('time');
ylabel('velocity [km/h]');
hold on 
grid on
plot(te,vsi,'-','Color',lc(1,:),'LineWidth',3);
plot(tfl,vfo,'-','Color',lc(2,:),'LineWidth',3);
plot(tfl,vfs,'--','Color','k','LineWidth',3);
legend({'Euler - true', 'FIR - measured','FIR - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-delayed'),'epsc')


figure();
axis([0 600 0 220])
xlabel('time');
ylabel('velocity [km/h]');
hold on 
grid on
plot(te,vsi,'-','Color',lc(1,:),'LineWidth',3);
plot(tfl(N/2:end)-N/2,vfo(N/2:end),'-','Color',lc(2,:),'LineWidth',3);
plot(tfl(N/2:end)-N/2,vfs(N/2:end),'--','Color','k','LineWidth',3);
legend({'Euler - true', 'FIR - measured','FIR - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-delay-corr'),'epsc')


figure();
xlabel('time');
ylabel('velocity [km/h]');
title('Euler true and measured velocity');
hold on 
grid on
plot(te,vob,'--','Color',lc(2,:),'LineWidth',1);
plot(te,vsi,'Color',lc(1,:),'LineWidth',2);
legend({'Euler - measured','Euler - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-noise'),'epsc');


funs.gen_filter = @() h_diff;

end

