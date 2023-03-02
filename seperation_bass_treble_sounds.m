clear all
close all
clc

                      %%%%%% Bass-shrill sound separation %%%%%%        

%% Creating a bass sound (Low frequency sinus can be created and listened)

n=[0:44000-1]; %length
fs=44000; % sampling frequency
f1= 150;s
x1=sin(2*pi*f1.*n/fs); % A sine of 150 Hz sampled at 44000 Hz
sound(x1,44000); % Listening to the Bass sound of the signal

t=linspace(0,1,44001);

figure, plot(t,x1); 
axis([-0.1 1.1 -1.3 1.3 ])

%% Creating a shrill sound (High frequency sinus can be created and listened)
f2=15000;
x2=sin(2*pi*f2.*n/fs); %Sine with 15000 Hz

figure, plot(t,x2); 
axis([-0.1 1.1 -1.3 1.3 ])

sound(x2,44000); %% Listening to the shrill sound of the signal

%% Mixing bass and treble sounds

x3=x1+x2;
figure, plot(t,x3); 
axis([-0.1 1.1 -3 3 ])
sound(x3,44000);
 
%% Frequency response of the signals

%Frequency response of the bass sound (150 Hz)
X1=fft(x1); 
f=linspace(-22000,22000,44001); % (Lets draw between-22000 +22000 -fs/2
figure, plot(f,abs(fftshift(X1))); 


%Frequency response of the treble sound (15000 Hz)
X2=fft(x2); 
figure, plot(f,abs(fftshift(X2))); 


%Frequency response of the mixed sound
X3=fft(x3); % FFT of sum of two signal
figure, plot(f,abs(fftshift(X3))); %

%% Creating a filter to seperate bass and shrill sounds 

N   = 15;        % FIR filter order
Fp  = 3000;       % 3 kHz passband-edge frequency
Fs  = 44000;       % 44 kHz sampling frequency
Rp  = 0.00057565; % passpand error
Rst = 1e-2;       % Stopband error -40 dB (stopband attenuation)
wpi=2*Fp/Fs;     % Normalized Frequency (xpi rad/sample) 

h = firceqrip(N,wpi,[Rp Rst],'passedge'); % Low pass filter
% h = firceqrip(N,wpi,[Rp Rst],'high'); % high pass filter

fvtool(h,'Fs',Fs,'Color','White') % Visualize filter

%% Using the impulse response coefficients of the filter, 
% let's convolve the mixed sound signal and separate the bass treble sound in the time domain.
% y[n]=x[n] * h[n]

y_out_time=conv(x3,h); 

sound(x3,44000); 
sound(y_out_time,44000); 


%% Performing the filtering of the signal in the Frequency domain
% Y(f) = X(f).*H(f) 

H=fft(h,44001); % FFT (H(f)) of the Impulse response (h[n]) 
% H=fft(h); 
figure;plot(abs(fftshift(H)));


Y=X3.*H; 

figure, subplot(4,1,1); plot(f,abs(fftshift(X1))); 
subplot(4,1,2); plot(f,abs(fftshift(X3)));
subplot(4,1,3); plot(f,abs(fftshift(H)));
subplot(4,1,4); plot(f,abs(fftshift(Y))); 

% So we get the FFT of the filtered signal. 
% Back to the time domain with iFFT:

y_out_freq=ifft(Y); 

sound(x3,44000); %Mixed signal
sound(y_out_freq,44000); % Seperated signal through the frequency domain
sound(y_out_time,44000); % Seperated signal through the time domain



