function maxAcc_set = t_mr_ref(train_data, train_label, p_thr, exclude_rate)
% MRMR + REF + SVM

n_feature = size(train_data,2);
n=size(train_data,1);
[~,p] = ttest2(train_data((train_label == 0),:),train_data((train_label ~= 0),:));
current_set = setdiff(1:n_feature, find(p>p_thr));

exclude_per_iter = fix(length(current_set) * exclude_rate());
if exclude_per_iter == 0
    exclude_per_iter = 1;
end
maxAcc = 0;
beta = 0.5;

while (~isempty(current_set))
    x_train = train_data(:, current_set); y_train = train_label;
    model = libsvmtrain(y_train, x_train, '-t 0 -c 1 -b 1');
    D = f_score(x_train, y_train);
    R = mean(corr(x_train), 2);
    r = mrmr(beta, D, R, model.SVs' * model.sv_coef, length(current_set));
    [~, Feature_idx] = sort(r, 'descend');

    predict_label = libsvmpredict(y_train, x_train, model, '-b 1');
    accuracy = sum(predict_label == y_train) / length(y_train);
    if (accuracy > maxAcc)
        maxAcc = accuracy;
        maxAcc_set = current_set;
    end
    current_set = current_set(Feature_idx(1:(length(Feature_idx) - exclude_per_iter)));
end

end

function F = f_score(data, label)
x1 = data(label==1, :);
x2 = data(label==0, :);
x = [x1;x2];
F = ((mean(x1) - mean(x)) .^ 2 + (mean(x2) - mean(x)) .^ 2) ...
    ./ (1 / (size(x1,1) - 1) * sum((bsxfun(@minus,x1,mean(x1)) .^ 2)) ...
    + 1 / (size(x2,1) - 1) * sum((bsxfun(@minus,x2,mean(x2)) .^ 2)));
F = F';
end

function r = mrmr(beta, D, R, weight, n)
r = beta * weight.^2 + (1-beta) * (D - R/(n+1));
end
