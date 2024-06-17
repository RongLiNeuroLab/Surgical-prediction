function segment(T1Path, current_path)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%% Segment分割

File=dir(T1Path);
File(1:2)=[];
L=length(File);
IMG=cell(L,1);
for i = 1:L
    Subpath = fullfile(T1Path,File(i).name);
    Img=dir([Subpath,'\*.nii']);
    Imgpath=[Subpath filesep Img(1).name];
    IMG{i,1}=[Imgpath,',1'];  
end
%%
matlabbatch{1}.spm.tools.cat.estwrite.data = IMG;
%%
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 0; 
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {[current_path filesep 'Resources\Function\statistics\TPM.nii']};
matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.cleanupstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.darteltpm = {[current_path filesep 'Resources\Function\statistics\Template_1_IXI555_MNI152.nii']};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.shootingtpm = {[current_path filesep 'Resources\Function\statistics\Template_0_IXI555_MNI152_GS.nii']};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.regstr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;  %normalized 
matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROI = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [0 0];
spm_jobman('run', matlabbatch);

end
