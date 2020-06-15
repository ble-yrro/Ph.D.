load TEST1

%-----------------
a=size(FINAL1);
TEST1.RESOPT(:,:,1)=FINAL1(1).ROPT;
TEST1.RESOPT(:,:,2)=FINAL1(end).ROPT;

for i=1:a(2)
    TEST1.RMS(i,1)=FINAL1(i).RMS;
    TEST1.NanoRMS(:,i)=FINAL1(i).NanoRMS';
    TEST1.VTEMRMS(:,i)=FINAL1(i).VtemRMS';
    TEST1.NanoFWR(:,:,i)=FINAL1(i).NanoFwr;
    TEST1.VTEMFWR(:,:,i)=FINAL1(i).VtemFwr;
    TEST1.DEFPARA(i,1)=FINAL1(i).deformparameter;
    TEST1.TIME(i,1)=FINAL1(i).Time;
    TEST1.NBEVALOBJ(i,1)=FINAL1(i).Iteration;
end
 
for i=1:8
    c=min(TEST1.NanoRMS(i,:));
    b=find(TEST1.NanoRMS(i,:)==c);
    
    c1=max(TEST1.NanoRMS(i,:));
    b1=find(TEST1.NanoRMS(i,:)==c1);
    
    
    TEST1.NanoMinMaxRms(i,1)=c*100;
    TEST1.NanoMinMaxRms(i,3)=b(1);
    
    TEST1.NanoMinMaxRms(i,2)=c1*100;
    TEST1.NanoMinMaxRms(i,4)=b1(1);
end


for i=1:515
    c=min(TEST1.VTEMRMS(i,:));
    b=find(TEST1.VTEMRMS(i,:)==c);
    
    c1=max(TEST1.VTEMRMS(i,:));
    b1=find(TEST1.VTEMRMS(i,:)==c1);
    
    
    TEST1.VTEMMinMaxRms(i,1)=c*100;
    TEST1.VTEMMinMaxRms(i,3)=b(1);
    
    TEST1.VTEMMinMaxRms(i,2)=c1*100;
    TEST1.VTEMMinMaxRms(i,4)=b1(1);
end
    



    
    