function Inv_AirbeoCFL(wave,gate,Guess)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CE PROGRAMME PERMET DE GENERER LES FICHIERS DE COMMANDE DE AIRBEO       %
%  EN BOUCLE CENTRALE DU VTEM                                             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT

% Wave(n x 2):                matrice forme de l'onde du transmeteur
% Gate (n x 2):               matrice contenant le centre, le debut et la fin des fenetres d'enregistrement
%GuessModel:                  Matrice du modele initial

%OUTPUT
%CFL                         commande file containing acquisition and VTEM parameters          

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Nxgate,Nygate]=size(gate);
[Nxwave,Nywave]=size(wave);
NLAYER=size(Guess,1);


    

fid=fopen('airbeo.cfl','w');
header='Airbeo commande file VTEM data inversion : L1001';
fprintf(fid,'%s\n',header); %header
fprintf(fid,'%u %u %u %u',1,1,0,0);
d='!TDFD, DO1D, PRFL, ISTOP';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u %u %u %u %u %u %f',1,849,0,1,Nxgate,2,13.958);
d1='!ISW, NSX, STEP, UNITS, NCHNL, KRXW, OFFTIME';
fprintf(fid,'            %s\n',d1);
for i=1:size(wave,1)-1
    fprintf(fid,'%f  %f\n',wave(i,1),wave(i,2));
end
fprintf(fid,'%f  %f   ',wave(849,1),wave(849,2));
d='! TXON, WAVEFORM(849)';
fprintf(fid,'                     %s\n',d);

for i=1:Nxgate-1
    fprintf(fid,'%f \n',wave(849,1)+gate(i,3));
end
fprintf(fid,'%f  ',wave(849,1)+gate(Nxgate,3));
d='! TMS(44 centre)';
fprintf(fid,'                     %s\n',d);

for i=1:Nxgate-1
    fprintf(fid,'%f\n',gate(i,2)-gate(i,1));
end
fprintf(fid,'%f     ',gate(Nxgate,2)-gate(Nxgate,1));
d='! WIDTH(44)';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u  %u %u ',0,13,0);
d='! TXCLN, CMP, KPPM';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u %u',531,4);
d='! TXAREA, NTRN';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u %u %u',0,0,0);
d='! ZRX, XRX, YRX(1)';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u',1);
d='!NPASS';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u %u %u %u',NLAYER,1,NLAYER,0);
d='! NLAYER, QLYR, NLITH, GND_LEVEL';
fprintf(fid,'                     %s\n',d);
for i=1:NLAYER
    fprintf(fid,'%u %u %u %u %u %u %u',Guess(i,1),1,1,1,0,0,0);
    d='! RES, SIG_T, RMU, REPS, CHRG, CTAU, CFREQ(1) - Layer';
    fprintf(fid,'                     %s\n',d);
end
for i=1:NLAYER-1
   
    fprintf(fid,'%u %u ',i,Guess(i,2));
    d='!LITH, THK';
    fprintf(fid,'                     %s\n',d);
end
fprintf(fid,'%u ',NLAYER);
d='!LITH, THK';
fprintf(fid,'                     %s\n',d);
fprintf(fid,'%u %u %u %u %u ',90,1,14,1,2);
d='! MAXITS, CNVRG, NFIX, MV1PRT, OUTPRT';
fprintf(fid,'                     %s\n',d);

%------------APPLIED CONSTRAINT------------------------------
fprintf(fid,'%u %u %u %.1f %u %u',3,1,2,0.2,Guess(1,2),Guess(1,2)+Guess(1,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,2,2,0.2,Guess(2,2),Guess(2,2)+Guess(2,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,3,2,0.2,Guess(3,2),Guess(3,2)+Guess(3,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,4,2,0.2,Guess(4,2),Guess(4,2)+Guess(4,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,5,2,0.2,Guess(5,2),Guess(5,2)+Guess(5,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,6,2,0.2,Guess(6,2),Guess(6,2)+Guess(6,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,7,2,0.2,Guess(7,2),Guess(7,2)+Guess(7,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);


fprintf(fid,'%u %u %u %.1f %u %u',3,8,2,0.2,Guess(8,2),Guess(8,2)+Guess(8,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,9,2,0.2,Guess(9,2),Guess(9,2)+Guess(9,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,10,2,0.2,Guess(10,2),Guess(10,2)+Guess(10,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);


fprintf(fid,'%u %u %u %.1f %u %u',3,11,2,0.2,Guess(11,2),Guess(11,2)+Guess(11,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,12,2,0.2,Guess(12,2),Guess(12,2)+Guess(12,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,13,2,0.2,Guess(13,2),Guess(13,2)+Guess(13,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);

fprintf(fid,'%u %u %u %.1f %u %u',3,14,2,0.2,Guess(14,2),Guess(14,2)+Guess(14,2)*0.5);
d='! CTYPE, LYR_INDX, KPAR,ELAS(KPAR), LBND(KPAR), UBND(KPAR)';
fprintf(fid,'                     %s\n',d);



%------------------END CONSTRAINE------------------------------------------



fclose(fid);
clear fid;
close all;
clear i;
end