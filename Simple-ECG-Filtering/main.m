close all
clear all
clc

                        %%%%%%% ECG Noise removing %%%%%%%
                           
%% read the signal
x = csvread('ekg-sinus-60-bpm-simulator.txt'); 
Fs=250; % sampling frequency
Signal_legth=750; % length
ECG=x(1:Signal_length);
figure; plot (ECG)

%% Fourier Trransform of it
X=fft(ECG); 
figure; plot(abs(X)); 

X1=X; 
X1(1)=0;% Remove DC value
w=linspace(-pi,pi,750); % [0, pi] axis divided into 101 points. periodic with 2pi
figure; plot(w*Fs/(2*pi),abs(fftshift(X1))); % Shifted fft

%% Design Filter
N   = 50;        % FIR filter order
Fp  = 9;       % passband-edge frequency
Fs  = Fs;       % sampling frequency
Rp  = 0.00057565; % passpand error
Rst = 1e-2;       % Stopband error -40 dB stopband attenuation
wpi=2*Fp/Fs;     % Normalized Frequency (xpi rad/sample) 

h = firceqrip(N,wpi,[Rp Rst],'passedge'); % Low pass filter 
% h = firceqrip(N,wpi,[Rp Rst],'high'); % High pass filter

fvtool(h,'Fs',Fs,'Color','White') % Visualize filter


%% Filter the signal in time domain
y=conv(ECG,h,'valid');
figure; plot (y)

figure, subplot (1,2, 1), plot (ECG)
        subplot (1,2, 2), plot (y)% compere original signal and filtered signal with convolution
        
        
        
%% Show the frequency responce of the designed filter        
 H=(fft(h,Signal_legth)); 
 figure;plot(w*Fs/(2*pi),abs(fftshift(H)));

 
%% Filter the signal in the frequency domain 
 Y=X.*H; % Dot product of the fft of ECG signal and frequensy responce of the system
 
 Y1=Y;
 Y1(1)=0;
 figure;plot(w*Fs/(2*pi),abs(fftshift(Y1))); 
 
 
Output2=ifft(Y); % Ýnverse fft
  figure;plot(Output2)
  
%% Compare FFT of original ECG and filtered ECG  
figure, subplot (1,2, 1), plot(abs(fftshift(X1))) % compare fft results
        subplot (1,2, 2), plot(abs(fftshift(Y1)))

%% Compare ECG and filtered ECG         
figure, subplot (1,2, 1), plot (ECG) % compere original signal and filtered signal with frequency domain
        subplot (1,2, 2), plot (Output2)


