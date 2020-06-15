function TDEM2FORAGE(PosTDEM,ID, MAXDPH,dir)
%--------------------------------------------------------------------------
% FONCTION POUR REPRESENTER TDEM SOUS FORME DE FORAGE
%INPUT
%Position: [X Y X]
%ID: ensemble de cellule contenant les nonms des sondages
%MAXDPH: altitude de la fin du forage
%dir: 1=easting 2=northing
%--------------------------------------------------------------------------
a=size(PosTDEM);
for i=1:a(1)
    
        
    x=[PosTDEM(i,dir) PosTDEM(i,dir)]; x=x*1e-3;
    if i==1
        x=x+0.3;
    end
    y=[(PosTDEM(i,3)+5 -MAXDPH) (PosTDEM(i,3)+5)];
        
   if i<=10
       y(2)=y(2)+10;
   end
    
    plot(x(1),y(2)+5.1,'ko','MarkerFaceColor','k','MarkerSize',2)
    hold on
    text(x(1)+0.01,y(2)+5.1,ID{i},'FontSize',8)
end