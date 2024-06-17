function makeNetwork(InputPath, OutPutPath, CovariatesPath,currentFolder, lateralPath)
    [tle_cov,~,~]=xlsread(CovariatesPath);
    mask = y_Read([currentFolder filesep 'Resources\Function\statistics\246_mask.nii']);
    hc_cov = load([currentFolder filesep 'Resources\Function\statistics\hc_cov.mat']);  %mat£ºhc_cov
    load([currentFolder filesep 'Resources\Function\statistics\HC_GM.mat']);   % mat£ºHC_GM
    load([currentFolder filesep 'Resources\Function\statistics\GMcov.mat']);    % mat£ºGMcov
    
%     InputPath = 'O:\hyw\SC\test'
    xml_sub = dir(InputPath);
    xml_sub = xml_sub(3:end);
    
    len = length(xml_sub);
    tiv = zeros(len,1);
    
    for i=1:len
        sub_path =[xml_sub(i).folder,'\',xml_sub(i).name,'\report\'];
        sub_mat = dir(fullfile([sub_path,'*.mat']));
        load([sub_mat.folder,'\',sub_mat.name]);
        tiv(i) = S.subjectmeasures.vol_TIV;
    end
    
    
    tle_cov = [tiv,tle_cov];
    vbm_smooth_path = [InputPath(1:end-5) 'vbm_smooth_Results'];
    subs = dir([InputPath(1:end-5) 'vbm_smooth_Results']);
    subs = subs(3:end);
    rois = max(mask(:));
    TLE_GM = zeros(length(subs),rois);
    count = 0;
    for s = 1 : length(subs)
        count = count + 1;
        %fprintf('Calculating:%d\n',count);
        GM = y_Read([vbm_smooth_path filesep subs(s).name]);
        col = 0;
        for m = 1 :rois
                col = col + 1;
                GMvalue = GM(mask == m);
                GMvalue(isnan(GMvalue)) = [];
                TLE_GM(count,col) = mean(GMvalue(:));       
        end
    end
    % ±£´æ
%     save([OutPutPath filesep 'TLE_GM.mat'],'TLE_GM');
    
    A = 1 + eye(rois,rois);
    A(A == 2) = 0;
    edgeVar_TLEsign = zeros(rois,rois,size(TLE_GM,1));
    
    [lateral,~,~] = xlsread(lateralPath);    
    enindex=1:2:246;
    odindex=2:2:246;
    
    for sub = 1 : size(TLE_GM,1)
        fprintf('Calculate:%d\n',sub)
        concatGM = [HC_GM;TLE_GM(sub,:)];
        concatcov = [hc_cov.hc_cov;tle_cov(sub,:)];
        new_GM = partialcorr(concatGM, concatcov).* A;
        sub_scn = new_GM - GMcov;
        if lateral(sub)==1
            matrix=sub_scn;
            sub_scn(enindex,enindex)=matrix(odindex,odindex);
            sub_scn(enindex,odindex)=matrix(odindex,enindex);
            sub_scn(odindex,enindex)=matrix(enindex,odindex);
            sub_scn(odindex,odindex)=matrix(enindex,enindex);
        end
        save([OutPutPath filesep subs(sub).name(1:end-4) '.mat'],'sub_scn');
        %edgeVar_TLEsign(:,:,sub) = new_GM - GMcov;
    end
%     save([OutPutPath filesep 'edgeVar_TLEsign.mat'],'edgeVar_TLEsign');
end

