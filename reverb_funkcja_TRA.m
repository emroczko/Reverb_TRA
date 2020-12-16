%
% FUNKCJA REVERB - ERYK MROCZKO - TRA PROJEKT
%
% Poniższa funkcja jest wywoływana za pomocą bardzo długiej listy
% argumentów: 
%
% function [x_reverb, fs] = reverb(fileNumber, combDelay, combGain, 
%                           allPassDelays, allPassGains, wetGain, dryGain)
% 
%%%%%%%% x_reverb - jest to sygnał wyjściowy z reverbu 
%%%%%%%%fs - częstotliwośc próbkowania pliku
% 
%%%%%%%% fileNumber - numer pliku
% 1 - perkusja Roland TR626
% 2 - gitara Stratocaster - gęste akordy
% 3 - gitara Telecaster - pojedyncze zagrania akordów
%
% Te dwa elementy są zmieniane wewnatrz funkcji na podstawie 
%podanej jednej danej
%%%%%%%% combDelay - opóźnienie filtrów grzebieniowych
%%%%%%%% combGain - wzmocnienie filtrów grzebieniowych 
% 
%%%%%%%% allPassDelays - wektor opóźnień filtrów wszechprzepustowych
%%%%%%%% allPassGains - wektor wzmocnień filtrów wszechprzepustowych
%%%%%%%% wetGain - wzmocnienie sygnału Wet
%%%%%%%% dryGain - wzmocnienie sygnału Dry
%
% Poniżej, kilka przykładowych użyć funkcji: 
% aby odsłuchać sygnał , wpisujemy w command window sound(x, fs), gdzie x = x1,x2,x3... 

[x1, fs] = reverb(2, 2000, 0.7, [1200; 1000; 5000], [0.7; 0.7; 0.5], 0.5, 1);
[x2, fs] = reverb(2, 1800, 0.6, [3000; 500; 400], [0.4; 0.8; 0.6], 0.7, 0.7);
[x3, fs] = reverb(2, 2100, 0.7, [500; 500; 500], [0.6; 0.7; 0.9], 0.5, 0.8);
[x4, fs] = reverb(2, 2000, 0.6, [2000; 1000; 1000], [0.4; 0.5; 0.2], 0.9, 0.4);
[x5, fs] = reverb(2, 2000, 0.7, [1800; 1500; 2000], [0.7; 0.6; 0.3], 0.4, 1);
[x6, fs] = reverb(2, 1600, 0.6, [1500; 4000; 100], [0.8; 0.4; 0.2], 0.8, 1);



function [x_reverb, fs] = reverb(fileNumber, combDelay, combGain, allPassDelays, allPassGains, wetGain, dryGain)

%sprawdzenie czy podane przez uzytkownika wzmocnienia nie są większe od 1
if combGain > 1 
    combGain = 0.7;
elseif combGain < 0
    combGain = 0.3 ;
end

for n = 1:length(allPassGains)
    if allPassGains(n) > 1
        allPassGains(n) = 0.7;
    elseif allPassGains(n) < 0
        allPassGains(n) = 0.3;
    end
end

%wybór pliku dźwiękowego
switch fileNumber
    case 1 
        [x,fs] = audioread("strat.wav");
    case 2 
        [x,fs] = audioread("626.wav");
    case 3 
        [x,fs] = audioread("tele.wav");
end

%konwersja pliku dźwiękowego ze stereo do mono i transpozycja macierzy
x = x(:,1);
x= x.';

% filtr grzebieniowy 
B = @(delay,gain) gain.*[1 zeros(1,delay-1) 0.7];

%implementacja filtrów grzebieniowych
x_f1 = filter(B(combDelay      ,combGain),1,x);
x_f2 = filter(B(combDelay + 250,combGain.*0.99),1,x);
x_f3 = filter(B(combDelay + 500,combGain.*1.01),1,x);
x_f4 = filter(B(combDelay + 750,combGain),1,x);

%suma sygnałów z filtrów
x_comb_sum = x_f1 + x_f2 + x_f3 + x_f4;

%zmniejszenie amplitudy sygnałów z filtrów
x_comb_sum = 0.5.*x_comb_sum;


temp = x_comb_sum;

%filtracja filtrami wszechprzepustowymi



for n = 1:3   
    x_allpass_filt = allPass(temp,allPassGains(n), allPassDelays(n));
    temp = x_allpass_filt;
  
end

%suma sygnałów wet oraz dry wraz z ograniczeniem lub ew. wzmocnieniem amplitudy 

x_reverb = wetGain.*x_allpass_filt + dryGain.*x;

end

% funkcja która tworzy filtr wszechprzepustowy
function filtered_signal = allPass(signal ,gain, delay)
    b = [gain zeros(1,delay-1) 1];
    a = [1 zeros(1,delay-1) gain];
    
    filtered_signal = filter(b, a, signal);
end



