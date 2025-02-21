list_takoyaki_50=textread('url_takoyaki_50.txt', '%s');
list_takoyaki_interesting=textread('url_takoyaki_interesting.txt', '%s');

OUTDIR='img'
for i=1:size(list_takoyaki_50,1)
  fname=strcat(OUTDIR,'/takoyaki_50/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_takoyaki_50{i});
end

for i=1:size(list_takoyaki_interesting,1)
  fname=strcat(OUTDIR,'/takoyaki_interesting/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_takoyaki_interesting{i});
end