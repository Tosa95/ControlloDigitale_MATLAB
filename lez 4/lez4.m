clear all
close all

%si può inserire un sistema a tempo discreto usando direttamente tf, ma
%dando anche il Ts

Ts = 1/10; %calcolato con il metodo della costante di tempo

s = tf ([1 0], 1);

sys = (10*s + 1)/((s + 1)*(2*s+1));

systd = c2d(sys, Ts, 'zoh') %Converto da continuo a discreto con zoh

bode (sys, systd);