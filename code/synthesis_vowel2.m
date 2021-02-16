%%%%%%%%%%%%%%%%
% Experiment 2 
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%
%Functions used
%variable_data_exp2(), getpitch1, genH2_ImpResp, ramp_fix

% Problems: bw discontinuity

% clear variables;
% clc;

%addpath '/home/arthi/matlab/Functions/spectrogram/' '/home/arthi/matlab/Functions/Auditory toolbox/'; 
function synthesis_vowel(filename,required_snr,vowel,BPnoisefilter)
load('A_filters.mat')
load('U_filters.mat')
load('I_filters.mat')
load('lowpass8000.mat')
if vowel =='u'
    formantfrequencies =[3.003026855940335e+02;7.954768614998890e+02;2.661853608095359e+03;3.978227127882288e+03;5.591652541116806e+03;6.901630916678682e+03];
    disp(formantfrequencies)
    formantbandwidths = [1.702156128071690e+02;7.886552140313381e+02;1.249361505587880e+03;4.272802663130470e+02;9.424358141279184e+02;8.789760848127233e+02] ;
    disp(formantbandwidths)
elseif vowel =='a'
    formantfrequencies =[5.410620709993296e+02;9.069264653368799e+02;3.055827845272298e+03;3.809542593030164e+03;4.908024113732064e+03;6.660463644073904e+03];
    disp(formantfrequencies)
    formantbandwidths = [8.356374707120132e+02;2.786481867958067e+02;5.205773316900729e+02;7.419174777255422e+02;3.695845922647997e+02;8.779549046707975e+02];
    disp(formantbandwidths)
elseif vowel =='i'
    formantfrequencies = [2.712459953495215e+02;2.763097150084811e+03;3.762829467644453e+03;4.389494277055094e+03;6.650358018752457e+03;8000];
    disp(formantfrequencies)
    formantbandwidths = [20.272595032714330;3.639673727978932e+02;7.801873467040509e+02;4.427440303348383e+02;7.527497301968866e+02;3.194431271284122e+03];
    disp(formantbandwidths)
else 
    disp("Invalid vowel")
end
variable_data_exp2();
load('var_data_exp2.mat'); 

t = [0:(T*fs)-1]/fs;

cnt1 = 1;

% %formant frequency and bandwidth
change1= 0; change2 = 0; 
% f_from = form_freq(alpha1,:)*(1+change1) ;
% f_to = form_freq(alpha2,:)*(1+change2);
% [bw_from,bw_to] = bw_adjust(alpha1,alpha2,change1,change2,form_freq);
bandw = formantbandwidths;
formantss = formantfrequencies;
alpha1 = 1; alpha2 = 1; 
i = 1; 
[e,pitch] = getpitch1(t,p1(i),p2(i),p3(i),fs,ptype);

noise1 = wgn(length(e),1,(10*log10((rms(e)^2)/(10^(required_snr/10)))))';

BPnoise  = filter(BPnoisefilter,noise1);
snrr = snr(e,BPnoise);

gamma = (snrr/required_snr);
alpha = ((rms(e)^2)/(rms(BPnoise)^2))^((gamma -1)/gamma);
scaling_factor = sqrt(alpha);
% pwelch(BPnoise * scaling_factor)
excitation = e + (BPnoise * scaling_factor);
check_snr = snr(e,BPnoise .* scaling_factor);


snrr = snr(e,noise1);
excitation = e + noise1;


[a,x1,f1_freq,sigma_freq] = genH1_vowel(fs,formantss,bandw,excitation) ;
x1_rs = resample(x1,48000,fs); 
fs = 48000; 
%env = sin(2*pi*2*t); 
%env = gampdf(t(1:fs+fs/2),3,1/10);
%delay = 20e-3*fs + (100e-3*fs)*rand(1,10);delay = round(delay);
%env_seq = [env zeros(1,delay(1)) env zeros(1,delay(2)) env zeros(1,delay(3)) env zeros(1,delay(4)) ...
%    env zeros(1,delay(5)) env zeros(1,delay(6)) env zeros(1,delay(7)) env zeros(1,delay(8)) env zeros(1,delay(9)) env zeros(1,delay(10))]; 
%env_seq = [env env env env env env env env env env]; 
x = x1_rs; %(1:length(env_seq)).*env_seq; 
filename = 'test4.wav'
reconst_new = ramp_fix(x,fs,t_length_rise_fall); %62.5 ms
[b_coeff,a_coeff] = butter(10,8000/(fs/2)); %butter(20,10000/(fs/2));
r_filt = filter(b_coeff,a_coeff,reconst_new);
reconst1 = r_filt/norm(r_filt) * 15;
audiowrite(filename,reconst1,fs,'Bitspersample',16);
%cnt1 = cnt1+1;
% %
% player = audioplayer(4*reconst1,fs);
% play(player);

generated_decorrelated_signals();
str = ['killall python3'];
unix(str)
str2 = ['python3 play_8chn.py ' 'test4decorrelated.wav' ' &'];
unix(str2)

temporaryvar=5
end