%make_codebook.m を実行後
%load('codebook_yaki.mat'); %visual_words:500
%load('codebook_man.mat');
load('codebook_yaki_1000.mat'); %visual_words:1000
load('codebook_man_1000.mat');

%num_vwords = 500; %visual_words の数
num_vwords = 1000;

%sel_yaki:(num_yaki*num_sampleからランダムに500個)
% ->num_sampleで割る:画像の番号
%sel_man

% 125, 125, 150, 150
%num_yaki = size_list(1)+size_list(2); %250 (たい焼きとどら焼き)
%num_man = size_list(3)+size_list(4); %300 (スパイダーマンとデッドプール)

bof_yaki = zeros(num_yaki, num_vwords); %500: visual_wordの数
bof_man = zeros(num_man, num_vwords);

for j=1:num_yaki % たい焼き、どら焼きの画像
    I = rgb2gray(imread(list{j}));
    p=createRandomPoints(I,num_sample); %1000個ランダムに特徴点を取る
    [f,p2]=extractFeatures(I,p);      %特徴点を抽出
    
    %その画像の特徴点に一番近いvisual_wordsを探す
    for i=1:num_sample
        rep = repmat(f(i,:), num_vwords, 1);  %fのi行 を1000行複製-> 1000*64
        dis = (rep-codebook_yaki).^2; %画像の特徴点 と 各visual word の差
        dis = sqrt(sum(dis'));   %列(転置前は行)ごとの和
        [sim, sim_yaki] = min(dis); %一番似ている特徴点
        % bofヒストグラム行列のj番目の画像のindexに投票
        % (たとえば，bof(j,index)=bof(j,index)+1; )
        bof_yaki(j, sim_yaki) = bof_yaki(j, sim_yaki)+1;
    end
end
%bof_yaki = bof_yaki ./ sum(bof_yaki,2); %正規化だが、SVMのために正規化しない

for j=1:num_man %スパイダーマン、デッドプールの画像
    I = rgb2gray(imread(list{num_yaki+j}));
    p=createRandomPoints(I,num_sample); %1000個ランダムに特徴点を取る
    [f,p2]=extractFeatures(I,p);      %特徴点を抽出
    
    %その画像の特徴点に一番近いvisual_wordsを探す
    %for i=1:num_sample %1000個特徴点を取れないこともあった
    for i=1:size(f,1)
        rep = repmat(f(i,:), num_vwords, 1);  %fのi行 を1000行複製-> 1000*64
        dis = (rep-codebook_man).^2; %画像の特徴点 と 各visual word の差
        dis = sqrt(sum(dis'));   %列(転置前は行)ごとの和
        [sim, sim_man] = min(dis); %一番似ている特徴点
        % bofヒストグラム行列のj番目の画像のindexに投票
        % (たとえば，bof(j,index)=bof(j,index)+1; )
        bof_man(j, sim_man) = bof_man(j, sim_man)+1;
    end
end
%bof_man = bof_man ./ sum(bof_man,2); %正規化だが、SVMのために正規化しない