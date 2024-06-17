clc;
clear;
% predict code
%% internal test

% Load the internal features,include bilateral,lpsilateral,contralateral features.
load('workpath/Datacell.mat');

% the group label of patient,0 is SF, 1 is NSF
load('workpath/GroupIdx.mat');
%
n = size(GroupIdx,1);
% number of folders
k = 10;
%feature number
featurenum = 25;

n1=find(GroupIdx==0);
n2=find(GroupIdx==1);
ind1=crossvalind('Kfold',length(n1),k);
ind2=crossvalind('Kfold',length(n2),k);


Label =GroupIdx;

% for 3 features£¬ bilateral,lpsilateral,contralateral.
for ii=1:3
    Data=Datacell{ii};
    [~,n] = size(Data);
    acc_train = zeros(k,1); acc_test = zeros(k,1);
    dec_val = zeros(m,2);
    predict_label = zeros(m,1);
    exclude_rate = 0.01;
    % cross validation
    for i = 1:k
        train_data = Data(:,:);
        train_label = double(Label(:,:));
        test_data = Data((indices == i),:);
        test_label = double(Label((indices == i),:));
        % feature selected
        score = fscore(train_data,train_label);
        [~,I]=sort(score,'desc');
        index = I(1:featurenum);
        model = libsvmtrain(train_label,train_data(:,index),'-t 0 -b 1 -c 1');
        pre_train_label = libsvmpredict(train_label,train_data(:,index),model,'-b 1');
        
        [pre_test_label,dd,dec_val(indices == i,:)]  = libsvmpredict(test_label,test_data(:,index),model,'-b 1');
        predict_label((indices == i)) = pre_test_label;
        acc_train(i) = sum(pre_train_label == train_label) / length(train_label);
        acc_test(i) = sum(pre_test_label == test_label) / length(test_label);
    end
    
    %% plot ROC curve
    AUC = Roc(Label,dec_val(:,2));

    TP = sum(predict_label & Label); TN = sum(~predict_label & ~Label);
    FP = sum(predict_label & ~Label); FN = sum(~predict_label & Label);
    ACC = (TP + TN) / (TP + TN + FP + FN);
    Sensitivity = TP / (TP + FN);
    Specificity = TN / (TN + FP);
    PPV = TP / (TP + FP);
    NPV = TN / (TN + FN);
    YOI = TP / (TP + FN) + TN / (TN + FP) - 1;
    acc = mean(acc_test);

    fprintf('Final accuracy: %.2f%%\n',acc * 100);
    fprintf('Model sensitivity: %.2f\n',Sensitivity);
    fprintf('Model specificity: %.2f\n',Specificity);
    fprintf('Model AUC: %.2f\n',AUC );
    fprintf('Model NPV: %.2f\n',NPV );
    fprintf('Model PPV: %.2f\n',PPV );
    fprintf('Model YOI: %.2f\n',YOI );
end



%% external test


% the regional feature and the group of test cohort
load('workpath/TestDatacell.mat');
load('workpath/TestGroupIdx.mat');
% for 3 features£¬ bilateral,lpsilateral,contralateral.
for j = 1:3
    test_data = TestDatacell{j};
    test_label = TestGroupIdx;
    train_data = Datacell{i};
    train_label = GroupIdx;

    score = fscore(train_data,train_label);
    [~,I]=sort(score,'desc');
    % selected features
    index = I(1:featurenum);
    score = fscore(train_data,train_label);
    % make model 
    model = libsvmtrain(train_label,train_data(:,index),'-t 0 -b 1 -c 1');
    [predict_label,dd,dec_val] = libsvmpredict(test_label,test_data,model,'-b 1');
    predict_label = predict_label';
    TEST_TP = sum(predict_label & test_label); TEST_TN = sum(~predict_label & ~test_label);
    TEST_TEST_FP = sum(predict_label & ~test_label); TEST_FN = sum(~predict_label & test_label);
    TEST_ACC = (TEST_TP + TEST_TN) / (TEST_TP + TEST_TN + TEST_TEST_FP + TEST_FN);
    TEST_Sensitivity = TEST_TP / (TEST_TP + TEST_FN);
    TEST_Specificity = TEST_TN / (TEST_TN + TEST_TEST_FP);
    TEST_PPV = TEST_TP / (TEST_TP + TEST_TEST_FP);
    TEST_NPV = TEST_TN / (TEST_TN + TEST_FN);
    TEST_YOI = TEST_TP / (TEST_TP + TEST_FN) + TEST_TN / (TEST_TN + TEST_TEST_FP) - 1;
    TEST_AUC = Roc(test_label,dec_val(:,2));
    TEST_TEST_FPrintf('Final TEST_ACCuracy: %.2f%%\n',TEST_ACC * 100);
    TEST_TEST_FPrintf('Model TEST_Sensitivity: %.2f\n',TEST_Sensitivity);
    TEST_TEST_FPrintf('Model TEST_Specificity: %.2f\n',TEST_Specificity);
    TEST_TEST_FPrintf('Model TEST_AUC: %.2f\n',TEST_AUC );
    TEST_TEST_FPrintf('Model TEST_NPV: %.2f\n',TEST_NPV );
    TEST_TEST_FPrintf('Model TEST_PPV: %.2f\n',TEST_PPV );
    TEST_TEST_FPrintf('Model TEST_YOI: %.2f\n',TEST_YOI );
end
