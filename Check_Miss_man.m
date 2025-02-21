disp("スパイダーマン: alex");
disp(Miss_alex(find(Miss_alex <= num_yaki+num_man/2)));
disp("デッドプール: alex");
disp(Miss_alex(find(Miss_alex > num_yaki+num_man/2)));
disp("スパイダーマン: vgg");
disp(Miss_vgg(find(Miss_vgg <= num_yaki+num_man/2)));
disp("デッドプール: vgg");
disp(Miss_vgg(find(Miss_vgg > num_yaki+num_man/2)));
disp("スパイダーマン: dense");
disp(Miss_dense(find(Miss_dense <= num_yaki+num_man/2)));
disp("デッドプール: dense");
disp(Miss_dense(find(Miss_dense > num_yaki+num_man/2)));

alex_vgg=[];
for i=1:numel(Miss_alex)
    alex_vgg = [alex_vgg, Miss_vgg(find(Miss_alex(i) == Miss_vgg(:)))];
end
disp("alex, vgg");
disp(alex_vgg);

alex_dense=[];
for i=1:numel(Miss_alex)
    alex_dense = [alex_dense, Miss_dense(find(Miss_alex(i) == Miss_dense(:)))];
end
disp("alex, dense");
disp(alex_dense);

vgg_dense=[];
for i=1:numel(Miss_vgg)
    vgg_dense = [vgg_dense, Miss_dense(find(Miss_vgg(i) == Miss_dense(:)))];
end
disp("vgg, dense");
disp(vgg_dense);