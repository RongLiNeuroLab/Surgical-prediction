function [mse,bestc,bestg] = SVMcgForRegress(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,msestep)
%SVMcg cross validation by faruto
%Email:farutoliyang@gmail.com QQ:516667408 http://blog.sina.com.cn/faruto BNU
%last modified 2009.8.23
%Super Moderator @ www.ilovematlab.cn
%% about the parameters of SVMcg 
if nargin < 10
    msestep = 20;
end
if nargin < 7
    msestep = 20;
    v = 3;
    cstep = 1;
    gstep = 1;
end
if nargin < 6
    msestep = 20;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
end
if nargin < 5
    msestep = 20;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
end
if nargin < 4
    msestep = 20;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
end
if nargin < 3
    msestep = 20;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
    cmin = -5;
end
%% X:c Y:g cg:acc
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);
%% record acc with different c & g,and find the bestacc with the smallest c
bestc = 0;
bestg = 0;
mse = 10^10;
basenum = 2;
for i = 1:m
    for j = 1:n
        cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) ),' -s 3 -p 0.1 -n 0.1'];
        cg(i,j) = libsvmtrain(train_label, train, cmd);
        
        if cg(i,j) < mse
            mse = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        if ( cg(i,j) == mse && bestc > basenum^X(i,j) )
            mse = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        
    end
end
%% to draw the acc with different c & g
% figure;
% [C,h] = contour(X,Y,cg,0:msestep:1000);
% clabel(C,h,'FontSize',10,'Color','r');
% xlabel('log2c','FontSize',10);
% ylabel('log2g','FontSize',10);
% grid on;








