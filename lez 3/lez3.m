clear
close all

num = 10;
den = [0.1 1.1 1];

sys = tf(num, den);

bode(sys);

%Potevo anche calcolre fs con l'altro metodo, usando zpkdata e prendendo la
%costante di tempo più bassa (vedi slides teoria)

fs = 30; %Lo prendo dal diagramma di bode guardando la pulsazione a cui si riduce di 40dB rispetto al guadagno

Ts = 2*pi/fs; % 2*pi perchè fs è in rad/s (da bode)

%Serie G-campionatore-ZOH
% campionatore divide solo per Ts, che si semplifica con il Ts a num dello
% ZOH

zoh1 = tf (1, 1, 'OutputDelay', Ts/2); %Il num sarebbe Ts, ma non lo mettiamo
zoh2 = tf (1, [Ts/2 1]); %Padé

s = tf([1 0], 1);

zoh3 = (1/s)*(1 - exp(-s*Ts))/Ts; %Divido per T perchè cos' inglobo il campionatore

%zoh4 = c2d(tf(1,1),Ts,'zoh'); pazzie del prof

figure
hold on

bode(sys * zoh1, 'g')
bode(sys * zoh2, 'b')
bode(sys * zoh3, 'r')
