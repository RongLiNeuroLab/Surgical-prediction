function move_file(T1file)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
subs = dir(T1file);%for files
subs(1:2) = [];

mkdir([T1file(1:end-5) 'vbm_Results']);
Outfile1 = [T1file(1:end-5) 'vbm_Results'];

for i = 1:length(subs)
    sub_name = subs(i).name;
    files = [T1file filesep sub_name filesep 'mri'];
    file_num = dir(files);%��ȡ���ļ�
    if isempty(length(file_num)) == 0
        copy_file = [files filesep file_num(3).name];
        copyfile(copy_file,Outfile1);%����
    end
end
end
