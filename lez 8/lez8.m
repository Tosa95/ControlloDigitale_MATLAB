clear all
close all

Ts = 1/100;

A = [0.1 1; 1 1];
B = [2.05; 7.88];

X = inv(A)*B;

tau = X(1, 1);
L = X(2, 1);
K = 5; %Guadagno letto direttamente dalla risposta allo scalino del sistema

s = tf([1 0], 1);

G = (K/(tau*s + 1))*exp(-L*s);

%Considero zoh e campionatore come ritardo puro --> cos' mantango la
%struttura del sistema ed aggiungo solo ritardo ad L

Ld = L + Ts/2;

%Usiamo la tabellina per tarare il PI

Kp1 = 0.9*tau/(K*Ld);
Ti1 = 3*Ld;

%FDT del PI

%OSS: é a tempo continuo, ma lo abbiamo tarato come se fosse a tempo discreto 

PI1 = Kp1*(1+1/(Ti1*s));

%Ora discretizziamo con tustin

PI1d = c2d(PI1, Ts, 'tustin');


%Usiamo la tabellina per tarare il PID

Kp2 = 1.2*tau/(K*Ld);
Ti2 = 2*Ld;
Td2 = 0.5*Ld;

%FDT del PID

%OSS: é a tempo continuo, ma lo abbiamo tarato come se fosse a tempo discreto 
N = 5;
PID2 = Kp2*(1+1/(Ti2*s)+s*Td2/(1+(Td2/N)*s));

%Ora discretizziamo con tustin

PID2d = c2d(PID2, Ts, 'tustin');
