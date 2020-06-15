function[OBJ,OBJ1,OBJ2]=MSE1(VtemFwr,Vtem)



VtemFwr=VtemFwr(:); VtemFwr=VtemFwr(VtemFwr~=0)/1.15;     %pV/A/m^4                                
VtemObs=Vtem.DATA'; VtemObs=VtemObs(:);  VtemObs=VtemObs(VtemObs~=0); %pV/A/m^4                


WSERR=(VtemFwr-VtemObs);                %symetric error Vtem

DENO1=VtemObs;
WSERR1=(VtemFwr-VtemObs)./DENO1;       %symetric error normalisee par VtemObs  Vtem

DENO2=(VtemObs+VtemFwr)/2;
WSERR2=(VtemFwr-VtemObs)./DENO2;       %symetric error normalisee par VtemObs  Vtem

SQWSERR=WSERR.^2;                      %square symetric error Vtem
SQWSERR1=WSERR1.^2;                      %square symetric error Vtem
SQWSERR2=WSERR2.^2;                      %square symetric error Vtem


SUMSQWSERR=sum(SQWSERR);               %sum of the square of symetric error Vtem
SUMSQWSERR1=sum(SQWSERR1);               %sum of the square of symetric error Vtem
SUMSQWSERR2=sum(SQWSERR2);               %sum of the square of symetric error Vtem


SUMSQ=SUMSQWSERR;
SUMSQ1=SUMSQWSERR1;
SUMSQ2=SUMSQWSERR2;


NDATA=Vtem.NDATA;

OBJ=SUMSQ/NDATA;    %pV^2/A^2/m^8 
OBJ1=sqrt(SUMSQ1/NDATA);
OBJ2=sqrt(SUMSQ2/NDATA);


end