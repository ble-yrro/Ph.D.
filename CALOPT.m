function [RES]=CALOPT(R1,R2,R3,deformparameter)

a1 = 1/3+2/3*cos(deformparameter);

a2 = 1/3+2/3*sin(-pi/6+deformparameter);

a3 = 1/3+2/3*sin(-pi/6-deformparameter);

RES= abs(a1.*R1 + a2.*R2 + a3.*R3);

RES(RES< 0.6533)=0.6333;
RES(RES> 2.0976)=2.0976;

end