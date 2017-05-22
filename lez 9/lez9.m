clear all
close all

%G=1/((z-0.2)*(z-0.1))

Tc = 0.01;  %tempo di campionamento
Tsim = 10;

z = tf([1 0], 1, Tc);

G = 1/((z-0.2)*(z-0.1));

bode(G)
step(G)

% FDT in anch = K/den
% Dal grafico scelgo i poli 0.7 +- 0.2i in base alle specifiche

den = (z - (0.7 + 0.2i))*(z - (0.7 - 0.2i)); %Denominatore della fdt in anch

% Calcolo K sapendo che è richiesto errore 0 sullo scalino (pongo K uguale
% al valore del denominatore in 1)

K = evalfr(den, 1);

Gcl = K/den;

step(Gcl);

%minreal semplifica poli e zeri

C1 = minreal((1/G) * Gcl/(1-Gcl));
 
% Richiesta 2: Controllore deadbeat
% Gcldb = 1/z^p (p = n° poli sistema)

Gcldb = 1/z^2;

C2 = minreal((1/G) * Gcldb/(1-Gcldb));

step(Gcldb);

% Richiesta 3: Zero instabile in 3, guadagno invariato

Gzero = (z-3)*G;

K = 1/evalfr((z-3), 1); % Divido per la differenza di guadagno dovuta al nuovo zero

Gzero = K * Gzero;

[z,p,k] = zpkdata (Gzero, 'v');

% Ora usiamo le formule per deadbeat con zeri instabili

K = 1; % Quantità di zeri instabili
k = 1; % Grado relativo di Gzero
L = 0; % Poli instabili
P = 1; % No poli in 1

% Sistema (vedi slides)
%
% K + k + d = g(Gcl)
% L + p + f = g(Gcl)
% d + 1 + f = g(Gcl)
%
% incognite: d, f, g(Gcl)
% Giro le equazioni per trovare i termini noti e trovo le matrici

A = [1 -1 0; 0 -1 1; 1 -1 1];

B = [-2;-1;-1];

x = A\B; %inv(A)*B

d = x(1);
gGcl = x(2);
f = x(3);

% Uso formuline dalle slides per trovare Gcl

% Gcl = (1-3*z^(-1))*z^(-1)*(M0) 
% 1-Gcl = (1-z^(-1))*(1+a1*z^(-1))

% Estraggo 1 - Gcl dalle 2 equazioni e poi eguaglio i coefficienti di egule
% grado dei 2 polinomi che risultano


% Grado -1: -M0 = a1-1
% Grado -2: 3M0 = -a1

% -M0-a1=-1
% 3M0+a1=0

A=[-1 -1; 3 1];

B = [-1; 0];

x = A\B;

M0 = x(1);
a1 = x(2);

z = tf([1 0], 1, Tc);

Gcl3 = minreal((1-3*z^(-1))*M0*z^(-1));

step(Gcl3);

C3 = minreal((1/Gzero) * Gcl3/(1-Gcl3));

