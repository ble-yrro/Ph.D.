function[data]=AirbeoCFL(wave,gate,RES,THK,Pos)

%--------------------------------------------------------------------------
% CE PROGRAMME PERMET DE GENERER LES FICHIERS DE COMMANDE DE AIRBEO      
% ET FAIRE UNE MODELISATION EN BOUCLE CENTRALE DU VTEM                    
%                                                                         
%
%INPUT
%RES:                  Resistivite des couches pour chaque modele
%THK:                  Epaisseures des couches pour chaque modele
% Wave(n x 2):         Forme de l'onde du VTEM
% Gate (n x 2):        Centre et largeur des gate du VTEM en ms.

%OUTPUT
% data:          le temps (S) et dB/dt end (nT/s ou nV/m^2) du modele
%--------------------------------------------------------------------------

THK(THK<1)=1+(THK(THK<1)-floor(THK(THK<1)));
xgate=size(gate,1);
xwave=size(wave,1);
xRES=size(RES,1);

%CREATION DU FICHIER DE COMMANDE:CFL--------------------------------------
fid=fopen('airbeo.cfl','w');
header='FORWARD MODELLING OF VTEM';
fprintf(fid,'%s\n',header); %header
fprintf(fid,'%u %u %u %u\n',1,0,0,0);
fprintf(fid,'%u %u %u %u %u %u %f\n',1,xwave,0,1,xgate,2,13.958);

%%%%% INPUT WAVEFORM AS TIME AND AMPERE------------------------------------
wave1=wave';
fprintf(fid,'%.3f  %.3f\n',wave1);

%%%%% INPUT TIME GATE (CENTER AND WITH) OF VTEM----------------------------
fprintf(fid,'%.3f \n',(wave(end,1)+gate(:,1))');
fprintf(fid,'%.3f \n',gate(:,2)');

%%%%% INPUT ACQUISITION GEOMETRY OF VTEM-----------------------------------
fprintf(fid,'%u  %u %u\n',0,13,0);
fprintf(fid,'%u %u\n',531,4);
fprintf(fid,'%u %u %u\n',0,0,0);
fprintf(fid,'%u %u %u %u\n',1,1,0,0);
fprintf(fid,'%u %u %.2f %u %u\n',0, 0, Pos, 0, 10 );
fprintf(fid,'%u %u %u %u\n',xRES ,1,xRES ,0);

%%%% LAYERED EARTH MODEL STRUCTURE-----------------------------------------
      %%% RES
      add=zeros(xRES,6); add(:,1:3)=1;
      RES1=([RES,add])';
      fprintf(fid,'%.2f %u %u %u %u %u %u\n',RES1);
      %%% THK
       THK1=[(1:xRES)',THK(1:end)]; THK1=THK1';
       fprintf(fid,'%u %.2f\n',THK1);

fclose(fid);  clear fid; close all; clear i;

%%% CALCULATE AND READ MODELE RESPONSE-------------------------------------
dos('airbeo');
fid1=fopen('Airbeo.mf1','r');
moov=[];

while isempty(moov); A=fgetl(fid1); moov=strfind(A, 'Line 1000');end
fscanf(fid1,'%f \n',[8 1]);
data=fscanf(fid1,'%f \n',[xgate 1]); fclose(fid1); clear fid1;
end



