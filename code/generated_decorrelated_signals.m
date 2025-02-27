function generated_decorrelated_signals(filename)
N = 500000; % sample size
Fs= 48000;
t = (1:N)*(1/Fs);
 
% 1 second =  48000 samples
% 30 ms = 1440 samples

[vowel_sound,Fs] = audioread('single_channel_stimuli.wav');
r = 615;
sound_array_1 = [zeros(1,r) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r)];
r2 = 547;
sound_array_2 = [zeros(1,r2) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r2)];

r3 = 40;
sound_array_3 = [zeros(1,r3) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r3)];

r4 = 946;
sound_array_4 = [zeros(1,r4) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r4)];

r5 = 335;
sound_array_5 = [zeros(1,r5) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r5)];

r6 = 58;
sound_array_6 = [zeros(1,r6) ,vowel_sound' , zeros(1, 500000 -length(vowel_sound) - r6)];


N_channel_array = zeros(500000,6);
% N_channel_array(:,1) = sound_array_1./2;
% N_channel_array(:,2) = sound_array_2./2;
N_channel_array(:,3) = sound_array_3./2;
% N_channel_array(:,4) = sound_array_4./2;
% N_channel_array(:,5) = sound_array_5./2;
% N_channel_array(:,6) = sound_array_6./2;

audiowrite(filename,N_channel_array,48000)

end
