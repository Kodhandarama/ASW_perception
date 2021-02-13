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
if vowel =='u'
    formantfrequencies = [0;8.137379860485678e+02;8.289291450254506e+03;1.128848840293356e+04;1.316848283116524e+04;1.995107405625682e+04;24000];
    disp(formantfrequencies)
    formantbandwidths = [3.458666408519700e+03;15.204446274536176;2.729755295984317e+02;5.851405100281479e+02;3.320580227512421e+02;5.645622976479822e+02;2.395823453461553e+03];
    disp(formantbandwidths)
elseif vowel =='a'
    formantfrequencies = [9.009080567820000e+02;2.386430584500006e+03;7.985560824286130e+03;1.193468138364595e+04;1.677495762334844e+04;2.070489275003444e+04];
    disp(formantfrequencies)
    formantbandwidths = [1.276617096053110e+02;5.914914105230733e+02;9.370211291905515e+02;3.204601997347764e+02;7.068268605940416e+02;6.592320636086818e+02];
    disp(formantbandwidths)
elseif vowel =='i'
    formantfrequencies = [1.623186212997911e+03;2.720779396010570e+03;9.167483535817046e+03;1.142862777909051e+04;1.472407234119623e+04;1.998139093222166e+04];
    disp(formantfrequencies)
    formantbandwidths = [6.267281030342111e+02;2.089861400968550e+02;3.904329987676243e+02;5.564381082943431e+02;2.771884441987015e+02;6.584661785032197e+02];
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
[b_coeff,a_coeff] = butter(10,4000/(fs/2)); %butter(20,10000/(fs/2));
r_filt = filter(b_coeff,a_coeff,reconst_new);
reconst1 = r_filt/norm(r_filt) * 15;
% audiowrite(filename,1000*reconst1,fs,'Bitspersample',32);
%cnt1 = cnt1+1;
%
player = audioplayer(4*reconst1,fs);
play(player);
a=5
end