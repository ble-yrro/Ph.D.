clear all; clc;

load XDATA                     % db/dt pV.A^-1.m^-4
load Gate                      % gate [start, end, centre, width](en ms)
load Wave                       % waveform ([ms A])


%-----------------------SYSTEM PARAMETER-----------------------------------
Tx_area=531;
Tx_turn=4;
I= 248.281;
M=I*Tx_area*Tx_turn;
mu=4*pi*1e-7;
T=Gate(:,3).*1e-3;

XDATA2=XDATA1.*(M*1e-3);      %conversion de pV.A^-1.m^-4  en nT/s
XDATA2(isnan(XDATA2))=0;
[xdata,ydata]=size(XDATA2);

%---------------------DEFINE STARTING MODELE-------------------------------
NPAR=15;

THK0=logspace(log10(5),log10(30),14);
RES0=zeros(NPAR,1)+50;
model0=zeros(NPAR,2);
model0(:,1)=RES0;  model0(:,1)=RES(:,4589);  
model0(1:end-1,2)=THK0';


%---------------- CREATION DU FICHIER .CFL--------------------------------
Inv_AirbeoCFL(Wave,Gate,model0)

%------------------ INVERSION OUTPUT MATRIX--------------------------------

XMODEL=zeros(ydata,xdata);
VERR=zeros(ydata,xdata);

RES=zeros(NPAR,xdata);
THK=zeros(NPAR-1,xdata);
DPH=zeros(NPAR-1,xdata);
CDTCE=zeros(NPAR-1,xdata);

RMS=zeros(xdata,1);
IMPORT=zeros(2*NPAR-1,xdata);


%-------------------DEBUT INVERSION----------------------------------------


for tt=1:xdata
    
    
    if XDATA2(tt,1)~=0
        
        
        [DATA0,MODEL0,SENSITIVITY]=Inv_Airbeoinv(XDATA2(tt,:),Position(tt,4),model0);
        
        XMODEL(:,tt)=DATA0(:,2);
        VERR(:,tt)=DATA0(:,1);
        
        RES(:,tt)=MODEL0(:,1);
        DPH(:,tt)=MODEL0(1:end-1,2);
        THK(:,tt)=MODEL0(1:end-1,3);
        CDTCE(:,tt)=MODEL0(1:end-1,4);
        
        RMS(tt)=SENSITIVITY(end);
        IMPORT(:,tt)=SENSITIVITY(1:end-1);
        
    else
        
        XMODEL(:,tt)=NaN;
        VERR(:,tt)=NaN;
        
        RES(:,tt)=NaN;
        DPH(:,tt)=NaN;
        THK(:,tt)=NaN;
        CDTCE(:,tt)=NaN;
        
        RMS(tt)=NaN;
        IMPORT(:,tt)=NaN;
        
    end
    
    
    
    %save RES
    
end


%-------------------PLOT PSEUDO-2D SECTION---------------------------------
%GRAPH(1)=Xtype(station=0   Easting=1; Northing=2)
%GRAPH(2)=Ztype(depth=0   Altitude=1)
%GRAPH(3)=interptype(interp=0   flat=1 )
%GRAPH(4:6)=(Cmin,Cmax,npar)
%--------------------------------------------------------------------------
load RES
NPAR=14;
GRAPH=[2 1 0  4 60 NPAR];
FIN=DPH(end,:);

Pseudo2D(XDATA1(1:tt,:),IMPORT(:,1:tt),RES(:,1:tt),DPH(:,1:tt),RMS(1:tt),Position(1:tt,:),GRAPH,FIN(1:tt));


MAXDPH= max(DPH(end,:));           %plot TDEM stations
dir=GRAPH(1);
TDEM2FORAGE(PosTDEM,ID, MAXDPH,dir)
print('inv2000', '-dpng','-r300')



%-----------PLOT HISTOGRAM AND CDF--------------------------------
res=RES(:); res=log10(res(isnan(res)));

f=figure('color',[1 1 1]);
a1 = axes('Parent',f);
hist(res,4)
a2 = axes('Parent',f);
cdfplot(res)
grid off
set(a2,'Color','none')
set(a2,'YAxisLocation','right')
grid(a2)
ylabel('')
xlabel('log10\rho')
name='CDFRES';
print(name, '-dpng')


%-------CALCUL DISTANCE INTER SATION---------------------------------------


dist=sqrt((Position(1:end-1,1)-Position(2:end,1)).^2+(Position(1:end-1,2)-...
Position(2:end,2)).^2+(Position(1:end-1,3)-Position(2:end,3)).^2);




