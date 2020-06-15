
function [dataCorr]=PlotRawdata(data,Position,Type, Level)

[a,b]=size(data);

dataCorr=data;

[c1,c2]=find(dataCorr<Level);      % noise=~ 1e-2 pV.A^-1.m^-4 (5.3 nT/S ou nV/m^2)

for i=1:length(c1)
    
    dataCorr(c1(i),c2(i))=0;
end
X=zeros(b,a);

for i=1:b
    if Type==1;
        X(i,:)=Position(:,1)'; name='Easting (m)';
        t1=X(1,1); %X(1,1)-100;
        t2=X(1,end);
        
    elseif Type==2
        X(i,:)=Position(:,2)';
        name='Northing (m)';
        t1=X(1,1); %Y(1,1)-200;
        t2=X(1,end);
    
    end
    
end


figure1=figure('units','normalized','position',[0.1 0.1 0.7 0.8],'color',[1 1 1]);
axes1=axes('parent',figure1,'position',[0.07 0.7 0.85 0.2]);
axes2=axes('parent',figure1,'position',[0.07 0.4 0.85 0.2]);
axes3=axes('parent',figure1,'position',[0.07 0.07 0.85 0.2]);

semilogy(X',data,'parent',axes1);
set(get(axes1,'YLabel'),'String','dB_z/dt (pV.A^-1.m^-4','fontsize',12)
set(get(axes1,'title'),'String','L2000 BRUTE','fontsize',14)
set(axes1,'xlim',[min(X(1,:)) max(X(1,:))])

semilogy(X',dataCorr,'parent',axes2);
set(get(axes2,'YLabel'),'String','dB_z/dt (pV.A^-1.m^-4','fontsize',12)
set(get(axes2,'title'),'String','L2000 CORRIGEE','fontsize',14)
set(axes2,'xlim',[min(X(1,:)) max(X(1,:))])
set(axes2,'ylim',[1e-3 1e+2])

plot(X(1,:),Position(:,3),'parent',axes3)
set(get(axes3,'XLabel'),'String',name,'fontsize',13)
set(get(axes3,'YLabel'),'String','H (m)','fontsize',12)
set(get(axes3,'title'),'String','HAUTEUR VOL','fontsize',14)
set(axes3,'xlim',[min(X(1,:)) max(X(1,:))])

cc1=get(axes1,'XTick');
cc2={};
for i=1:size(cc1,2); cc2{i}=num2str(cc1(i)); end
set(axes1,'XTicklabel',cc2);
set(axes2,'XTicklabel',cc2);
set(axes3,'XTicklabel',cc2);
grid(axes1)
grid(axes2)
grid(axes3)

end