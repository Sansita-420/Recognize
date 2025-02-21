function [sorted_score,sorted_idx]=Reranking_DCNN(train_data, eval_data, num_pos) %num_pos: ポジティブ画像の枚数(25 or 50)
    num_neg = size(train_data,1)-num_pos; %ネガティブ画像の枚数
    train_label = [ones(num_pos,1); ones(num_neg,1)*(-1)];

    %disp(train_label)
    %trainデータで学習
    model=fitcsvm(train_data,train_label,'KernelFunction','linear');
    %テストデータ(eval_data)で評価
    [label,score]=predict(model,eval_data);
    
    % 降順 ('descent') でソートして，ソートした値とソートインデックスを取得します．
    [sorted_score,sorted_idx] = sort(score(:,2),'descend');
end