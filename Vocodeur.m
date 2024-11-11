%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programma principale che realizza un vocoder di fase 
% e permette di:
%
% 1- Modificare il tempo (velocità di "pronuncia")
%    senza modificare il pitch (frequenza fondamentale della voce)
%
% 2- Modificare il pitch
%    senza modificare la velocità 
%
% 3- "Robotizzare" una voce
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Caricamento di un segnale audio
%--------------------------------
[y, Fs] = audioread('Diner.wav');   % Segnale originale
% [y, Fs] = audioread('Extrait.wav');   % Segnale alternativo
% [y, Fs] = audioread('Halleluia.wav'); % Segnale alternativo

% Se il segnale è in stereo, si considera solo una via
y = y(:,1);

% Creazione dei vettori di tempo e frequenza per la visualizzazione
N = length(y);
t = [0:N-1]/Fs;
f = linspace(0, Fs/2, floor(length(y)/2)+1);

% Visualizzazione del segnale originale
figure;
subplot(5,2,1);
plot(t, y);
title('Segnale originale nel dominio del tempo');
xlabel('Tempo (s)');
ylabel('Ampiezza');

subplot(5,2,2);
Y_fft = fft(y);
plot(f, abs(Y_fft(1:floor(length(y)/2)+1)));
title('Spettro del segnale originale');
xlabel('Frequenza (Hz)');
ylabel('Ampiezza');

%% 
%-------------------------------
% 1- MODIFICA DELLA VELOCITÀ (senza modificare il pitch)
%-------------------------------

% Più lento
rapp = 2/4;   % Rapporto di rallentamento
ylent = PVoc(y, rapp, 1024);

% Visualizzazione del segnale rallentato
subplot(5,2,3);
spectrogram(ylent, 256, 128, 256, Fs, 'yaxis');
title('Spettrogramma del segnale rallentato');

% Ascolto del segnale rallentato
sound(ylent, Fs);
pause(length(ylent)/Fs);

% Più veloce
rapp = 4/2;   % Rapporto di velocizzazione
yrapide = PVoc(y, rapp, 1024);

% Visualizzazione del segnale velocizzato
subplot(5,2,4);
spectrogram(yrapide, 256, 128, 256, Fs, 'yaxis');
title('Spettrogramma del segnale velocizzato');

% Ascolto del segnale velocizzato
sound(yrapide, Fs);
pause(length(yrapide)/Fs);

%%
%----------------------------------
% 2- MODIFICA DEL PITCH (senza modificare la velocità)
%----------------------------------

% Parametri generali
Nfft = 256;       % Numero di punti per la FFT/IFFT
Nwind = Nfft;     % Lunghezza della finestra di ponderazione (default: finestra di Hanning)

% Aumento del pitch
a = 2;  b = 4;    % Rapporto di incremento del pitch
yvoc = PVoc(y, a/b, Nfft, Nwind);  % Cambia il pitch senza cambiare la velocità

% Ri-sampla il segnale per mantenere la velocità originale
y_resampled = resample(yvoc, a, b);  % Resampling per correggere la velocità

% Determina la lunghezza minima tra i due segnali
min_len = min(length(y), length(y_resampled));

% Somma tra segnale originale e segnale con pitch modificato
ypitch_mix = y(1:min_len) + 0.5 * y_resampled(1:min_len);

% Visualizzazione del pitch aumentato
subplot(5,2,5);
spectrogram(ypitch_mix, 256, 128, 256, Fs, 'yaxis');
title('Spettrogramma del segnale con pitch aumentato');

% Ascolto del segnale con pitch modificato e sommato all'originale
sound(ypitch_mix, Fs);
pause(length(ypitch_mix)/Fs);

% Diminuzione del pitch
a = 4;  b = 2;   % Rapporto di diminuzione del pitch
yvoc = PVoc(y, a/b, Nfft, Nwind);  % Cambia il pitch senza cambiare la velocità

% Ri-sampla il segnale per mantenere la velocità originale
y_resampled = resample(yvoc, a, b);  % Resampling per correggere la velocità

% Determina la lunghezza minima tra i due segnali
min_len = min(length(y), length(y_resampled));

% Somma tra segnale originale e segnale con pitch diminuito
ypitch_mix = y(1:min_len) + 0.5 * y_resampled(1:min_len);

% Visualizzazione del pitch diminuito
subplot(5,2,6);
spectrogram(ypitch_mix, 256, 128, 256, Fs, 'yaxis');
title('Spettrogramma del segnale con pitch diminuito');

% Ascolto del segnale con pitch diminuito
sound(ypitch_mix, Fs);
pause(length(ypitch_mix)/Fs);

%%
%----------------------------
% 3- ROBOTIZZAZIONE DELLA VOCE
%-----------------------------

% Scelta della frequenza della portante (es. 2000, 1000, 500, 200)
Fc = 500;   % Frequenza di modulazione della portante

% Applica la funzione Rob per la robotizzazione
yrob = Rob(y, Fc, Fs);

% Visualizzazione del segnale robotizzato
subplot(5,2,7);
spectrogram(yrob, 256, 128, 256, Fs, 'yaxis');
title('Spettrogramma del segnale robotizzato');

% Ascolta il segnale robotizzato
sound(yrob, Fs);
pause(length(yrob)/Fs);
