load TEST5
a=size(FINAL1);
MSE0=zeros(a(2),3);
for i=1:a(2)
    Na=FINAL1(i).NanoFwr;
    Vt=FINAL1(i).VtemFwr;
    
    [val,val1,val2]=MSE1(Vt,Vtem);
    
    MSE0(i,1)=val;
    MSE0(i,2)=val1;
    MSE0(i,3)=val2;
    
    
end

load MSETEST5
dat=MSETEST5(:,1:3); 
dat=sort(dat,'descend');
figure('color',[ 1 1 1])
subplot(2,2,1)
f=250;
plot(1:f,dat(:,1))
 legend('val')
 
subplot(2,2,2)
plot(1:f,dat(:,2:3))
legend('val1','val2')