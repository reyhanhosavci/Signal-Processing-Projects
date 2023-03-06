%% EEG Dataset - Information
% The complete data set consists of five sets (denoted A–E) each containing
% 100 single channel EEG segments. These segments were selected and cut out
% from continuous multi-channel EEG recordings after visual inspection for
% artifacts, e.g., due to muscle activity or eye movements. Sets A and B
% consisted of segments taken from surface EEG recordings that were carried
% out on five healthy volunteers using a standardized electrode placement
% scheme.

% **** Volunteers were relaxed in an awake state with eyes open (A) and
% eyes closed (B), respectively. Sets C, D, and E originated from EEG
% archive of presurgical diagnosis. Segments in set D were recorded from
% within the epileptogenic zone, and those in set C from the hippocampal
% formation of the opposite hemisphere of the brain.
% **** While sets C and D contained only activity measured during seizure
% free intervals,
% **** set E only contained seizure activity.

% Dataset taken from this website:
% http://epileptologie-bonn.de/cms/front_content.php?idcat=193&lang=3&changelang=3

%% Loading data

load setA.mat
load setB.mat
load setC.mat
load setD.mat
load setE.mat

%% Demonstration of EEG signals
figure;
subplot(5,1,1); plot(setA(1,:)), title('set A');
subplot(5,1,2); plot(setB(1,:)), title('set B');
subplot(5,1,3); plot(setC(1,:)), title('set C');
subplot(5,1,4); plot(setD(3,:)), title('set D');
subplot(5,1,5); plot(setE(1,:)), title('set E');


%% FEATURE EXTARCTION
%% Shannon entropy - Energy - Standard Deviation

for i=1:50 
    shannonEntropy(i,1)= wentropy(setA(i,:),'shannon');
    shannonEntropy(i,2)= wentropy(setD(i,:),'shannon');
    
    a1=mat2gray(setA(i,:));
    energyEEG(i,1)= sum(abs(a1.^2));
    a4=mat2gray(setD(i,:));
    energyEEG(i,2)= sum(abs(a4).^2);
    
    stdValue(i,1)= std(setA(i,:));
    stdValue(i,2)= std(setD(i,:));
end

% Comparison of setA and setD in terms of energy, entropy and std.dev.
figure,
plot(shannonEntropy) % first feature
title('Shannon Entropy'),
legend('set A','set D',...
    'Location','NorthEastOutside')
figure,
plot(energyEEG)  % second feature
title('Energy'),
legend('set A','set D',...
    'Location','NorthEastOutside')
figure,
plot(stdValue, '-',...  % third feature
    'LineWidth',2,...
    'MarkerSize',10 );
title('Standard Deviation Values'),
legend('set A','set D',...
    'Location','NorthEastOutside')



%% Wavelet Spectrum
% db4 wavelet spectrum of one of A set, db4 wavelet
% spectrum of one of D set.
% At lower frequencies, the A dataset has higher amplitude values than the
% D dataset. In this study, amplitudes values in a certain frequency range
% are summed up to distinguish bet ween normal and epileptic subjects.
figure,
wpt = wpdec(setA(1,:),6,'db4'); % db4 wavelet time-frequency localization is shown.
[S,T,F] = wpspectrum(wpt,4097 ,'plot');
impixelinfo

figure,
wpt = wpdec(setD(1,:),6,'db4');
[S2,T,F] = wpspectrum(wpt,173.61 ,'plot');
impixelinfo

for i=1:50

    wpt1 = wpdec(setA(i,:),6,'db4');
    [S1,T1,F1] = wpspectrum(wpt1,4097);
    sumWps(i,1)=sum(sum(S1(1:50,:)));
      
    wpt2 = wpdec(setD(i,:),6,'db4');
    [S2,T2,F2] = wpspectrum(wpt2,4097);
    sumWps(i,2)=sum(sum(S2(1:50,:)));
    

end

figure, plot(sumWps)  % fourth feature
title('Summation of Wavelet spectrum estimates - ummation- Daubechies of order 4 '),
legend('set A','set D',...
    'Location','NorthEastOutside')