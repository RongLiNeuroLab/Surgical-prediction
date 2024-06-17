function Predict(modelPath, T1path, OutputPath, current_path)

    indexfile = [modelPath filesep 'index.mat'];
    load(indexfile); %%筛选出来的特征下标，训练的时候生成的
    modelfile = [modelPath filesep 'model.mat'];
    load(modelfile);
    load([current_path filesep 'Resources\Function\statistics\GMcov.mat']);   %mat：GMCOV 标准相关矩阵
    load([current_path filesep 'Resources\Function\statistics\sec_tle.mat']); %sec_tle
    dec_val=zeros(1:2);
    
    subs = dir(T1path);
    subs = subs(3:end);
    
    load([T1path filesep subs(1).name])
    edgeVar_TLEsign = zeros(size(sub_scn,1),size(sub_scn,2),size(subs,1));
    for i = 1 : size(subs,1)
        load([T1path filesep subs(i).name])
        %disp(subs(i).name)
        edgeVar_TLEsign(:,:,i) = sub_scn;
    end
    
    %z-test
    edgeVar_TLE=(edgeVar_TLEsign)./((1-GMcov.^2)./77);
    
    edgeVar_TLE(find(isnan(edgeVar_TLE)))=0;
    tle_matrix=zeros(size(edgeVar_TLE));

    n = size(subs,1);

    tle_matrix = edgeVar_TLE;
    
    spare_index=1:246;
    spare_index(sec_tle)=[];
    con_roi=spare_index(mod(spare_index,2)==0);
    edge=zeros(size(tle_matrix));
    edge(find(abs(tle_matrix)>2))=abs(tle_matrix(find(abs(tle_matrix)>2)));
    
    test_data=squeeze(sum(edge(spare_index,con_roi,:),2))';
    abnormal = squeeze(sum(edge(:,con_roi,:),2))';
        
    %取异常值最大的20个roi
    %fid = fopen([OutputPath,'\','result_',strrep(strrep(datestr(datetime),' ','-'),':','-'),'.txt'],'w+');
    [mask,header]=y_Read([current_path filesep 'Resources\Function\statistics\BN_atlas_mpm_0_246_61_73_61.nii']); %maskpath
    
    sheet='sheet1';
    %name = subs.name;
    
    n={'name'};
    r={'seizure free probability'};    
    xlsx_file = [OutputPath filesep 'result_' strrep(strrep(datestr(datetime),' ','-'),':','-') '.xlsx'];
    xlswrite(xlsx_file,n,sheet,'A1');
    xlswrite(xlsx_file,r,sheet,'B1');
    
    for i=1:size(test_data,1)
        [~ ,I]=sort(abnormal(i,:),'descend');
        PaNii=zeros(size(mask));
        for j=1:20
            roi=I(j);
            PaNii(find(mask==roi)) = abnormal(i,roi);
        end
        y_Write(PaNii,header,[OutputPath filesep subs(i).name(1:end-4) '.nii']);
        [label,~,dec_val] = libsvmpredict(0,test_data(i,index),model,'-b 1');
        
        xlswrite(xlsx_file,{subs(i).name(1:end-4)}, sheet, ['A', num2str(i + 1)]);
        xlswrite(xlsx_file,{double(dec_val(1,1))}, sheet, ['B', num2str(i + 1)]);           
    end

end