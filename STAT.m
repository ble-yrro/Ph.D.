clc; clear all
load RES1;

%-------------ZONE1-PARIE1-------------------
res=RES1(:,~isnan(RES1(1,1:5299)));
thk=THK1(:,~isnan(RES1(1,1:5299)));
EP=DPH1(:,~isnan(RES1(1,1:5299)));
a=size(res);
A=reshape(res(1:3,:),3*a(2),1);


ZONE1=min(A);
ZONE1(1,2)=max(A);
ZONE1(1,3)=mean(A);
ZONE1(1,4)=std(A);

ZONE1(2,1)=min(EP(2,:));
ZONE1(2,2)=max(EP(2,:));
ZONE1(2,3)=mean(EP(2,:));
ZONE1(2,4)=std(EP(2,:));

%-------------ZONE2-PARIE1--------------------------------------------------------
res2A=RES1(4:5,~isnan(RES1(1,1:5299)));    aa=size(res2A);
thk2A=THK1(4:5,~isnan(RES1(1,1:5299)));     totoA=cumsum(thk2A);


A=reshape(res2A,aa(1)*aa(2),1);
EP=totoA(end,:)';

ZONE2=min(A);
ZONE2(1,2)=max(A);
ZONE2(1,3)=mean(A);
ZONE2(1,4)=std(A);

ZONE2(2,1)=min(EP);
ZONE2(2,2)=max(EP);
ZONE2(2,3)=mean(EP);
ZONE2(2,4)=std(EP);


%-------------ZONE3-PARIE1--------------------------------------------------------
RHO=RES1(:,1:5299);
res3A=RHO(6:14,~isnan(RHO(1,:)));    aa=size(res3A);

dph=DPH1(:,1:5299);
Prof3A=dph(6,~isnan(dph(1,1:end)));
PF=Prof3A;

A=reshape(res3A,aa(1)*aa(2),1);
ZONE3=min(A);
ZONE3(1,2)=max(A);
ZONE3(1,3)=mean(A);
ZONE3(1,4)=std(A);

ZONE3(2,1)=min(PF);
ZONE3(2,2)=max(PF);
ZONE3(2,3)=mean(PF);
ZONE3(2,4)=std(PF);

%----PARTIE2------------------------------------------
RHO=RES1(:,5300:end);
res3B=RHO(1:14,~isnan(RHO(1,1:end))); bb=size(res3B);
A=reshape(res3B,bb(1)*bb(2),1);
ZONE4=min(A);
ZONE4(1,2)=max(A);
ZONE4(1,3)=mean(A);
ZONE4(1,4)=std(A);





