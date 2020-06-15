function Pseudo2D(dataraw,IMPORT,RES,DPH,RMS,Pos,GRAPH,FIN)


%--------------------------------------------------------------------------
%  FONCTION POUR VISUALISER UNE SECTION PSEUDO2D
%  APRES INVERSION DES STATIONS
%
%       INPUT
%
%data[nbstation,nbgate]:                          matrice des donnees brute

%IMPORT[nbstation,npar]:                       matrice importance parametre

%DPH[nblayer-1, nbstation]:                 matrice profondeur toit couches

%RES[nblayer, nbstation]:                       matrice resistivite couches

%RMS[nbstation,1]:                                 vecteur valeurs des RMS

%Pos[nbstation,4]:                           vecteur coordonnees[X,Y,DTM,H]

%GRAPH [1x6]:                              vecteur des parametres figure 2D
%GRAPH(1)=Xtype(station=0   Easting=1; Northing=2)
%GRAPH(2)=Ztype(depth=0   Altitude=1)
%GRAPH(3)=interptype(interp=0   flat=1 )
%GRAPH(4:6)=(Cmin,Cmax,npar)
%--------------------------------------------------------------------------
dataraw=dataraw';



%------------------ CHOIX NB COUCHE POUR REPRESENTATION--------------------
lg=size(RES);
RES=RES(1:GRAPH(end),:);
DPH=DPH(1:GRAPH(end)-1,:);

IMPRES=IMPORT(1:lg(1),:); IMPRES=IMPRES(1:GRAPH(end),:);
IMPTHK=IMPORT(lg(1)+1:end,:); IMPTHK=IMPTHK(1:GRAPH(end)-1,:);
IMPORT=[IMPRES;IMPTHK];
IMPORT1=[IMPORT;IMPORT(end,:)]; m=size(IMPORT1,1);


%----------CHOIX REPRESENTATION LOG10---------------------------------
RES(RES>GRAPH(5))=GRAPH(5);
RES(RES<GRAPH(4))=GRAPH(4);
    RES=log10(RES);



%----------COORD DES AXES X ET Y POUR REPRESENTATION-----------------------
Alt=[];
Easting=[];Northing=[]; STATION=[];
npar=GRAPH(end);

for i=1:npar+1;
    if i==1
        Alt=[ Alt;Pos(:,3)'];
        Easting=[Easting;Pos(:,1)'];
        Northing=[Northing;Pos(:,2)'];
        STATION=[ STATION;1:lg(2)];
    elseif i~=1 && i~=npar+1
        Alt=[ Alt;Pos(:,3)'-DPH(i-1,:)];
        Easting=[Easting;Pos(:,1)'];
        Northing=[Northing;Pos(:,2)'];
        STATION=[ STATION;1:lg(2)];
    elseif i==npar+1
        Alt=[Alt;Pos(:,3)'-FIN];
        Easting=[Easting;Pos(:,1)'];
        Northing=[Northing;Pos(:,2)'];
        STATION=[ STATION;1:lg(2)];
    end
end

DPH1=[zeros(1,lg(2));DPH; (Alt(end-1,:)-Alt(end,:))+DPH(end,:)];
RES1=[RES;RES(end,:)];


YY1=zeros(m,lg(2));

for ii=1:lg(2);
    YY1(:,ii)=(1:m)';
end

if GRAPH(1)==0
    XX=STATION;
    XX1=[XX(1:end-1,:);XX(1:end-1,:)];
    name='STATIONS';
    
elseif GRAPH(1)==1
    XX=Easting.*1e-3;
    XX1=[XX(1:end-1,:);XX(1:end-1,:)];
    name='X [Km]';
    
elseif GRAPH(1)==2
    XX=Northing.*1e-3;
    XX1=[XX(1:end-1,:);XX(1:end-1,:)];
    name='Y [Km]';
    
end

figure('units','normalized','color',[1 1 1]);

%------------RAWDATA CORR--------------------------------------------------
subplot(3,1,1)

semilogy(XX(1,:),dataraw,'parent',gca);

l1=1e-4; l2=1e+2;

set(get(gca,'YLabel'),'String','[pV.A^-1.m^-4]')
set(gca,'xlim',[min(XX(1,:)) max(XX(1,:))+1])
set(gca,'ylim',[l1 l2])

hold on
text(XX(1,1)-0.2+1,3e+2,'NNO');  text(XX(1,end),3e+2,'SSE');
hold off

%----------------------- PLOT RMS----------------------------------------
subplot(3,1,2)
plot(XX(1,:),RMS,'parent',gca)
set(get(gca,'YLabel'),'String','RMS [%]')
set(gca,'xlim',[min(XX(1,:)) max(XX(1,:))+1],'ylim',[0 15])
grid(gca)

if GRAPH(2)==0
    YY=DPH1;
elseif GRAPH(2)==1
    YY=Alt;
end



cmp=jet(256); cmp1=cmp(1:220,:); colormap(cmp1)
% %--------------------IMPORTANCE--------------------------------------
%
% pcolor(XX1,YY1,IMPORT1,'parent',axes3)
% set(axes3,'xlim',[min(XX(1,:)) max(XX(1,:))],'ylim',[1   2*npar])
%
% set(axes3,'YTick',1.5:1:m+0.5)
% set(axes3,'Ydir','reverse')
% %grid(axes3)
% LAB={};
% inc=1;
% for ii=1:m
%     if ii<=GRAPH(end)
%         LAB{ii,1}=strcat('RES',num2str(ii));
%     else
%         LAB{ii,1}=strcat('THK',num2str(inc));
%         inc=inc+1;
%     end
% end
%
% set(axes3,'YTickLabel',LAB)
% shading(axes3,'flat');
% h0=colorbar('peer',axes3,'location','EastOutside');
% set(get(h0,'Title'),'String','Importance','fontsize',12);
% caxis([0 1.01])

%--------------------2D SECTION--------------------------------------

subplot(3,1,3)

pcolor(XX,YY,RES1,'parent',gca);

set(gca,'xlim',[min(XX(1,:)) max(XX(1,:))+1])
set(gca,'ylim',[-100 max(YY(1,:))+15]) %min(YY(end,:))

set(get(gca,'XLabel'),'String',name)
set(get(gca,'YLabel'),'String','Z [m]')
hold on; plot(XX(1,:),Pos(:,3),'k');

if GRAPH(3)==0
    shading(gca,'interp');
elseif GRAPH(3)==1
    shading(gca,'flat');
end

%-------------COLORBAR----------------------------------

h1=colorbar('location','EastOutside');
cc=get(h1,'Position');
set(get(h1,'Title'),'String','\rho(\Omega.m)')
set(h1,'Position',[cc(1)+0.125, cc(2), cc(3)/4, cc(4)])
cv=get(h1,'YTick');

b={};
for i=1:length(cv)
b{i}=num2str(round(10^cv(i))); 
end
set(h1,'YTick',cv);
set(h1,'YTicklabel',b)

% caxis(h1,[log10(GRAPH(4)) log10(GRAPH(5))])
% % caxis(h1,[GRAPH(4) GRAPH(5)])



end

