% clc;
% clear all;

[vowela,fs] =  audioread("natural_vowel_A.wav");
segmentlen = 100;
noverlap = 90;
NFFT = 128;
 
% spectrogram(vowela,segmentlen,noverlap,NFFT,fs,'yaxis')
% title('Signal Spectrogram')

dt = 1/fs;
I0 = round(3/dt);
Iend = round(3.03/dt);
x = vowela(I0:Iend);
% x=vowela;
% spectrogram(x,segmentlen,noverlap,NFFT,fs,'yaxis');
signal =x;
yn =fft(signal);
n = length(signal);     % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(yn).^2/n;    % power of the DFT
% 
% plot(f,power,'r')
% xlabel('Frequency')
% ylabel('Power')
% hold on;
x1 = filter(lowpass4000,x);%order200 equiripple FIR filter
% x1 = x.*hamming(length(x));
x2 =  resample(x,1,6);

signal =x2;
yn =fft(signal);
n = length(signal);     % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(yn).^2/n;    % power of the DFT
% 
plot(f,power,'r')
xlabel('Frequency')
ylabel('Power')

% spectrogram(x2,segmentlen,noverlap,NFFT,fs,'yaxis');
A = lpc(x2,30);
rts = roots(A);

rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));

[frqs,indices] = sort(angz.*(fs/(2*pi)));
bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));

nn = 1;
formants=[];
bws=[];
for kk = 1:length(frqs)
    if (frqs(kk)<5500)
        formants(end+1) = frqs(kk);
        bws(end+1) = bw(kk);
        disp("Formant_freq")
        disp(frqs(kk));disp("bw");disp(bw(kk))
%         nn = nn+1;
    end
end
fprintf('%.2f\n',formants)
disp("__________________")
fprintf('%.2f\n',bws)




