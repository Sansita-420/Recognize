%make_list2.m を実行
%list_takoyaki, size_takoyaki
%50(上位50枚), 1000(ランダム画像), 300(ノイズあり)

%num_pos = 50; %使用するポジティブ画像の枚数
num_pos = 25; %使用するポジティブ画像の枚数
num_train = size_takoyaki(1)+size_takoyaki(2);
num_eval = size_takoyaki(3);

net_alex = alexnet;
net_vgg = vgg19;
net_dense = densenet201;

%ネットワークごとのサイズに合わせた学習データをつくる
for j=1:num_train
    if num_pos==25 & j>25 & j<=50 %物体の学習画像を25枚にするとき
        continue;
    end
    img = imread(list_takoyaki{j});

    % 画像がグレースケール（白黒）かどうか判定
    if size(img, 3) == 1
        img = cat(3, img, img, img); % 3チャンネル(RGB)に変換
    end
    %リサイズ
    reimg_alex = imresize(img,net_alex.Layers(1).InputSize(1:2));
    reimg_vgg = imresize(img,net_vgg.Layers(1).InputSize(1:2));
    reimg_dense = imresize(img,net_dense.Layers(1).InputSize(1:2));

    if j == 1
        IM_alex_train = cat(4, reimg_alex);
        IM_vgg_train = cat(4, reimg_vgg);
        IM_dense_train = cat(4, reimg_dense);
    else
        IM_alex_train = cat(4, IM_alex_train, reimg_alex);
        IM_vgg_train = cat(4, IM_vgg_train, reimg_vgg);
        IM_dense_train = cat(4, IM_dense_train, reimg_dense);
    end
end

% size(IM_alex);
%ネットワークごとのDCNN特徴量
alex_DCNN_train = Feature_DCNN_layer(net_alex, IM_alex_train, 'fc7');
vgg_DCNN_train = Feature_DCNN_layer(net_vgg, IM_vgg_train, 'fc7');
dense_DCNN_train = Feature_DCNN_layer(net_dense, IM_dense_train, 'avg_pool');

%ネットワークごとのサイズに合わせたテストデータをつくる
for j=num_train+1:num_train+num_eval
    img = imread(list_takoyaki{j});
    
    % 画像がグレースケール（白黒）かどうか判定
    if size(img, 3) == 1
        img = cat(3, img, img, img); % 3チャンネル(RGB)に変換
    end
    reimg_alex = imresize(img,net_alex.Layers(1).InputSize(1:2));
    reimg_vgg = imresize(img,net_vgg.Layers(1).InputSize(1:2));
    reimg_dense = imresize(img,net_dense.Layers(1).InputSize(1:2));

    if j == num_train+1
        IM_alex_eval = cat(4, reimg_alex);
        IM_vgg_eval = cat(4, reimg_vgg);
        IM_dense_eval = cat(4, reimg_dense);
    else
        IM_alex_eval = cat(4, IM_alex_eval, reimg_alex);
        IM_vgg_eval = cat(4, IM_vgg_eval, reimg_vgg);
        IM_dense_eval = cat(4, IM_dense_eval, reimg_dense);
    end
end
alex_DCNN_eval = Feature_DCNN_layer(net_alex, IM_alex_eval, 'fc7');
vgg_DCNN_eval = Feature_DCNN_layer(net_vgg, IM_vgg_eval, 'fc7');
dense_DCNN_eval = Feature_DCNN_layer(net_dense, IM_dense_eval, 'avg_pool');


[alex_score, alex_idx] = Reranking_DCNN(alex_DCNN_train, alex_DCNN_eval, num_pos);
[vgg_score, vgg_idx] = Reranking_DCNN(vgg_DCNN_train, vgg_DCNN_eval, num_pos);
[dense_score, dense_idx] = Reranking_DCNN(dense_DCNN_train, dense_DCNN_eval, num_pos);


% sorted_idxを使って画像ファイル名，さらに
% sorted_score[i](=score[sorted_idx[i],2])の値を出力します．
disp('Alexnet によるランキング');
for i=1:numel(alex_idx)
  fprintf('[%i] %s %f\n', i, list_takoyaki{alex_idx(i)+num_train}, alex_score(i));
end

disp('Vgg19 によるランキング');
for i=1:numel(vgg_idx)
  fprintf('[%i] %s %f\n', i, list_takoyaki{vgg_idx(i)+num_train}, vgg_score(i));
end

disp('Densenet によるランキング');
for i=1:numel(dense_idx)
  fprintf('[%i] %s %f\n', i, list_takoyaki{dense_idx(i)+num_train}, dense_score(i));
end