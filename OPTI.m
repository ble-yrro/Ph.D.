 %------ORGANIZE TEST to L2000-------------------
 
load TEST1; L2000(1).TEST=FINAL1;
load TEST2; L2000(2).TEST=FINAL1;
load TEST3; L2000(3).TEST=FINAL1;
load TEST4; L2000(4).TEST=FINAL1;
load TEST5; L2000(5).TEST=FINAL1;
load TEST6; L2000(6).TEST=FINAL1;
load TEST7; L2000(7).TEST=FINAL1;
load TEST8; L2000(8).TEST=FINAL1;
load TEST9; L2000(9).TEST=FINAL1;
load TEST10; L2000(10).TEST=FINAL1;

%---CHOOSE OPTIMUM FOR EACH TEST---------------

a=size(L2000);
OPTIFINAL_TEST=zeros(Kcells,Icells,a(2)); %modele optimum iteration pour chaque test
OPTI1_TEST=zeros(Kcells,Icells,a(2));     %modele optimum iteration 1 pour chaque test
RMS=zeros(500,a(2));                      %rms pour toutes les iterations de chaque test
DefPar=zeros(500,a(2));                   % parametre de deformation pour toutes les iteration de chaque test
Time=zeros(500,a(2));                     % temps mis en s pour chaque iteration de chaque test
EvalObjf=zeros(500,a(2));                 % nombre d evaluation de la fct objs par iteration pour chaque iteration de chaque test
for i=1:a(2)
    
        OPTIFINAL_TEST(:,:,i)=L2000(i).TEST(1,end).ROPT;
        OPTI1_TEST(:,:,i)=L2000(i).TEST(1,1).ROPT;
        
        
        B=L2000(i).TEST;
        b=size(B);
        for j=1:b(2);
            RMS(j,i)=L2000(i).TEST(1,j).RMS;
            DefPar(j,i)=round(L2000(i).TEST(1,j).deformparameter*100)/100;
            Time(j,i)=L2000(i).TEST(1,j).Time;
            EvalObjf(j,i)=L2000(i).TEST(1,j).Iteration;
        end
        
        
end

%---plot parametre de deformation pour les iterations de tous les test
RMS(RMS==0)=NaN;
figure('color',[1 1 1])
subplot(2,2,1)
plot(RMS(:,6),'--r','Linewidth',2);
hold on
plot(RMS(:,7),'--b','Linewidth',2);

plot(RMS(:,10),'-k','Linewidth',2);

plot(RMS(:,8),'-.m','Linewidth',2);
plot(RMS(:,9),'-.c','Linewidth',2);
legend('IT1','IT2','IT5','IT3','IT4')
xlim([0,500]);
ylim([0.15, 0.35])
xlabel('Iteration')
ylabel('RMS')
grid on
title('RMS')

%---plot parametre de deformation pour les iterations de tous les test
DefPar(DefPar==0)=NaN;
subplot(2,2,2)
plot(DefPar(:,6),'--r','Linewidth',2);
hold on
plot(DefPar(:,7),'--b','Linewidth',2);

plot(DefPar(:,10),'-k','Linewidth',2);
plot(DefPar(:,8),'-.m','Linewidth',2);
plot(DefPar(:,9),'-.c','Linewidth',2);
legend('IT1','IT2','IT5','IT3','IT4')
xlim([0,500]);
ylim([-2, 2])
xlabel('Iteration')
ylabel('Parametre de déformation')
grid on
title('DefPar')

%---plot parametre de deformation pour les iterations de tous les test
Time(Time==0)=NaN;
subplot(2,2,3)
plot(Time(:,6),'--r','Linewidth',2);
hold on
plot(Time(:,7),'--b','Linewidth',2);

plot(Time(:,10),'-k','Linewidth',2);
plot(Time(:,8),'-.m','Linewidth',2);
plot(Time(:,9),'-.c','Linewidth',2);
legend('IT1','IT2','IT5','IT3','IT4')
xlim([0,500]);
%ylim([-2, 2])
xlabel('Iteration')
ylabel('Time [s]')
grid on
title('Time')

%---plot parametre de deformation pour les iterations de tous les test
EvalObjf(EvalObjf==0)=NaN;
X=ones(500,1);
Y=1:500;
subplot(2,2,4)
scatter(Y',X,30,EvalObjf(1:500,6));
hold on
plot(EvalObjf(:,7),'ob','Linewidth',2);

plot(EvalObjf(:,10),'ok','Linewidth',2);
plot(EvalObjf(:,8),'om','Linewidth',2);
plot(EvalObjf(:,9),'oc','Linewidth',2);
legend('IT1','IT2','IT5','IT3','IT4')
xlim([0,500]);
%ylim([-2, 2])
xlabel('Iteration')
ylabel('Nb evaluation Objctf')
grid on
title('Time')



%% --------------PLOT GDM RESULT-------------------------------------------
%shading(0,1)                  0:interp ; 1:flat
%Caxismin,Caxismax             Colorbar minimum and maximum  value
%--------------------------------------------------------------------------
GRAPH1=[0 4 60];
RES1=log10(OPTIFINAL_TEST(:,:,6:10));

n=1;
while n<=a(2)
    IN=zeros(Kcells,Icells,4);
    t=1;
    for i=n:n+3;
        IN(:,:,t)=RES1(:,:,i);
        t=t+1;
    end
    
    [X,Y]=SIMPLOT(IN,Position,n,GRAPH1);
    name=strcat('OPT#',num2str(n),'OPT#',num2str(n+3));
     print(name, '-dpng', '-r300')
    n=n+4;
    
end
