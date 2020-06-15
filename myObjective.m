
function [RMS]=myObjective(deformparameter,R1,R2,R3,Nano,Vtem)
dim1=size(Nano.DATA');
dim2=size(Vtem.DATA');

NanoFwr=zeros(dim1);
VtemFwr=zeros(dim2);



a1 = 1/3+2/3*cos(deformparameter);
a2 = 1/3+2/3*sin(-pi/6+deformparameter);
a3 = 1/3+2/3*sin(-pi/6-deformparameter);
RES= abs(a1.*R1 + a2.*R2 + a3.*R3);

%----set minimu and maximum value for resistivity----------------
RES(RES< 0.6533)=0.6333;
RES(RES> 2.0976)=2.0976;

RES1=10.^RES;

% FORWARD NANOTEM RESPONSE OF GDM ELECTRICAL MODEL OUTPUT
%--------------------------------------------------------

NanoRES=RES1(:,Nano.Index);
for ii=1:dim1(2)
    Nanodata0=LeroiCFL(Nano.Wave,Nano.Gate,Nano.I(ii),NanoRES(:,ii),Nano.Epaisseur(:,ii));
    Nanodata0(Nano.DATA(ii,:)==0)=0;
    NanoFwr(:,ii)=Nanodata0;          %donnees calculees de nV/m^2 
end



% FORWARD VTEM RESPONSE OF GDM ELECTRICAL MODEL OUTPUT %
%---------------------------------------------------------
VTEMRES=RES1(:,Vtem.Index);

for ii=1:dim2(2)
    
    Vtemdata0=AirbeoCFL(Vtem.Wave,Vtem.Gate,VTEMRES(:,ii),Vtem.Epaisseur(:,ii),Vtem.Clearence(ii));
    Vtemdata0(Vtem.DATA(ii,:)==0)=0;
    VtemFwr(:,ii)=Vtemdata0;             %donnees calculees de nV/m^2 
    
end
VtemFwr=VtemFwr*1000./(Vtem.TX*Vtem.I);  %conversion en pV/A/m^4

% Calcul fct obj avec les donnees non bruitees %
%-------------------------------------------------
NanoFwr1=NanoFwr;      NanoFwr1=NanoFwr1(:);   NanoFwr1=NanoFwr1(NanoFwr1~=0);
NanoObs=Nano.DATA';    NanoObs=NanoObs(:) ;    NanoObs=NanoObs(NanoObs~=0);

VtemFwr=VtemFwr(:);    VtemFwr=VtemFwr(VtemFwr~=0);
VtemObs=Vtem.DATA'; VtemObs=VtemObs(:); VtemObs=VtemObs(VtemObs~=0);



WSERR1=(NanoFwr1-NanoObs)./((NanoObs+NanoFwr1)/2); %weighted symetric error Nano
SQWSERR1=WSERR1.^2;                      %square of weighted symetric error Nano
SUMSQWSERR1=sum(SQWSERR1);               %sum of the square of weighted symetric error Nano

WSERR2=(VtemFwr-VtemObs)./((VtemObs+VtemFwr)/2);       %weighted symetric error Vtem
SQWSERR2=WSERR2.^2;                      %square of weighted symetric error Vtem
SUMSQWSERR2=sum(SQWSERR2);                %sum of the square of weighted symetric error Vtem

SUMSQ=SUMSQWSERR1+SUMSQWSERR2;
NDATA=Nano.NDATA+Vtem.NDATA;

RMS=sqrt(SUMSQ/NDATA);         %RMSerror (residual error)


end



