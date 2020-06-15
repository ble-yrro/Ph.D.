function [X,Y,RES1,RES2,RES3,RES4]=SIMPLOT(RES,Position,n,GRAPH,Cmp,dim)

%-------------------------------------------------------------------------%
%   VISUALISER 4 SIMULATIONS DE RESISTIVITE PSEUDO2D                      %
%                                                                         %
%       INPUT                                                             %
%                                                                         %
%RES[Kcells*Icells,nbsimulation]         matrice des resistivites simulees%
%                                                                         %
%Position[nbstation,4]                    matrice coordonnees[:,X,Y,H,DTM]%
%                                                                         %
%GRAPH(Yaxistype,Yaxistype,Unittype,Cmin,Cmax)
%
%Xtype(1,2,3)                  0:stations ;1:Easting; 2:Northing          %
%Ztype (1,2)                   0:DPH  ;  1: Altitude;                     %
%shading(0,1)                  0:interp ; 1:flat
%Unittype(0,1)                 0:log(ohm.m); 1:log10(ohm.m); ~=0&&1:ohm.m %
%Cmin,Cmax                     Cmin:color minimum    Cmax:color maximum   %
%-------------------------------------------------------------------------%
if nargin==6 && dim~=0;
    [RES]=SMOOTH(RES,dim);
end

RES(RES<(GRAPH(end-1)))=GRAPH(end-1);
RES(RES>GRAPH(end))=GRAPH(end);

X=Position.NORTHING;
X=[X;X(end,:)]*1e-3;
% X=Position.IndexI;
% X=[X;X(end,:)];
XLAB='Y [Km]';

Base=Position.THK(end,:);
Y=Position.ALTITUDE; Y=[Y;Y(end,:)-Base];
YLAB='Z [m]';


RES1= RES(:,:,1); RES1=[RES1;RES1(end,:)];
RES2= RES(:,:,2); RES2=[RES2;RES2(end,:)];
RES3=RES(:,:,3);  RES3=[RES3;RES3(end,:)];
RES4=RES(:,:,4);  RES4=[RES4;RES4(end,:)];

figure('color',[1 1 1]);


name=strcat('R#-',num2str(n(1)),'-',num2str(n(2)),'-',num2str(n(3)),'-',num2str(n(4)));
colormap(Cmp)
%-------SUBPLOT1--------------
subplot(4,1,1);
pcolor(X,Y,RES1,'parent',gca);
h=title(gca,name,'fontsize',11,'fontweight','bold');
b=get(h,'Position');
hold on
text(min(X(1,:)),b(2)+10,'SSE','parent',gca,'fontweight','bold')
text(max(X(1,:))-0.5,b(2)+10,'NNO','parent',gca,'fontweight','bold')
hold off

if GRAPH(1)==0
    shading(gca,'interp')
elseif GRAPH(1)==1
    shading(gca,'flat')
end
set(gca,'ylim',[-49.5 max(Y(1,:))+2.5])
set(get(gca,'YLabel'),'String',YLAB,'fontweight','bold')


%-------SUBPLOT2--------------
subplot(4,1,2);
pcolor(X,Y,RES2,'parent',gca);

if GRAPH(1)==0
    shading(gca,'interp')
elseif GRAPH(1)==1
    shading(gca,'flat')
end
set(gca,'ylim',[-49.5 max(Y(1,:))+2.5])
set(get(gca,'YLabel'),'String',YLAB,'fontweight','bold')


%-------SUBPLOT3--------------
subplot(4,1,3);
pcolor(X,Y,RES3,'parent',gca);

if GRAPH(1)==0
    shading(gca,'interp')
elseif GRAPH(1)==1
    shading(gca,'flat')
end
set(gca,'ylim',[-49.5 max(Y(1,:))+2.5])
set(get(gca,'YLabel'),'String',YLAB,'fontweight','bold')


%-------SUBPLOT4--------------
subplot(4,1,4);
pcolor(X,Y,RES4,'parent',gca);

if GRAPH(1)==0
    shading(gca,'interp')
elseif GRAPH(1)==1
    shading(gca,'flat')
end
set(gca,'ylim',[-49.5 max(Y(1,:))+2.5])
set(get(gca,'YLabel'),'String',YLAB,'fontweight','bold')
set(get(gca,'XLabel'),'String',XLAB,'fontweight','bold')


%-------------COLORBAR----------------------------------
%0.95
h1=colorbar('Position',[0.95 0.35  0.015  0.315]);
set(get(h1,'Title'),'String','\rho [\Omega.m]','fontweight','bold')
cv=get(h1,'YTick');
caxis(h1,[GRAPH(2) GRAPH(3)])
b={};
for i=1:length(cv)
    b{i}=num2str(round(10^cv(i)));
end
set(h1,'YTick',cv);
set(h1,'YTicklabel',b,'fontweight','bold')
caxis(h1,[10^GRAPH(2) 10^GRAPH(3)])
end
