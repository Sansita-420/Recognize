%DCNN_R2D2.m を実行後
%ネットワークごとの上位100個の画像
for i=1:100
    img = imread(list_R2D2{alex_idx(i)+num_train});
    n = mod(i-1,20)+1; %(余り: 0~19)+1
    if n==1
        figure;
    end
    subplot(4, 5, n), imshow(img);
end

for i=1:100
    img = imread(list_R2D2{vgg_idx(i)+num_train});
    n = mod(i-1,20)+1;
    if n==1
        figure;
    end
    subplot(4, 5, n), imshow(img);
end

for i=1:100
    img = imread(list_R2D2{dense_idx(i)+num_train});
    n = mod(i-1,20)+1;
    if n==1
        figure;
    end
    subplot(4, 5, n), imshow(img);
end