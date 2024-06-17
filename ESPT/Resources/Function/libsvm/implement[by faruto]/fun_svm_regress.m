function [ptest,test_mse,ptrain,train_mse,model,bestmse,bestc,bestg]=fun_svm_regress(train_x,train_y,test_x,test_y,method)
%fun_svm_regress
%% 
% 
% by nneerr123
% 
%
%
%
%
%
%
%% 
% faruto and liyang , LIBSVM-farutoUltimateVersion 
% a toolbox with implements for support vector machines based on libsvm, 2009. 
% Software available at http://www.ilovematlab.cn
% 
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm
 %%
if nargin<5
    method='grid';
end
if nargin <3
    test_x=train_x;
    test_y=train_y;
end
if nargin<2
    train_y=train_x;
end
%% 归一化处理
  [train_x_scale,test_x_scale] = scaleForSVM(train_x,test_x,0,1);
  [train_y_scale,test_y_scale,ps] = scaleForSVM(train_y,test_y,0,1);
 % train_y_scale=train_y;
%   test_y_scale=test_y;

%% 参数寻优
switch lower(method)
    case 'grid'
        [bestmse,bestc,bestg] = SVMcgForRegress(train_y_scale,train_x_scale);
    case 'ga'
        ga_option.maxgen = 100;
        ga_option.sizepop = 20;
        ga_option.ggap = 0.9;
        ga_option.cbound = [0,100];
        ga_option.gbound = [0,100];
        ga_option.v = 5;
        [bestmse,bestc,bestg] =...
            gaSVMcgForRegress(train_y_scale,train_x_scale,ga_option);
    case 'pso'
        pso_option.c1 = 1.5;
        pso_option.c2 = 1.7;
        pso_option.maxgen = 100;
        pso_option.sizepop = 20;
        pso_option.k = 0.6;
        pso_option.wV = 1;
        pso_option.wP = 1;
        pso_option.v = 3;
        pso_option.popcmax = 100;
        pso_option.popcmin = 0.1;
        pso_option.popgmax = 100;
        pso_option.popgmin = 0.1;
        [bestmse,bestc,bestg] =...
              psoSVMcgForRegress(train_y_scale,train_x_scale,pso_option);
end
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -s 3 -p 0.01'];
%% 训练并对训练集回归预测
model=svmtrain(train_y_scale,train_x_scale,cmd);

[ptrain, train_mse] = svmpredict(train_y_scale, train_x_scale, model);

ptrain=mapminmax('reverse',ptrain',ps);

ptrain=ptrain';

%% 对测试集回归预测
[ptest,test_mse]=svmpredict(test_y_scale,test_x_scale,model);

ptest=mapminmax('reverse',ptest',ps);

ptest=ptest';
%% 可视化
figure;
subplot(2,1,1);
plot(train_y,'-o');
hold on;
plot(ptrain,'r-s');
grid on;
legend('original','predict');
title('Train Set Regression Predict by SVM');
hold off

subplot(2,1,2);
plot(test_y,'-d');
hold on
plot(ptest,'r-*');
legend('original','predict');
title('Test Set Regression Predict by SVM');
grid on;
hold off










