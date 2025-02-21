%make_list.m を実行後
% 125, 125, 150, 150
num_yaki = size_list(1)+size_list(2); %250 (たい焼きとどら焼き)
num_man = size_list(3)+size_list(4); %300 (スパイダーマンとデッドプール)

%num_sample = 300; %サンプリングする特徴点の数
num_sample = 1000;
%Features: 総画像の特徴点の数(1000*250=250000)*64 のベクトル
%Features_yaki=zeros(num_sample*num_yaki, 64);
%ランダムサンプリング
for i=1:num_yaki %250
  I=rgb2gray(imread(list{i}));  %ポジティブかネガティブの画像
  %p=detectSURFFeatures(I);          %特徴点見つける
  p=createRandomPoints(I,num_sample); %1000個ランダムに特徴点を取る
  [f,p2]=extractFeatures(I,p);      %特徴点を抽出
  if i==1
      Features_yaki = cat(1, f);
  else
      Features_yaki = cat(1, Features_yaki, f); %特徴量を保存
  end
end
%50000個ランダムに特徴量取る
sel_yaki = randperm(num_sample*num_yaki, 50000);
Features_yaki = Features_yaki(sel_yaki,:);
%visual_words 500個
[F_yaki_idx, codebook_yaki]=kmeans(Features_yaki, 1000, 'MaxIter',300);
save('codebook_yaki_1000.mat', 'codebook_yaki');

for i=num_yaki+1:num_yaki+num_man %251 ~ 550
  I=rgb2gray(imread(list{i}));  %ポジティブかネガティブの画像
  %p=detectSURFFeatures(I);          %特徴点見つける
  p=createRandomPoints(I,num_sample); %1000個ランダムに特徴点を取る
  [f,p2]=extractFeatures(I,p);      %特徴点を抽出
  if i==num_yaki+1
      Features_man = cat(1, f);
  else
      Features_man = cat(1, Features_man, f); %特徴量を保存
  end
end
%50000個ランダムに特徴量取る
sel_man = randperm(num_sample*num_man, 50000);
Features_man = Features_man(sel_man,:);
%visual_words 500個
[F_man_idx, codebook_man]=kmeans(Features_man, 1000, 'MaxIter',200);
save('codebook_man_1000.mat', 'codebook_man');