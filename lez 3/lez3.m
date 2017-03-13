clear
close all

num = 10;
den = [0.1 1.1 1];

sys = tf(num, den);

bode(sys);

fs = 30; %Lo prendo dal diagramma di bode guardando la pulsazione a cui si riduce di 40dB rispetto al guadagno
Ts1 = 2*pi/fs; % 2*pi perch� fs � in rad/s (da bode)

%Potevo anche calcolre fs con l'altro metodo, usando zpkdata e prendendo la
%costante di tempo pi� bassa [associata al polo pi� veloce, ossia quello
%pi� a sx] e moltiplicando per 1/10
%(vedi slides teoria)

[z,p,k]=zpkdata(sys,'v');
Ts2 = (-1/min(real(p)))*1/10;

%scelgo il tempo di campionamento inferiore

Ts = min([Ts1 Ts2]);

%Serie G-campionatore-ZOH
% campionatore divide solo per Ts, che si semplifica con il Ts a num dello
% ZOH

zoh1 = tf (1, 1, 'OutputDelay', Ts/2); %Il num sarebbe Ts, ma non lo mettiamo
zoh2 = tf (1, [Ts/2 1]); %Pad�

s = tf([1 0], 1);

zoh3 = (1/s)*(1 - exp(-s*Ts))/Ts; %Divido per T perch� cos' inglobo il campionatore

%Attenzione: fare le operazioni aritmetiche sui sistemi li sovradimensiona:
%non fa le cancellazioni polo-zero. Meglio usare la funzione parallel per
%la somma e series per la serie

%zoh4 = c2d(tf(1,1),Ts,'zoh'); pazzie del prof

figure
hold on

bode(sys * zoh1, 'g')
bode(sys * zoh2, 'b')
bode(sys * zoh3, 'r')
