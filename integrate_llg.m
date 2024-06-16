mmx_=zeros(natomW,natomL,gpurun_number*final_m_savestep);
mmy_=zeros(natomW,natomL,gpurun_number*final_m_savestep);
mmz_=zeros(natomW,natomL,gpurun_number*final_m_savestep);

BDSOT=zeros(natomW,natomL,'gpuArray');
BDSTT=zeros(natomW,natomL,'gpuArray');
muigpu=zeros(natomW,natomL,'gpuArray');
scalgpu=zeros(natomW,natomL,'gpuArray');
AsimnextL=zeros(natomW,natomL,'gpuArray');
AsimnextW=zeros(natomW,natomL,'gpuArray');
AsimpreviousL=zeros(natomW,natomL,'gpuArray');
AsimpreviousW=zeros(natomW,natomL,'gpuArray');
for ctL=1:natomL
    for ctW=1:natomW
        if atomtype_(ctW,ctL)==1%RE
            muigpu(ctW,ctL)=musRE;
            scalgpu(ctW,ctL)=gamRE/(1+alp^2);%scale parameter
            BDSOT(ctW,ctL)=BDSOTRE;
            BDSTT(ctW,ctL)=BDSTTRE;
        else
            muigpu(ctW,ctL)=musTM;
            scalgpu(ctW,ctL)=gamTM/(1+alp^2);%scale parameter
            BDSOT(ctW,ctL)=BDSOTTM;
            BDSTT(ctW,ctL)=BDSTTTM;
        end
        if atomtype_(ctW,ctL)==1%local atom is RE
            if ctL==natomL
                if bc
                    AsimnextL(ctW,ctL)=0;
                else
                    AsimnextL(ctW,ctL)=Jgdgd*(atomtype_(ctW,ctL)==atomtype_(ctW,1))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(ctW,1));
                end
            else
                if atomtype_(ctW,ctL+1)==1%the other atom is RE
                    AsimnextL(ctW,ctL)=Jgdgd;
                else%the other atom is TM
                    AsimnextL(ctW,ctL)=Jfegd;
                end
            end
            
            if ctL==1
                if bc
                    AsimpreviousL(ctW,ctL)=0;
                else
                    AsimpreviousL(ctW,ctL)=Jgdgd*(atomtype_(ctW,ctL)==atomtype_(ctW,natomL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(ctW,natomL));
                end
            else
                if atomtype_(ctW,ctL-1)==1%the other atom is RE
                    AsimpreviousL(ctW,ctL)=Jgdgd;
                else%the other atom is TM
                    AsimpreviousL(ctW,ctL)=Jfegd;
                end
            end
            
            if ctW==natomW
                if bc
                    AsimpreviousW(ctW,ctL)=0;
                else
                    AsimpreviousW(ctW,ctL)=Jgdgd*(atomtype_(ctW,ctL)==atomtype_(1,ctL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(1,ctL));
                end
            else
                if atomtype_(ctW+1,ctL)==1%the other atom is RE
                    AsimpreviousW(ctW,ctL)=Jgdgd;
                else%the other atom is TM
                    AsimpreviousW(ctW,ctL)=Jfegd;
                end
            end
            
            if ctW==1
                if bc
                    AsimnextW(ctW,ctL)=0;
                else
                    AsimnextW(ctW,ctL)=Jgdgd*(atomtype_(ctW,ctL)==atomtype_(natomW,ctL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(natomW,ctL));
                end
            else
                if atomtype_(ctW-1,ctL)==1%the other atom is RE
                    AsimnextW(ctW,ctL)=Jgdgd;
                else%the other atom is TM
                    AsimnextW(ctW,ctL)=Jfegd;
                end
            end
            
        else%local atom is TM
            if ctL==natomL
                if bc
                    AsimnextL(ctW,ctL)=0;
                else
                    AsimnextL(ctW,ctL)=Jfefe*(atomtype_(ctW,ctL)==atomtype_(ctW,1))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(ctW,1));
                end
            else
                if atomtype_(ctW,ctL+1)==1%the other atom is RE
                    AsimnextL(ctW,ctL)=Jfegd;
                else%the other atom is TM
                    AsimnextL(ctW,ctL)=Jfefe;
                end
            end
            
            if ctL==1
                if bc
                    AsimpreviousL(ctW,ctL)=0;
                else
                    AsimpreviousL(ctW,ctL)=Jfefe*(atomtype_(ctW,ctL)==atomtype_(ctW,natomL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(ctW,natomL));
                end
            else
                if atomtype_(ctW,ctL-1)==1%the other atom is RE
                    AsimpreviousL(ctW,ctL)=Jfegd;
                else%the other atom is TM
                    AsimpreviousL(ctW,ctL)=Jfefe;
                end
            end

            if ctW==natomW
                if bc
                    AsimpreviousW(ctW,ctL)=0;
                else
                    AsimpreviousW(ctW,ctL)=Jfefe*(atomtype_(ctW,ctL)==atomtype_(1,ctL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(1,ctL));
                end
            else
                if atomtype_(ctW+1,ctL)==1%the other atom is RE
                    AsimpreviousW(ctW,ctL)=Jfegd;
                else%the other atom is TM
                    AsimpreviousW(ctW,ctL)=Jfefe;
                end
            end
            
            if ctW==1
                if bc
                    AsimnextW(ctW,ctL)=0;
                else
                    AsimnextW(ctW,ctL)=Jfefe*(atomtype_(ctW,ctL)==atomtype_(natomW,ctL))+...
                        Jfegd*(~atomtype_(ctW,ctL)==atomtype_(natomW,ctL));
                end
            else
                if atomtype_(ctW-1,ctL)==1%the other atom is RE
                    AsimnextW(ctW,ctL)=Jfegd;
                else%the other atom is TM
                    AsimnextW(ctW,ctL)=Jfefe;
                end
            end
        end
    end
end
gamatom=scalgpu*(1+alp^2);
clear ctW ctL
BFSOT=chi*BDSOT;
BFSTT=chi*BDSTT;

if dipolemode==3 %group atoms into macrocells
    if ~mod(natomW,natom_mc_W)
        nW_group=natomW/natom_mc_W;%number of macrocells along width direction
    else
        error('natomW should be multiple integer times of natom_mc_W')
    end
    
    if ~mod(natomL,natom_mc_L)
        nL_group=natomL/natom_mc_L;%number of macrocells along length direction
    else
        error('natomL should be multiple integer times of natom_mc_L')
    end
    
    n_macrocell=nW_group*nL_group;
    volume_mc=(natom_mc_W*d)*(natom_mc_L*d)*d;
    
    pmcW_=zeros(nW_group,nL_group);
    pmcL_=zeros(nW_group,nL_group);
    pmcz_=zeros(nW_group,nL_group);

    if(0)%use simpler numbers for debug
        d=1.1;
        muigpu=[1.2,1.4,1.2,1.2;...
            1.2,1.2,1.2,1.2;...
            1.2,1.2,1.2,1.4;...
            1.2,1.2,1.2,1.2];
        mmxtmp=[0.08,-0.08,0.08,0.08;...
            0.08,0.08,0.08,0.08;...
            0.08,0.08,0.08,-0.08;...
            0.08,0.08,0.08,0.08];
        mmytmp=zeros(4,4);
        mmztmp=zeros(4,4);
        
    end
    
    [rijL_tmp,rijW_tmp]=meshgrid(1:natomL,1:natomW);
    distL_mui=rijL_tmp.*muigpu;
    distW_mui=rijW_tmp.*muigpu;
    for ctL2=1:nL_group
        for ctW2=1:nW_group
            W_start=natom_mc_W*(ctW2-1)+1;
            W_end=natom_mc_W*ctW2;
            L_start=natom_mc_L*(ctL2-1)+1;
            L_end=natom_mc_L*ctL2;
            
            sum_distL_mui=sum(sum(distL_mui(W_start:W_end,L_start:L_end)));
            sum_distW_mui=sum(sum(distW_mui(W_start:W_end,L_start:L_end)));
            sum_mui=sum(sum(muigpu(W_start:W_end,L_start:L_end)));
            pmcL_(ctW2,ctL2)=d*sum_distL_mui/sum_mui;
            pmcW_(ctW2,ctL2)=d*sum_distW_mui/sum_mui;
        end
    end
    clear ctL2 ctW2   
end

ct3run=round((runtime)/gpusave);
ct3=1;
while ~(ct3>ct3run)
    
    mmx=zeros(natomW,natomL,gpusteps,'gpuArray');
    mmy=zeros(natomW,natomL,gpusteps,'gpuArray');
    mmz=zeros(natomW,natomL,gpusteps,'gpuArray');
    
    if ~(ct3==1)
        mmx(:,:,1)=tmp2xn0;mmy(:,:,1)=tmp2yn0;mmz(:,:,1)=tmp2zn0;
    else
        mmx(:,:,1)=mx_init;mmy(:,:,1)=my_init;mmz(:,:,1)=mz_init;
    end
    clear tmpx tmpy tmpz
    ct1=1; %count 1
    while ct1<gpusteps      
        mmxtmp0=mmx(:,:,ct1);
        mmytmp0=mmy(:,:,ct1);
        mmztmp0=mmz(:,:,ct1);

        if rk4==2%4th predictor-corrector
            if ct3==1 && ~(ct1>3)
                [sxx,syy,szz]=arrayfun(@atomgpurk4,mmxtmp,mmytmp,mmztmp,scalgpu,alp,...
                    tstep,hhx,hhy,hhz);
            else
                [sxx,syy,szz]=arrayfun(@atomgpupc4,tmpxn0,tmpyn0,tmpzn0,...
                    tmpxn1,tmpyn1,tmpzn1,tmpxn2,tmpyn2,tmpzn2,tmpxn3,tmpyn3,tmpzn3,...
                    scalgpu,alp,tstep,hhx,hhy,hhz);
            end
        elseif rk4==1 %rk4
            %2024.06.13: zhengde find that one should update field in each
            %step of RK4, which has been corrected below
            mmxtmp=mmxtmp0;
            mmytmp=mmytmp0;
            mmztmp=mmztmp0;

            field_calc();
            [kk1x,kk1y,kk1z]=arrayfun(@atomgpurk4,mmxtmp,mmytmp,mmztmp,psjSHEx,...
                psjSHEy,psjSHEz,psjSTTx,psjSTTy,psjSTTz,scalgpu,alp,...
                tstep,hhx,hhy,hhz,BDSOT,BFSOT,BDSTT,BFSTT);
            mmxtmp=mmxtmp0+1/2*tstep*kk1x;
            mmytmp=mmytmp0+1/2*tstep*kk1y;
            mmztmp=mmztmp0+1/2*tstep*kk1z;

            field_calc();
            [kk2x,kk2y,kk2z]=arrayfun(@atomgpurk4,mmxtmp,mmytmp,mmztmp,psjSHEx,...
                psjSHEy,psjSHEz,psjSTTx,psjSTTy,psjSTTz,scalgpu,alp,...
                tstep,hhx,hhy,hhz,BDSOT,BFSOT,BDSTT,BFSTT);
            mmxtmp=mmxtmp0+1/2*tstep*kk2x;
            mmytmp=mmytmp0+1/2*tstep*kk2y;
            mmztmp=mmztmp0+1/2*tstep*kk2z;

            field_calc();
            [kk3x,kk3y,kk3z]=arrayfun(@atomgpurk4,mmxtmp,mmytmp,mmztmp,psjSHEx,...
                psjSHEy,psjSHEz,psjSTTx,psjSTTy,psjSTTz,scalgpu,alp,...
                tstep,hhx,hhy,hhz,BDSOT,BFSOT,BDSTT,BFSTT);
            mmxtmp=mmxtmp0+kk3x*tstep;
            mmytmp=mmytmp0+kk3y*tstep;
            mmztmp=mmztmp0+kk3z*tstep;

            field_calc();
            [kk4x,kk4y,kk4z]=arrayfun(@atomgpurk4,mmxtmp,mmytmp,mmztmp,psjSHEx,...
                psjSHEy,psjSHEz,psjSTTx,psjSTTy,psjSTTz,scalgpu,alp,...
                tstep,hhx,hhy,hhz,BDSOT,BFSOT,BDSTT,BFSTT);

            snx=mmxtmp0+1/6*tstep*(kk1x+2*kk2x+2*kk3x+kk4x);
            sny=mmytmp0+1/6*tstep*(kk1y+2*kk2y+2*kk3y+kk4y);
            snz=mmztmp0+1/6*tstep*(kk1z+2*kk2z+2*kk3z+kk4z);
            normsn=sqrt(snx.^2+sny.^2+snz.^2);
            sxx=snx./normsn;
            syy=sny./normsn;
            szz=snz./normsn;

        else%heun
            [sxx,syy,szz]=arrayfun(@atomgpu,mmxtmp,mmytmp,mmztmp,scalgpu,alp,...
                tstep,hhx,hhy,hhz);%
        end
        
        mmx(:,:,ct1+1)=sxx; mmy(:,:,ct1+1)=syy; mmz(:,:,ct1+1)=szz;
        if enablefixedge
            mmx(:,1:fixededgeL,ct1+1)=mxleft;
            mmy(:,1:fixededgeL,ct1+1)=myleft;
            mmz(:,1:fixededgeL,ct1+1)=mzleft;
            
            mmx(:,natomL-fixededgeL:end,ct1+1)=mxright;
            mmy(:,natomL-fixededgeL:end,ct1+1)=myright;
            mmz(:,natomL-fixededgeL:end,ct1+1)=mzright;
        end
        ct1=ct1+1;
        if ~(ct3==1 && ~(ct1>3)) && ct1>3
            tmpxn0=mmx(:,:,ct1);tmpyn0=mmy(:,:,ct1);tmpzn0=mmz(:,:,ct1);
            tmpxn1=mmx(:,:,ct1-1);tmpyn1=mmy(:,:,ct1-1);tmpzn1=mmz(:,:,ct1-1);
            tmpxn2=mmx(:,:,ct1-2);tmpyn2=mmy(:,:,ct1-2);tmpzn2=mmz(:,:,ct1-2);
            tmpxn3=mmx(:,:,ct1-3);tmpyn3=mmy(:,:,ct1-3);tmpzn3=mmz(:,:,ct1-3);
        elseif ~(ct3==1 && ~(ct1>3)) && ct1==2
            tmpxn0=mmx(:,:,ct1);tmpyn0=mmy(:,:,ct1);tmpzn0=mmz(:,:,ct1);
            tmpxn1=tmp2xn0;tmpyn1=tmp2yn0;tmpzn1=tmp2zn0;
            tmpxn2=tmp2xn1;tmpyn2=tmp2yn1;tmpzn2=tmp2zn1;
            tmpxn3=tmp2xn2;tmpyn3=tmp2yn2;tmpzn3=tmp2zn2;
        elseif ~(ct3==1 && ~(ct1>3)) && ct1==3
            tmpxn0=mmx(:,:,ct1);tmpyn0=mmy(:,:,ct1);tmpzn0=mmz(:,:,ct1);
            tmpxn1=mmx(:,:,ct1-1);tmpyn1=mmy(:,:,ct1-1);tmpzn1=mmz(:,:,ct1-1);
            tmpxn2=tmp2xn0;tmpyn2=tmp2yn0;tmpzn2=tmp2zn0;
            tmpxn3=tmp2xn1;tmpyn3=tmp2yn1;tmpzn3=tmp2zn1;
        end
    end
    tmp2xn0=mmx(:,:,end);tmp2yn0=mmy(:,:,end);tmp2zn0=mmz(:,:,end);
    tmp2xn1=mmx(:,:,end-1);tmp2yn1=mmy(:,:,end-1);tmp2zn1=mmz(:,:,end-1);
    tmp2xn2=mmx(:,:,end-2);tmp2yn2=mmy(:,:,end-2);tmp2zn2=mmz(:,:,end-2);
    mmx_(:,:,(ct3-1)*final_m_savestep+1:ct3*final_m_savestep)=gather(mmx(:,:,1:savetstep:end));
    mmy_(:,:,(ct3-1)*final_m_savestep+1:ct3*final_m_savestep)=gather(mmy(:,:,1:savetstep:end));
    mmz_(:,:,(ct3-1)*final_m_savestep+1:ct3*final_m_savestep)=gather(mmz(:,:,1:savetstep:end));
    ct3=ct3+1;
end

clear mmx mmy mmz tmp2xn0 tmp2yn0 tmp2zn0 tmp2xn1 tmp2yn1 tmp2zn1
clear tmp2xn2 tmp2yn2 tmp2zn2
mmx=mmx_;
mmy=mmy_;
mmz=mmz_;
clear mmx_ mmy_ mmz_
t=t(1:savetstep:end);
