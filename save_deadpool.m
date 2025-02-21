list_deadpool=textread('url_deadpool.txt', '%s');

OUTDIR='img'
for i=1:size(list_deadpool,1)
  fname=strcat(OUTDIR,'/deadpool/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_deadpool{i});
end