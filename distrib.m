%% distribute atoms
%1 RE,0 TM
if ddebug
else
    tmp=randperm(natom,round(natom*compositionn));
end
atomtype_=10*ones(natomx,natomy);
for cty=1:natomy
    for ctx=1:natomx
        atomtype_(ctx,cty)=ismember(ctx+(cty-1)*natomx,tmp);
    end
end
clear tmp ctx cty ctz
