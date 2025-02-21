%make_list.m を実行してから
load('db.mat'); %database(カラーヒストグラム)をロード

%size(database) :550 64
% 125, 125, 150, 150
num_yaki = size_list(1)+size_list(2); %250 (たい焼きとどら焼き)
num_man = size_list(3)+size_list(4); %300 (スパイダーマンとデッドプール)

%種類ごとのdatabaseでの添え字
idx_taiyaki = [1:num_yaki/2];
idx_dorayaki = [num_yaki/2+1:num_yaki];
idx_spiderman = [num_yaki+1:num_yaki+num_man/2];
idx_deadpool = [num_yaki+num_man/2+1:num_yaki+num_man];
cv=5;

Cat_yaki = zeros(cv,1); %たい焼き、どら焼きの分類率
Cat_man = zeros(cv, 1); %スパイダーマン、デッドプールの分類率
Miss_taiyaki = [];
Miss_dorayaki = [];
Miss_spiderman = [];
Miss_deadpool = [];

for j=1:cv
    %たい焼き、どら焼き
    %学習画像とテスト画像に分ける
    Idx_train = find(mod(idx_taiyaki,cv)~=(j-1)); %1クラスデータの5等分の4つ
    Idx_eval = find(mod(idx_taiyaki,cv)==(j-1));  %5等分の1つ

    train_taiyaki=database(Idx_train, :); %num_yaki/2-25=100
    eval_taiyaki=database(Idx_eval, :); %25
    train_dorayaki=database(Idx_train+num_yaki/2, :);
    eval_dorayaki=database(Idx_eval+num_yaki/2, :);
    
    %学習データをポジティブ、ネガティブどちらも合わせる
    train_yaki = cat(1, train_taiyaki, train_dorayaki);
    num_train = size(train_yaki,1); %200
    num_eval = size(eval_taiyaki, 1)*2; %50

   % テスト画像のたい焼き、どら焼き を最近傍分類
    for i=1:num_eval/2
        %i番目のテスト画像のカラーヒストグラムを学習画像枚数行だけ複製
        rep_taiyaki=repmat(eval_taiyaki(i,:), num_train, 1);
        rep_dorayaki=repmat(eval_dorayaki(i,:), num_train, 1);
        %たい焼きの画像と学習画像の距離
        dis_taiyaki = (rep_taiyaki-train_yaki).^2;
        dis_taiyaki = sqrt(sum(dis_taiyaki')); %列(転置して)ごとの和
        [sim, sim_taiyaki] = min(dis_taiyaki); %一番似ている画像
        %どら焼きの画像と学習画像の距離
        dis_dorayaki = (rep_dorayaki-train_yaki).^2;
        dis_dorayaki = sqrt(sum(dis_dorayaki')); %列(転置して)ごとの和
        [sim, sim_dorayaki] = min(dis_dorayaki); %一番似ている画像
        
        % 似ている画像がたい焼きの画像と判断
        if sim_taiyaki <= num_train/2
            Cat_yaki(j) = Cat_yaki(j) + 1;
        else
            Miss_taiyaki = [Miss_taiyaki, Idx_eval(i)]; %分類に間違えた画像のlistの添え字を返す
        end
        % 似ている画像がどら焼きの画像と判断
        if sim_dorayaki > num_train/2
            Cat_yaki(j) = Cat_yaki(j) + 1;
        else
            Miss_dorayaki = [Miss_dorayaki, Idx_eval(i)+num_yaki/2];
        end
    end
    Cat_yaki(j) = Cat_yaki(j)/num_eval;
    
    %スパイダーマン、デッドプール
    %学習画像とテスト画像に分ける
    Idx_train = find(mod(idx_spiderman,cv)~=(j-1))+num_yaki; %1クラスデータの5等分の4つ
    Idx_eval = find(mod(idx_spiderman,cv)==(j-1))+num_yaki;  %5等分の1つ

    train_spiderman=database(Idx_train, :); %num_man/2-30=120 
    eval_spiderman=database(Idx_eval, :); %30
    train_deadpool=database(Idx_train+num_man/2, :);
    eval_deadpool=database(Idx_eval+num_man/2, :);
    
    %学習データをポジティブ、ネガティブどちらも合わせる
    train_man = cat(1, train_spiderman, train_deadpool);
    num_train = size(train_man,1); %240
    num_eval = size(eval_spiderman, 1)*2; %60
    
    % テスト画像のスパイダーマン、デッドプールを最近傍分類
    for i=1:num_eval/2
        %i番目のテスト画像のカラーヒストグラムを学習画像枚数行だけ複製
        rep_spiderman=repmat(eval_spiderman(i,:), num_train, 1);
        rep_deadpool=repmat(eval_deadpool(i,:), num_train, 1);
        %スパイダーマンの画像と学習画像の距離
        dis_spiderman = (rep_spiderman-train_man).^2;
        dis_spiderman = sqrt(sum(dis_spiderman')); %列(転置して)ごとの和
        [sim, sim_spiderman] = min(dis_spiderman); %一番似ている画像
        %デッドプールの画像と学習画像の距離
        dis_deadpool = (rep_deadpool-train_man).^2;
        dis_deadpool = sqrt(sum(dis_deadpool')); %列(転置して)ごとの和
        [sim, sim_deadpool] = min(dis_deadpool); %一番似ている画像
        
        % 似ている画像がスパイダーマンの画像と正しく判断
        if sim_spiderman <= num_train/2
            Cat_man(j) = Cat_man(j) + 1;
        else
            Miss_spiderman = [Miss_spiderman, Idx_eval(i)]; %分類に間違えた画像のlistの添え字を返す
        end
        % 似ている画像がデッドプールの画像と正しく判断
        if sim_deadpool > num_train/2
            Cat_man(j) = Cat_man(j) + 1;
        else
            Miss_deadpool = [Miss_deadpool, Idx_eval(i)+num_man/2];
        end
    end
    Cat_man(j) = Cat_man(j)/num_eval;
end

%分類率を表示
disp('たい焼き、どら焼きの分類率');
disp(sum(Cat_yaki,1)/cv);
disp('スパイダーマン、デッドプールのの分類率');
disp(sum(Cat_man,1)/cv);

%分類に間違えた数を返す
disp('たい焼きの分類間違い');
disp(size(Miss_taiyaki,2));
disp('どら焼きの分類間違い');
disp(size(Miss_dorayaki,2));
disp('スパイダーマンの分類間違い');
disp(size(Miss_spiderman,2));
disp('デッドプールの分類間違い');
disp(size(Miss_deadpool,2));