物体認識論の最終課題に用いたMファイルとtxtファイルである。

url_*.txt は、実験に用いた画像のURLが記載されている。
url*.txt を用いて、save_*.m でその画像をローカルに保存した。

課題1(taiyaki, dorayaki  | spiderman, deadpool)
   
    make_list.m :画像パスのリストを作成

        カラーヒストグラムと最近傍分類
            make_db.m           :カラーヒストグラムのdatabase作成
            categorize_db.m:    :カラーヒストグラムで最近傍分類

        BoFベクトルと非線形SVMモデル
            createRandomPoints.m    :ランダムサンプリングの関数
            make_codebook.m         :codebook の作成
            BoF.m                   :BoFベクトルの作成
            SVM_BoF.m               :BoFベクトルから非線形SVMモデルで分類

        DCNN特徴量と線形SVM
            Featur_DCNN_layer.m     :DCNN特徴量の作成する関数
            Categorize_DCNN.m       :3種のネットワークで画像分類
            DCNN_net_yaki.m         :たい焼き、どら焼きの画像分類
            DCNN_net_man.m          :スパイダーマン、デッドプールの画像分類
            Check_Miss_yaki.m       :たい焼き、どら焼きで分類を間違えた画像のlistの添え字
            Check_Miss_man.m        :スパイダーマン、デッドプールで分類を間違えた画像のlistの添え字


課題2(R2D2  | takoyaki)

    make_list2.m            :画像パスのリストを作成
    Feature_DCNN_layer.m    :DCNN特徴量の作成する関数(課題1でも使用)
    Reranking_DCNN.m        :SVMスコアの大きい順にソートする関数

    R2D2
        DCNN_R2D2.m                 :R2D2の画像をリランキング
        Img_Ranking_R2D2.m          :リランキングした結果を確認
    
    takoyaki
        DCNN_takoyaki.m             :たこ焼きの画像をリランキング
        Img_Ranking_takoyaki.m      :リランキングした結果を確認