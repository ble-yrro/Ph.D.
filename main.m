%clc; clear all
load GDMRES;
load VTEM;                                           %vtem data in pV/A/m^4
load Nano;                                             %nano data in nv/m^2
load ORDER
RES=GDMRES;
dim=size(RES(:,:,1));


%--------ASSIGNER LES REALISATION INITIALES--------------------------------
start =randperm(100,3);
R1= RES(:,:,start(1));
R2=RES(:,:,start(2));
R3=RES(:,:,start(3));

%-------DEBUT DES COMBINAISONS---------------------------------------------
miniobj=200; %initialisation de la fonction objectif
comb=1;


for test=5:5
    
    
        
    while  comb<=250
        
        tic;
        [defpam,fval,exitflag,output] = fminbnd(@(deformparameter)myObjective(deformparameter,R1,R2,R3,Nano,Vtem),-pi,pi);
        fin=toc;
        
        if fval<miniobj
            
            [ROPT]=CALOPT(R1,R2,R3,defpam);
            [NanoFwr,NanoRMS,VtemFwr,VtemRMS]=FWRDOPT(ROPT,Nano,Vtem);
            
            FINAL1(comb).RMS=fval;
            FINAL1(comb).deformparameter=defpam;
            FINAL1(comb).ROPT=ROPT;
            FINAL1(comb).NanoRMS=NanoRMS;
            FINAL1(comb).NanoFwr=NanoFwr;
            FINAL1(comb).VtemRMS=VtemRMS;
            FINAL1(comb).VtemFwr=VtemFwr;
            
            %------INITIALISER ROPT ET RMSOPT----------------------------------
            
            miniobj=fval;
            R1=ROPT;
            
        elseif fval>=miniobj
            
            FINAL1(comb).RMS=FINAL1(comb-1).RMS;
            FINAL1(comb).deformparameter=FINAL1(comb-1).deformparameter;
            FINAL1(comb).ROPT=FINAL1(comb-1).ROPT;
            FINAL1(comb).NanoRMS=FINAL1(comb-1).NanoRMS;
            FINAL1(comb).NanoFwr=FINAL1(comb-1).NanoFwr;
            FINAL1(comb).VtemRMS=FINAL1(comb-1).VtemRMS;
            FINAL1(comb).VtemFwr=FINAL1(comb-1).VtemFwr;
            
            
            
            %------INITIALISER ROPT ET RMSOPT----------------------------------
            
            miniobj=FINAL1(comb-1).RMS;
            R1=FINAL1(comb-1).ROPT;
        end
        
        
        FINAL1(comb).Time=fin;
        FINAL1(comb).Iteration=output.iterations;
        FINAL1(comb).EXIT=exitflag;
        
        save FINAL1
        r1=ORDER(comb,1,test);
        r2=ORDER(comb,2,test);
        R2=RES(:,:,r1);
        R3=RES(:,:,r2);
        
        
        comb=comb+1;
    end
    
    
    name=strcat('TEST',num2str(test),'.mat');
    save(name)
    %%
    c=test+1;
    start(test+1,:) =randi([1 100],1,3);
    R1= RES(:,:,start(c,1));
    R2=RES(:,:,start(c,2));
    R3=RES(:,:,start(c,3));
    
    %-------DEBUT DES COMBINAISONS---------------------------------------------
    miniobj=200; %initialisation de la fonction objectif
    comb=1;
end

