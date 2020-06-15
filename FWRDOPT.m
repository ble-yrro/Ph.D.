
function [NanoFwr,NanoRMS,VtemFwr,VtemRMS]=FWRDOPT(ROPT,Nano,Vtem)

dim1=size(Nano.DATA');
dim2=size(Vtem.DATA');

NanoFwr=zeros(dim1);
VtemFwr=zeros(dim2);

ROPT=10.^ROPT;

% FORWARD NANOTEM RESPONSE OF GDM ELECTRICAL MODEL OUTPUT
%--------------------------------------------------------

NanoRES=ROPT(:,Nano.Index);
NanoRMS=zeros(1,dim1(2));

for ii=1:dim1(2)
    Nanodata0=LeroiCFL(Nano.Wave,Nano.Gate,Nano.I(ii),NanoRES(:,ii),Nano.Epaisseur(:,ii));
    Nanodata0(Nano.DATA(ii,:)==0)=0;
    NanoFwr(:,ii)=Nanodata0;          %donnees calculees de nV/m^2 
    
    %CALCUL RMS individuel------------
    N1=Nano.DATA(ii,:)'; N1=N1(N1~=0);
    N2=Nanodata0; N2=N2(N2~=0);
    lg=length(N2);
   r1=(N2-N1)./((N1+N2)/2); 
   r2=cumsum(r1.^2); 
   r2=r2(end);
   NanoRMS(ii)=sqrt( r2/lg);
end


% FORWARD VTEM RESPONSE OF GDM ELECTRICAL MODEL OUTPUT %
%---------------------------------------------------------
VTEMRES=ROPT(:,Vtem.Index);
VtemRMS=zeros(1,dim2(2));

for ii=1:dim2(2)
    
    Vtemdata0=AirbeoCFL(Vtem.Wave,Vtem.Gate,VTEMRES(:,ii),Vtem.Epaisseur(:,ii),Vtem.Clearence(ii));
    Vtemdata0(Vtem.DATA(ii,:)==0)=0;
    VtemFwr(:,ii)=Vtemdata0;          %donnees calculees de nV/m^2 
    
    
    %CALCUL RMS individuel------------
    V1=Vtem.DATA(ii,:)'; V1=V1(V1~=0);
    V2=Vtemdata0*1000./(Vtem.TX*Vtem.I); V2=V2(V2~=0);
    lg=length(V2);
   r1=(V2-V1)./((V1+V2)/2); 
   r2=cumsum(r1.^2); 
   r2=r2(end);
   VtemRMS(ii)=sqrt( r2/lg);
    
end
VtemFwr=VtemFwr*1000./(Vtem.TX*Vtem.I);  %conversion en pV/A/m^4




end



