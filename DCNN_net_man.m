%make_list.m を実行

% 125, 125, 150, 150
num_yaki = size_list(1)+size_list(2); %250 (たい焼きとどら焼き)
num_man = size_list(3)+size_list(4); %300 (スパイダーマンとデッドプール)

%種類ごとのdatabaseでの添え字
idx_spiderman = [num_man+1:num_man+num_man/2];
idx_deadpool = [num_man+num_man/2+1:num_man+num_man];
cv=5;

net_alex = alexnet;
net_vgg = vgg19;
net_dense = densenet201;

%スパイダーマン、デッドプールの画像をネットワークごとのサイズに合わせたデータをつくる
for j=num_yaki+1:num_yaki+num_man
    img = imread(list{j});
    reimg_alex = imresize(img,net_alex.Layers(1).InputSize(1:2));
    reimg_vgg = imresize(img,net_vgg.Layers(1).InputSize(1:2));
    reimg_dense = imresize(img,net_dense.Layers(1).InputSize(1:2));

    if j == num_yaki+1
        IM_alex = cat(4, reimg_alex);
        IM_vgg = cat(4, reimg_vgg);
        IM_dense = cat(4, reimg_dense);
    else
        IM_alex = cat(4, IM_alex, reimg_alex);
        IM_vgg = cat(4, IM_vgg, reimg_vgg);
        IM_dense = cat(4, IM_dense, reimg_dense);
    end
    
end

%ネットワークごとの分類率
accuracy_alex=zeros(cv, 1);
accuracy_vgg=zeros(cv, 1);
accuracy_dense=zeros(cv, 1);

%ネットワークごとの間違いのテスト画像
Miss_alex = [];
Miss_vgg = [];
Miss_dense = [];

%5cross-validation
tic;
for i=1:cv
    %alexnetでDCNN特徴量を取る
    train_spiderman_alex=IM_alex(:,:,:,find(mod(idx_spiderman, cv)~=(i-1)));
    eval_spiderman_alex=IM_alex(:,:,:,find(mod(idx_spiderman, cv)==(i-1)));
    train_deadpool_alex=IM_alex(:,:,:,find(mod(idx_deadpool, cv)~=(i-1))+num_man/2);
    eval_deadpool_alex=IM_alex(:,:,:,find(mod(idx_deadpool, cv)==(i-1))+num_man/2);
    
    train_man_alex=cat(4, train_spiderman_alex, train_deadpool_alex);
    eval_man_alex=cat(4, eval_spiderman_alex, eval_deadpool_alex);
    train_man_alex_DCNN = Feature_DCNN_layer(net_alex, train_man_alex, 'fc7');
    eval_man_alex_DCNN = Feature_DCNN_layer(net_alex, eval_man_alex, 'fc7');
    
    %vgg19でDCNN特徴量を取る
    train_spiderman_vgg=IM_vgg(:,:,:,find(mod(idx_spiderman, cv)~=(i-1)));
    eval_spiderman_vgg=IM_vgg(:,:,:,find(mod(idx_spiderman, cv)==(i-1)));
    train_deadpool_vgg=IM_vgg(:,:,:,find(mod(idx_deadpool, cv)~=(i-1))+num_man/2);
    eval_deadpool_vgg=IM_vgg(:,:,:,find(mod(idx_deadpool, cv)==(i-1))+num_man/2);
    
    train_man_vgg=cat(4, train_spiderman_vgg, train_deadpool_vgg);
    eval_man_vgg=cat(4, eval_spiderman_vgg, eval_deadpool_vgg);
    train_man_vgg_DCNN = Feature_DCNN_layer(net_vgg, train_man_vgg, 'fc7');
    eval_man_vgg_DCNN = Feature_DCNN_layer(net_vgg, eval_man_vgg, 'fc7');

    %densenetでDCNN特徴量を取る
    train_spiderman_dense=IM_dense(:,:,:,find(mod(idx_spiderman, cv)~=(i-1)));
    eval_spiderman_dense=IM_dense(:,:,:,find(mod(idx_spiderman, cv)==(i-1)));
    train_deadpool_dense=IM_dense(:,:,:,find(mod(idx_deadpool, cv)~=(i-1))+num_man/2);
    eval_deadpool_dense=IM_dense(:,:,:,find(mod(idx_deadpool, cv)==(i-1))+num_man/2);
    
    train_man_dense=cat(4, train_spiderman_dense, train_deadpool_dense);
    eval_man_dense=cat(4, eval_spiderman_dense, eval_deadpool_dense);
    train_man_dense_DCNN = Feature_DCNN_layer(net_dense, train_man_dense, 'avg_pool');
    eval_man_dense_DCNN = Feature_DCNN_layer(net_dense, eval_man_dense, 'avg_pool');
    
    Idx_eval = find(mod(idx_spiderman, cv)==(i-1));
    Idx_eval = cat(2, Idx_eval+num_yaki, Idx_eval+num_yaki+num_man/2);  %テスト画像のlist での添え字

    %ネットワークごとに線形SVMで分類
    %miss_*: 分類に間違えたテストラベルの添え字
    [accuracy_alex(i), miss_alex] = Categorize_DCNN(train_man_alex_DCNN, eval_man_alex_DCNN);
    [accuracy_vgg(i), miss_vgg] = Categorize_DCNN(train_man_vgg_DCNN, eval_man_vgg_DCNN);
    [accuracy_dense(i), miss_dense] = Categorize_DCNN(train_man_dense_DCNN, eval_man_dense_DCNN);
    
    Miss_alex = [Miss_alex, Idx_eval(miss_alex)];
    Miss_vgg = [Miss_vgg, Idx_eval(miss_vgg)];
    Miss_dense = [Miss_dense, Idx_eval(miss_dense)];

end
toc

fprintf('accuracy_alex: %f\n',mean(accuracy_alex))
Miss_alex
fprintf('accuracy_vgg: %f\n',mean(accuracy_vgg))
Miss_vgg
fprintf('accuracy_densenet: %f\n',mean(accuracy_dense))
Miss_dense