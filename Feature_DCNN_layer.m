function dcnnf_feature=Feature_DCNN_layer(net, IM, layer)
    
    dcnnf=activations(net, IM, layer);
    dcnnf=squeeze(dcnnf);
    % L2ノルムで割って，L2正規化．
    % 最終的な dcnnf を画像特徴量として利用します．
    dcnnf = dcnnf/norm(dcnnf);
    dcnnf_feature = dcnnf';
    
end