%make_list.m を実行

% 125, 125, 150, 150
num_yaki = size_list(1)+size_list(2); %250 (たい焼きとどら焼き)

%種類ごとのdatabaseでの添え字
idx_taiyaki = [1:num_yaki/2];
idx_dorayaki = [num_yaki/2+1:num_yaki];

cv=5;

net_alex = alexnet;
net_vgg = vgg19;
net_dense = densenet201;

%たい焼き、どら焼きのネットワークごとのサイズに合わせたデータをつくる
for j=1:num_yaki
    img = imread(list{j});
    reimg_alex = imresize(img,net_alex.Layers(1).InputSize(1:2));
    reimg_vgg = imresize(img,net_vgg.Layers(1).InputSize(1:2));
    reimg_dense = imresize(img,net_dense.Layers(1).InputSize(1:2));

    if j == 1
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
    train_taiyaki_alex=IM_alex(:,:,:,find(mod(idx_taiyaki, cv)~=(i-1)));
    eval_taiyaki_alex=IM_alex(:,:,:,find(mod(idx_taiyaki, cv)==(i-1)));
    train_dorayaki_alex=IM_alex(:,:,:,find(mod(idx_dorayaki, cv)~=(i-1))+num_yaki/2);
    eval_dorayaki_alex=IM_alex(:,:,:,find(mod(idx_dorayaki, cv)==(i-1))+num_yaki/2);
    
    train_yaki_alex=cat(4, train_taiyaki_alex, train_dorayaki_alex);
    eval_yaki_alex=cat(4, eval_taiyaki_alex, eval_dorayaki_alex);
    train_yaki_alex_DCNN = Feature_DCNN_layer(net_alex, train_yaki_alex, 'fc7');
    eval_yaki_alex_DCNN = Feature_DCNN_layer(net_alex, eval_yaki_alex, 'fc7');
    
    %vgg19でDCNN特徴量を取る
    train_taiyaki_vgg=IM_vgg(:,:,:,find(mod(idx_taiyaki, cv)~=(i-1)));
    eval_taiyaki_vgg=IM_vgg(:,:,:,find(mod(idx_taiyaki, cv)==(i-1)));
    train_dorayaki_vgg=IM_vgg(:,:,:,find(mod(idx_dorayaki, cv)~=(i-1))+num_yaki/2);
    eval_dorayaki_vgg=IM_vgg(:,:,:,find(mod(idx_dorayaki, cv)==(i-1))+num_yaki/2);
    
    train_yaki_vgg=cat(4, train_taiyaki_vgg, train_dorayaki_vgg);
    eval_yaki_vgg=cat(4, eval_taiyaki_vgg, eval_dorayaki_vgg);
    train_yaki_vgg_DCNN = Feature_DCNN_layer(net_vgg, train_yaki_vgg, 'fc7');
    eval_yaki_vgg_DCNN = Feature_DCNN_layer(net_vgg, eval_yaki_vgg, 'fc7');

    %densenetでDCNN特徴量を取る
    train_taiyaki_dense=IM_dense(:,:,:,find(mod(idx_taiyaki, cv)~=(i-1)));
    eval_taiyaki_dense=IM_dense(:,:,:,find(mod(idx_taiyaki, cv)==(i-1)));
    train_dorayaki_dense=IM_dense(:,:,:,find(mod(idx_dorayaki, cv)~=(i-1))+num_yaki/2);
    eval_dorayaki_dense=IM_dense(:,:,:,find(mod(idx_dorayaki, cv)==(i-1))+num_yaki/2);
    
    train_yaki_dense=cat(4, train_taiyaki_dense, train_dorayaki_dense);
    eval_yaki_dense=cat(4, eval_taiyaki_dense, eval_dorayaki_dense);
    train_yaki_dense_DCNN = Feature_DCNN_layer(net_dense, train_yaki_dense, 'avg_pool');
    eval_yaki_dense_DCNN = Feature_DCNN_layer(net_dense, eval_yaki_dense, 'avg_pool');
    
    Idx_eval = find(mod(idx_taiyaki, cv)==(i-1));
    Idx_eval = cat(2, Idx_eval, Idx_eval+num_yaki/2);  %テスト画像のlist での添え字

    %ネットワークごとに線形SVMで分類
    %miss_*: 分類に間違えたテストラベルの添え字
    [accuracy_alex(i), miss_alex] = Categorize_DCNN(train_yaki_alex_DCNN, eval_yaki_alex_DCNN);
    [accuracy_vgg(i), miss_vgg] = Categorize_DCNN(train_yaki_vgg_DCNN, eval_yaki_vgg_DCNN);
    [accuracy_dense(i), miss_dense] = Categorize_DCNN(train_yaki_dense_DCNN, eval_yaki_dense_DCNN);
    
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