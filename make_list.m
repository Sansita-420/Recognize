n=0; list={};
LIST={'taiyaki' 'dorayaki' 'spiderman' 'deadpool'};
DIR0='img/';

size_list=zeros(length(LIST),1);
% 125, 125, 150, 150

for i=1:length(LIST)
    DIR=strcat(DIR0,LIST(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR{:},W(j).name);
	        n=n+1;
            fprintf('[%d] %s\n',n,fn);
	        list={list{:} fn};
            size_list(i)=size_list(i)+1;
        end
    end
end