function [accuracy, Miss]=Categorize_DCNN(train_data, eval_data)
    %train_size = size(train_data,1);
    % ポジティブとネガティブの画像の数は等しい

    %disp(size(train_data,1)/2)
    %disp(size(eval_data,1)/2)

    train_label = [ones(size(train_data,1)/2,1); ones(size(train_data,1)/2,1)*(-1)];
    eval_label = [ones(size(eval_data,1)/2,1); ones(size(eval_data,1)/2,1)*(-1)];

    %disp(train_label)
    %disp(eval_label)
    %trainデータで学習
    model=fitcsvm(train_data,train_label,'KernelFunction','linear');
    %テストデータ(eval_data)で評価
    [plabel,score]=predict(model,eval_data);
    %正しく分類できた割合
    accuracy=numel(find(plabel==eval_label))/numel(eval_label);

    Miss = find(plabel~=eval_label); %間違えたeval_label の添え字を返す
end