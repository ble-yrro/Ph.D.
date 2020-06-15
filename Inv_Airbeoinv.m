function[DATA0,MODEL,SENSITIVITY]=Inv_Airbeoinv(XDATA,Hauteur,Guess)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CE PROGRAMME PERMET DE GENERER LES FICHIERS DE COMMANDE DE AIRBEO       %
% ET INVERSER LES DONNEES EN BOUCLE CENTRALE DU VTEM                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT

%XDATA:                       dB/dt(nT/s)
% hauteur                   ground clearence (m)

%OUTPUT


%XMODEL:                      dB/dt(nT/s) fitting des donnees
%RES:                       rho modele final qui fit les donnees
%THK:                     thick modele final qui fit les donnees
%DEPH:                     depth modele final qui fit les donnees

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NDATA=length(XDATA(XDATA~=0));
NPAR=size(Guess,1);



MODEL=zeros(NPAR,4);
SENSITIVITY=zeros(2*NPAR,1);
DATA0=zeros(44,2);
%% CREATION DU FICHIER inv POUR AIRBEO INVERSION (contient les donnees a inverser)


fid1=fopen('airbeo.inv','w');
d='/   XDATA Line1001 of Vtem st-hyacinthe project Geotech';
fprintf(fid1,'%s\n',d);
d='/';
fprintf(fid1,'%s\n',d);
fprintf(fid1,'%u %u %u %u %u ',1,2,0,3,1);
d='! NSTAT, SURVEY, BAROMTRC, KCMP, ORDER';
fprintf(fid1,'                 %s\n',d);
X=find(XDATA~=0);
fprintf(fid1,'%u',XDATA(X(end)));
d='! XDATA floor';
fprintf(fid1,'           %s\n',d);
fprintf(fid1,'%u %u %u',0,0,0);
d='! N0STAT, N0CHNL, N0PTS';
fprintf(fid1,'           %s\n',d);
fprintf(fid1,'%u %u %u %u   ',1001,0,0,Hauteur);

fprintf(fid1,' %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e\n'...
    , XDATA(1),XDATA(2),XDATA(3),XDATA(4),XDATA(5),XDATA(6), XDATA(7), XDATA(8), XDATA(9), XDATA(10), XDATA(11),XDATA(12),XDATA(13),XDATA(14)...
    ,XDATA(15),XDATA(16), XDATA(17), XDATA(18), XDATA(19), XDATA(20), XDATA(21), XDATA(22),XDATA(23),XDATA(24),XDATA(25),XDATA(26),XDATA(27)...
    , XDATA(28), XDATA(29), XDATA(30), XDATA(31), XDATA(32),XDATA(33),XDATA(34),XDATA(35),XDATA(36),XDATA(37), XDATA(38), XDATA(39), XDATA(40)...
    , XDATA(41), XDATA(42),XDATA(43),XDATA(44));
fclose(fid1);
clear fid1;
dos('airbeo');

fid3=fopen('Airbeo.out','r');
moov=[];
while isempty(moov);A=fgetl(fid3);moov=strfind(A, 'Final Model after');end
moov=[];
while isempty(moov);A=fgetl(fid3);moov=strfind(A, '-----  -----------');end


for i=1:NPAR-1; MOD=fscanf(fid3,'%f \n',[5 1]); MOD=MOD(2:end)'; MODEL(i,:)=MOD;end
MOD=fscanf(fid3,'%f \n',[2 1]); MOD=MOD(2); MODEL(end,1)=MOD;

moov=[];
while isempty(moov);A=fgetl(fid3);moov=strfind(A, 'RES_01');end
IMPORT=fscanf(fid3,'%f \n',[2*NPAR-1 1]);
SENSITIVITY(1:end-1,1)=IMPORT;

moov=[];
while isempty(moov);RMS1=fgetl(fid3);moov=strfind(RMS1, 'Symmetric RMS error');end
SENSITIVITY(end,1)=str2double(RMS1(26:30));

moov1=[];
while isempty(moov1);A=fgetl(fid3);moov1=strfind(A, 'CHNL_34'); end


    DAT1=fscanf(fid3,'%f \n',[44 1]); DATA0(:,1)=DAT1;
    DAT2=fscanf(fid3,'%f \n',[44 1]); DATA0(:,2)=DAT2;
    

fclose(fid3);
clear fid3;

end

