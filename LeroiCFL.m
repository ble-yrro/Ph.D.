function [data]=LeroiCFL(wave,gate,I,RES,THK)
%--------------------------------------------------------------------------
% CE PROGRAMME PERMET DE GENERER LES FICHIERS DE COMMANDE DE LEROI        
% ET FAIRE UNE MODELISATION 1D du NanoTem  en BOUCLE CENTRALE                                                  
%

% INPUT
% wave(n x 2):                      matrice forme de l'onde du transmeteur
% gate (n x 1):                     vecteur des fenetres d'enregistrement
% RES(NLAYER,n):                    vecteur resistivite des modeles
%THK(NLAYER-1,n):                   vecteur epaisseur des modeles

%OUTPUT
%data:                              Fwrd (nT/s) equivaut au nV/m^2
%--------------------------------------------------------------------------
wave(2:3,2)=I;
 
xgate=size(gate,1);
xwave=size(wave,1);
xRES=size(RES,1);

% CREATION DU FICHIER DE COMMANDE: CFL-------------------------------------
fid=fopen('Leroi.cfl','w');
header='Leroi commande file Nanotem data inversion';
fprintf(fid,'%s\n',header); %header
fprintf(fid,'%u %u %u %u %u\n',1,0,0,1,0);
fprintf(fid,'%u %u %u %u %f %f\n',0,xwave,xgate,2,3.9078,3.9047);

%%%%% INPUT WAVEFORM AS TIME AND AMPERE------------------------------------
wave1=wave';
fprintf(fid,'%.3f  %.3f\n',wave1);

%%%%% INPUT TIME GATE (CENTER AND WITH)------------------------------------
fprintf(fid,'%.3f \n',(gate(:,1))');
fprintf(fid,'%.3f \n',gate(:,2)');

%%%%% INPUT ACQUISITION GEOMETRY ------------------------------------------
fprintf(fid,'%u\n',1);
fprintf(fid,'%u %u %u %u %u %u\n',1,1,1,1,4,1);
fprintf(fid,'%u %u\n',4,0);
fprintf(fid,'%u %u\n',0,20);
fprintf(fid,'%u %u\n',20,20);
fprintf(fid,'%u %u\n',20,0);
fprintf(fid,'%u %u\n',0,0);
fprintf(fid,'%u %u %u %u %u\n',2000,1,1,1,11);
fprintf(fid,'%u %u %u %u %u %u\n',3,0,0,3,0,1);
fprintf(fid,'%u %u %u\n',20/2,20/2,0);
fprintf(fid,'%u %u %u\n',xRES,0,xRES);

%%%% LAYERED EARTH MODELE STRUCTURE ---------------------------------------
      %%% RES
      add=zeros(xRES,6); add(:,1)=-1; add(:,2:3)=1; add(:,end)=1;
      RES1=([RES,add])';
      fprintf(fid,'%.2f %u %u %u %u %u %u\n',RES1);
      %%% THK
       THK1=[(1:xRES)',THK(1:end)]; THK1=THK1';
       fprintf(fid,'%u %.2f\n',THK1);

fclose(fid);  clear fid; close all; clear i;

%%% CALCULATE AND READ MODELE RESPONSE-------------------------------------
dos('Leroi');
fid1=fopen('Leroi.mf1','r');
B=[];

while isempty(B);A=fgetl(fid1); B=strfind(A, 'Line'); end

fscanf(fid1,'%s ',[4 1]);
data=fscanf(fid1,'%f \n',[xgate 1]);
fclose(fid1);
clear fid1;
end


