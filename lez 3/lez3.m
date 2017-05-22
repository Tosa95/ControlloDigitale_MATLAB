clear
close all

num = 10;
den = [0.1 1.1 1];

sys = tf(num, den);

bode(sys);

wc = 30; %Lo prendo dal diagramma di bode guardando la pulsazione a cui si riduce di 40dB rispetto al guadagno
Ts1 = 2*pi/wc; % 2*pi perchè fs è in rad/s (da bode)

%Potevo anche calcolre Ts con l'altro metodo, usando zpkdata e prendendo la
%costante di tempo più bassa [associata al polo più veloce, ossia quello
%più a sx] e moltiplicando per 1/10
%(vedi slides teoria)

[z,p,k]=zpkdata(sys,'v');
Ts2 = (-1/min(real(p)))*1/10;

%scelgo il tempo di campionamento inferiore

Ts = min([Ts1 Ts2]);

%Serie G-campionatore-ZOH
% campionatore divide solo per Ts, che si semplifica con il Ts a num dello
% ZOH

zoh1 = tf (1, 1, 'OutputDelay', Ts/2); %Il num sarebbe Ts, ma non lo mettiamo
sys1 = series(sys, zoh1);

zoh2 = tf (1, [Ts/2 1]); %Padé
sys2 = series(sys, zoh2);

s = tf([1 0], 1);

zoh3 = (1/s)*(1 - exp(-s*Ts))/Ts; %Divido per T perchè cos' inglobo il campionatore
sys3 = series(sys, zoh3);

%Attenzione: fare le operazioni aritmetiche sui sistemi li sovradimensiona:
%non fa le cancellazioni polo-zero. Meglio usare la funzione parallel per
%la somma e series per la serie

%zoh4 = c2d(tf(1,1),Ts,'zoh'); pazzie del prof

figure
hold on

bode(sys1, 'g')
bode(sys2, 'b')
bode(sys3, 'r')
