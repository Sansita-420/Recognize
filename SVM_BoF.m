%BoF.m を実行後
%bof_yaki: (num_yaki(250), 500), bof_man: (num_man(300), 500)
%種類ごとのbofでの添え字
idx_taiyaki = [1:num_yaki/2];
idx_dorayaki = [num_yaki/2+1:num_yaki];
idx_spiderman = [num_yaki+1:num_yaki+num_man/2];
idx_deadpool = [num_yaki+num_man/2+1:num_yaki+num_man];

Cat_yaki = 0; %たい焼き、どら焼きの分類率
Cat_man = 0; %スパイダーマン、デッドプールの分類率
Miss_yaki = [];
Miss_man = [];

cv = 5;
tic
for j=1:cv
    % どら焼き、たい焼きの分類
    %学習画像とテスト画像に分ける
    Idx_train = find(mod(idx_taiyaki,cv)~=(j-1)); %1クラスデータの5等分の4つ
    Idx_eval = find(mod(idx_taiyaki,cv)==(j-1));  %5等分の1つ (1, 25)

    train_taiyaki=bof_yaki(Idx_train, :); %num_yaki/2-25=100
    eval_taiyaki=bof_yaki(Idx_eval, :); %25
    train_dorayaki=bof_yaki(Idx_train+num_yaki/2, :);
    eval_dorayaki=bof_yaki(Idx_eval+num_yaki/2, :);

    %学習データをポジティブ、ネガティブどちらも合わせる
    train_yaki = cat(1, train_taiyaki, train_dorayaki);
    eval_yaki = cat(1, eval_taiyaki, eval_dorayaki);
    num_train = size(train_yaki,1); %200
    num_eval = size(eval_yaki,1); %50
    train_label = [ones(num_train/2, 1); ones(num_train/2, 1)*(-1)];
    eval_label = [ones(num_eval/2, 1); ones(num_eval/2, 1)*(-1)];
    
    %非線形
    %tic;
    %model=fitcsvm(train_yaki,train_label,'KernelFunction','rbf','KernelScale','auto');
    %かつ正規化
    model_yaki=fitcsvm(train_yaki,train_label,'KernelFunction','rbf','KernelScale','auto','Standardize',true);
    [plabel,score]=predict(model_yaki,eval_yaki);
    %分類率
    %disp("たい焼き、どら焼きの分類率");
    Cat_yaki = Cat_yaki + numel(find(eval_label==plabel))/numel(eval_label);

    Idx_eval = cat(2, Idx_eval, Idx_eval+num_yaki/2); %たい焼き、どら焼きのテスト画像のlist での添え字
    Miss_yaki = [Miss_yaki, Idx_eval(find(eval_label~=plabel))]; %たい焼き、どら焼きの分類に間違えたリスト
    %disp(Cat_yaki);
    %toc
    
    %スパイダーマン、デッドプールの分類
    %学習画像とテスト画像に分ける
    Idx_train = find(mod(idx_spiderman,cv)~=(j-1)); %1クラスデータの5等分の4つ
    Idx_eval = find(mod(idx_spiderman,cv)==(j-1));  %5等分の1つ

    train_spiderman=bof_man(Idx_train, :); %num_man/2-30=120
    eval_spiderman=bof_man(Idx_eval, :); %30
    train_deadpool=bof_man(Idx_train+num_man/2, :);
    eval_deadpool=bof_man(Idx_eval+num_man/2, :);

    %学習データをポジティブ、ネガティブどちらも合わせる
    train_man = cat(1, train_spiderman, train_deadpool);
    eval_man = cat(1, eval_spiderman, eval_deadpool);
    num_train = size(train_man,1); %240
    num_eval = size(eval_man,1); %60
    train_label = [ones(num_train/2, 1); ones(num_train/2, 1)*(-1)];
    eval_label = [ones(num_eval/2, 1); ones(num_eval/2, 1)*(-1)];
    
    %非線形
    %tic;
    %model=fitcsvm(train_yaki,train_label,'KernelFunction','rbf','KernelScale','auto');
    %かつ正規化
    model_man=fitcsvm(train_man,train_label,'KernelFunction','rbf','KernelScale','auto','Standardize',true);
    [plabel,score]=predict(model_man,eval_man);
    %分類率
    %disp("スパイダーマン、デッドプールの分類率");
    Cat_man = Cat_man + numel(find(eval_label==plabel))/numel(eval_label);

    Idx_eval = cat(2, Idx_eval+num_yaki, Idx_eval+num_yaki+num_man/2); %スパイダーマン、、デッドプールのテスト画像のlist での添え字
    Miss_man = [Miss_man, Idx_eval(find(eval_label~=plabel))];  %スパイダーマン、、デッドプールの分類に間違えたリスト
    %disp(Cat_man);
    %toc
end
toc

disp("たい焼き、どら焼きの分類率");
Cat_yaki = Cat_yaki/cv

disp("スパイダーマン、デッドプールの分類率");
Cat_man = Cat_man/cv

%分類に間違えた数を返す
disp('たい焼き、どら焼きの分類間違い');
disp(size(Miss_yaki,2));
disp('スパイダーマン、デッドプールの分類間違い');
disp(size(Miss_man,2));
disp('どら焼きのみの分類間違い');
disp(numel(find(Miss_yaki > num_yaki/2)));
disp('デッドプールのみの分類間違い');
disp(numel(find(Miss_man > num_yaki+num_man/2)));