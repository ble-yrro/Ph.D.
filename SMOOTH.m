function [RESOUT]=SMOOTH(RES,dim1)

dim=size(RES);
RESOUT=RES;
for rr=1:dim(3);
    A=RES(:,:,rr);  
   B=medfilt1(A,dim1,[],2);
   RESOUT(:,:,rr)=B;
end    

    
end