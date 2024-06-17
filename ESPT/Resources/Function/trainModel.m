function trainModel(tlePath, OutPutPath, LabelPath, current_path)
    load([current_path filesep 'Resources\Function\statistics\GMcov.mat']);   %mat：GMCOV 标准相关矩阵
    load([current_path filesep 'Resources\Function\statistics\sec_tle.mat']);   %mat: sec_tle 切除区域
    [num,~,~] = xlsread(LabelPath);
    GroupIdx=num(:,1);
    n=length(GroupIdx);
    lateral=num(:,2);
    
    subs = dir(tlePath);
    subs = subs(3:end);
    
    load([tlePath filesep subs(1).name])
    edgeVar_TLEsign = zeros(size(sub_scn,1),size(sub_scn,2),size(subs,1));
    for i = 1 : size(subs,1)
        load([tlePath filesep subs(i).name])
        %disp(subs(i).name)
        edgeVar_TLEsign(:,:,i) = sub_scn;
    end
    %z-test
    edgeVar_TLE = (edgeVar_TLEsign)./((1-GMcov.^2)./77);
    
    edgeVar_TLE(find(isnan(edgeVar_TLE))) = 0;
    tle_matrix=zeros(size(edgeVar_TLE));
    enindex=1:2:246;
    odindex=2:2:246;
    
    for i=1:n
        if lateral(i)==1
            matrix=edgeVar_TLE(:,:,i);
            tle_matrix(enindex,enindex,i)=matrix(odindex,odindex);
            tle_matrix(enindex,odindex,i)=matrix(odindex,enindex);
            tle_matrix(odindex,enindex,i)=matrix(enindex,odindex);
            tle_matrix(odindex,odindex,i)=matrix(enindex,enindex);
        else 
            tle_matrix(:,:,i)=edgeVar_TLE(:,:,i);
        end 
    end
    
    spare_index=1:246;
    spare_index(sec_tle)=[];
    con_roi=spare_index(mod(spare_index,2)==0);
    edge=zeros(size(tle_matrix));
    edge(find(abs(tle_matrix)>2))=abs(tle_matrix(find(abs(tle_matrix)>2)));
    
    train_data=squeeze(sum(edge(spare_index,con_roi,:),2))';
    train_label=GroupIdx;
    
    index = t_mr_ref(train_data, train_label, 1, 0.01);
    save([OutPutPath,'\','index.mat'],'index');
    model = libsvmtrain(train_label,train_data(:,index),'-t 0 -b 1 -c 1');
    save([OutPutPath,'\','model.mat'],'model');
end