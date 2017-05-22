%esercitazione 7

clear all
close all

%PUNTO 1
%senza fare i conti, scriviamo che la fdt dello zoh è (1-e^-sT)/s la fdt
%del sistema è la G(s) e la fdt del sottosistema analogico è la serie delle
%due
T = 2 * pi / 1000; 

s = tf([1 0], 1);
G = 1/(s * (s + 1));
ZOH = (1-exp(-s*T))/s;
Camp = 1/T;

G_a = G * ZOH * Camp;

%PUNTO 2

%mappatura specifiche
%S1: già fatta perchè integratore già presente

%S3: massima sovraelongazione al 25% --> cerco smorzamento tramite il
%grafico esponenziale
d = 0.45;  % ---> PM > 45°

%S2: tempo assestamento al 2% --> uso formula e trovo wn che consideriamo
%uguale a wt (pulsazione di taglio del sist aperto)
% wn >= 4 / 0.45    --->    Wc > 9

%S4: l'errore entra sulla linea di retroaz --> uso fdt = L / (1+L) -->
%fuori banda considero L piccolo 
%   ---> L(100j)<=-40dB


%eseguiamo lo script e avviamo sisotool(G_a) da linea
%tasto destro (usando freccina) e scegliamo edit compensator
%abbiamo aggiunto uno zero in -0.1 (-10^-1) perchè alzare il grafico avrebbe
%reso il sistema instabile

%{vediamo che la S4 non è rispettata --> aggiungiamo un polo (cosa che
%avremmo dovuto fare comunque dato che abbiamo aggiunto uno zero)
%eseguendo un po' di prove siamo arrivati ad aggiungere 2 poli in -30 in
%modo da mantenere wt almeno 9 e rispettare S4}%

%esportiamo C

%una volta esportato C lo salviamo come file .mat
load('controllore7.mat');
C_d = c2d(tf(C), T, 'tustin');

bode(series(G_a, C))

%apriamo simulink e inseriamo tutti i blocchi necessari ricordando di usare
%come sistema G e non G_a poichè la il blocco "Discrete Transfer Fcn"
%contiene già il campionatore e lo ZOH!


%per l'ultima richiesta dell'esercizio basta aggiungere un saturatore in simulink senza
%cambiare niente


%{
N.B.!!!!!!!!
c'è un mega errore nella definizione del controllore!
per come l'abbiamo fatto vediamo che Bode del modulo rimane per tanto
vicino a 0 prima di tagliare, non va bene perchè non possiamo usare
l'approssimazione in anello chiuso..

Sarebbe bastato aggiungere uno zero per eliminare il polo (s+1), aggiungere
i poli per la S4 e aggiustare un po' il guadagno.
%}
