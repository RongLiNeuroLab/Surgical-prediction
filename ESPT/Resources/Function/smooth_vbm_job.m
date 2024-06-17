function smooth_vbm_job(T1file, fwhm)

mkdir([T1file(1:end-5) 'vbm_smooth_Results']);
Outfile1 = [T1file(1:end-5) 'vbm_smooth_Results'];

File=dir([T1file(1:end-5) 'vbm_Results']);
File(1:2)=[];
L=length(File);
IMG=cell(L,1);
for i = 1:L
    Subfile = fullfile(T1file(1:end-5),'vbm_Results',File(i).name);
    IMG{i,1}=[Subfile,',1'];
end
%%
matlabbatch{1}.spm.spatial.smooth.data = IMG;
%%
matlabbatch{1}.spm.spatial.smooth.fwhm = [fwhm fwhm fwhm];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', matlabbatch);

%%
subs = dir([T1file(1:end-5) 'vbm_Results']);
subs(1:2) = [];

n = length(subs);
for i = 1:n
    if i > n / 2
        move_file = [T1file(1:end-5) 'vbm_Results' filesep subs(i).name];
        movefile(move_file,Outfile1);%¸´ÖÆ
    end
end
end