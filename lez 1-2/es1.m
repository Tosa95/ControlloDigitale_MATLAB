%help <nomecomando> da l'help sul comando specificato

clear all %Cancella tutte le variabili preesistenti

num1=10; % ; esegue ma non fa vedere il risultato
den1=[1 1]; %s+1  (metto la lista dei coefficienti dal pi� alto al pi� basso)
den2=[1/100 1]; %s/100+1

%convenzione: nei calcoli non metto il ;

den1=conv(den1,den2) %prodotto tra i due polinomi

%primo modo di definire i sistemi
sys1a=tf(num1,den1) %comando transfert function (va bene anche per i sistemi
                    %a tempo discreto)
                    %crea un oggetto sistema, simile ad una struttura C

 %altro metodo
 %definisco il sistema banale s, poi definisco il mio sistema in funzione
 %di s

 %utile se per esempio ho solo s^100, mi evita di scrivere 100 coefficienti

 %s da solo � un sistema improprio, in natura non esiste

 s=tf([1 0],1); %s/1

 %una volta definiti dei sistemi con il comando tf, posso interconnetterli
 %attraverso le normali operazioni aritmetiche (+, -, *, ^)

 sys1b=10/(0.01*s^2+1.01*s+1) %sistema di prima

 [z1,p1,g1]=zpkdata(sys1a,'v') %resituisce: elenco degli zeri (z1), elenco dei poli (p1)
                               % costante di trasferimento (g1). 'v' serve
                               % a "castare" le uscite in vettori

 bode(sys1a) %diagramma di bode REALE, non asintotico
             %tasto destro->grid per mostrare la griglia
             %accetta anche più sistemi: bode(sys1a, sys1b): li disegna sovrapposti

 [Gm1,Pm2,Wgm1,Wpm1]=margin(sys1a) %calcola il margine di fase (Gm1 = margine
                                   %di guadagno, Pm1=margine di fase, Wgm1=pulsazione
                                   %margine di guadagno, Wpm1=pulsazione di taglio)

 %margine di guadagno: prendo il sistema e lo chiudo su una retroazione
 %proporzionale (moltiplico per una costante K). Il margine di guadagno � il K massimo per cui il sistema
 %resta stabile: indica di quanto posso alzare il diagramma di bode
 %mantenendo un margine di fase positivo

 figure %fa una nuova figura per nyquist in modo da non sovrascrivere bode
 nyquist(sys1a) %mostra il diagramma di nyquist completo

 %posso usarlo per vedere la stabilit� in caso di sistemi instabili e non a
 %fase minima

 %il margine di guadagno in nyquist � la coastante K da moltiplicare per
 %far si che il diagrammma abbracci il pto (-1,0). Dice quanto possiamo
 %"gonfiare" il diagramma
