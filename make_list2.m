n=0; list_R2D2={}; 
LIST_R2D2={'R2-D2_50' 'bgimg' 'R2-D2_interesting'};
DIR0='img/';

size_R2D2=zeros(length(LIST_R2D2),1);
% 50, 1000, 300

%bgimg(ランダム画像): w*.jpg と先頭にwがついてる
for i=1:length(LIST_R2D2)
    DIR=strcat(DIR0,LIST_R2D2(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR{:},W(j).name);
	        n=n+1;
            fprintf('[%d] %s\n',n,fn);
	        list_R2D2={list_R2D2{:} fn};
            size_R2D2(i)=size_R2D2(i)+1;
        end
    end
end

n=0; list_takoyaki={};
LIST_takoyaki={'takoyaki_50' 'bgimg' 'takoyaki_interesting'};

size_takoyaki=zeros(length(LIST_takoyaki),1);
% 50, 1000, 300

for i=1:length(LIST_takoyaki)
    DIR=strcat(DIR0,LIST_takoyaki(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'));
            fn=strcat(DIR{:},W(j).name);
	        n=n+1;
            fprintf('[%d] %s\n',n,fn);
	        list_takoyaki={list_takoyaki{:} fn};
            size_takoyaki(i)=size_takoyaki(i)+1;
        end
    end
end