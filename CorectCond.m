function [RES]=CorectCond(res,smoothindex)
load smoothindex
a=size(res);
RES=zeros(a);

for i=1:a(3)
    B=res(:,:,i);
    B(:,smoothindex)=B(:,smoothindex+1);
    RES(:,:,i)=B;
end