figure('color',[1 1 1])
bb=comb-1;
RMS=zeros(bb,1);
Deformparameter=zeros(bb,1);

for iii=1:bb
    RMS(iii,1)=FINAL1(iii).RMS;
    Deformparameter(iii,1)=FINAL1(iii).deformparameter;
end

%----plot Global RMS-----------------------
subplot(2,2,1)
plot(RMS,'-')
ylabel('Obj fct')
xlim([0 bb])
%ylim([10 60])
% ylim([18 50])
title('DECROISSANCE FCT OBJECTIF ')
xlabel('ITERATION');

%---plot Individual RMS-----------------------------
subplot(2,2,2)
x=FINAL1(1,iii).VtemRMS*100;
cdfplot(x)
title('VTEM' )
xlabel(' RMS [%]');
ylabel([])
%---plot Individual RMS-----------------------------
subplot(2,2,3)
iii=13;
x1=FINAL1(1,iii).NanoRMS*100;

bar(x1)
title('NanoTEM' )
ylabel('RMS [%]');
xlabel('STATION')
%-----PLOT time FOR CONVERGENCE-------------------------

time=zeros(bb,1);
for iii=1:bb
    time(iii,1)=FINAL1(iii).Time;
end
subplot(2,2,4)
bar(time)
ylabel('[ms] ')
xlabel('ITERATION');
title('Temps mis par itération')
xlim([0 bb+0.5])
name='ConvergenceL2000';
print(name, '-dpng', '-r300')
%%
%--------------PLOT SIMULATION---------------------------------------------
%shading(0,1)                  0:interp ; 1:flat
%Caxismin,Caxismax             Colorbar minimum and maximum  value
%------------------------------------------------------------------------


RESOPT=zeros(Kcells,Icells,bb);

for m=1:bb
    
    RESOPT(:,:,m)=FINAL1(m).ROPT;
    
end

load smoothindex;
%Cmp1=colormap('jet');

RES1=RESOPT(:,:,[1 2 248 249]);

minc2=0.9677031; maxc2= log10(80);%2.0890932;
% minc2=log10(14); maxc2= 1.81;
GRAPH=[0 minc2 maxc2]; 
 GRAPH=[0 0.3 1.7782]; 

n=1;
while n<=bb
    IN=zeros(Kcells,Icells,4);
    t=1;
    for i=n:n+3;
        IN(:,:,t)=RES1(:,:,i);
        t=t+1;
    end
    Titre=n:n+3;
   [X,Y,A1, A2,A3,A4]=SIMPLOT(IN,Position,Titre,GRAPH,Cmp1,6); 
    
    name=strcat('IT#',num2str(n),'IT#',num2str(n+3));
     print(name, '-dpng', '-r100')
    n=n+4;
    
end

%% ----PLOT ADJUSTEMENT---------------------------

VTEMOBS=Vtem.DATA';
VTEMOPT=FINAL1(bb).VtemFwr;

v=1;
t=1;
while v<=4 %size(VTEMOBS,2)
    figure(t)
    subplot(2,2,1)
    loglog(Vtem.Gate(:,1),VTEMOBS(:,v),'r',Vtem.Gate(:,1),VTEMOPT(:,v),'b')
    legend('Obs','Cal')
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    title(strcat('ST',num2str(v)))
    c=round(FINAL1(comb-1).VtemRMS(1,v)*100)/100;
    add=strcat('RMS=',num2str(c*100),' %');
     text(2,1,add)
    
    subplot(2,2,2)
    loglog(Vtem.Gate(:,1),VTEMOBS(:,v+1),'r',Vtem.Gate(:,1),VTEMOPT(:,v+1),'b')
    legend('Obs','Cal')
    title(strcat('ST',num2str(v+1)))
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    c=round(FINAL1(comb-1).VtemRMS(1,v+1)*100)/100;
    add=strcat('RMS=',num2str(c*100),' %');
    text(2,1,add)
    
    subplot(2,2,3)
    loglog(Vtem.Gate(:,1),VTEMOBS(:,v+2),'r',Vtem.Gate(:,1),VTEMOPT(:,v+2),'b')
    legend('Obs','Cal')
    title(strcat('ST',num2str(v+2)))
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
     c=round(FINAL1(comb-1).VtemRMS(1,v+2)*100)/100;
    add=strcat('RMS=',num2str(c*100),' %');
    text(2,1,add)
    
    subplot(2,2,4)
    loglog(Vtem.Gate(:,1),VTEMOBS(:,v+3),'r',Vtem.Gate(:,1),VTEMOPT(:,v+3),'b')
    legend('Obs','Cal')
    title(strcat('ST',num2str(v+3)))
    
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
     c=round(FINAL1(comb-1).VtemRMS(1,v+3)*100)/100;
    add=strcat('RMS=',num2str(c*100),' %');
    text(2,1,add)
    v=v+4;
    t=t+1;
end


%% ----PLOT ADJUSTEMENT Nano---------------------------

NanoOBS=Nano.DATA';
NanoOPT=FINAL(bb).NanoFwr;
indexi=[ 14 15 16 17 18 19 20 21 22 23 24 25 26 27 33];
v=1;
t=1;
while v<=size(NanoOBS,2)
    figure(t)
    subplot(2,2,1)
    loglog(Nano.Gate(:,1),NanoOBS(:,v),'r',Nano.Gate(:,1),NanoOPT(:,v),'k')
    legend('Obs','Cal')
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    title(strcat('T16-',num2str(indexi(v))))
    
    subplot(2,2,2)
    loglog(Nano.Gate(:,1),NanoOBS(:,v+1),'r',Nano.Gate(:,1),NanoOPT(:,v+1),'k')
    legend('Obs','Cal')
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    title(strcat('T16-',num2str(indexi(v+1))))
    
    subplot(2,2,3)
    loglog(Nano.Gate(:,1),NanoOBS(:,v+2),'r',Nano.Gate(:,1),NanoOPT(:,v+2),'k')
    legend('Obs','Cal')
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    title(strcat('T16-',num2str(indexi(v+2))))
    
    subplot(2,2,4)
    loglog(Nano.Gate(:,1),NanoOBS(:,v+3),'r',Nano.Gate(:,1),NanoOPT(:,v+3),'k')
    legend('Obs','Cal')
    xlabel('[ms]')
    ylabel('[nV.m^-2]')
    title(strcat('T16-',num2str(indexi(v+3))))
    
    
    v=v+4;
    t=t+1;
end













