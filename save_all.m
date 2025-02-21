list_taiyaki=textread('url_taiyaki.txt', '%s');
list_spiderman=textread('url_spiderman.txt', '%s');
list_deadpool=textread('url_deadpool.txt', '%s');
list_dorayaki=textread('url_dorayaki.txt', '%s');


OUTDIR='img'
for i=1:size(list_dorayaki,1)
  fname=strcat(OUTDIR,'/dorayaki/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_dorayaki{i});
end

for i=1:size(list_taiyaki,1)
  fname=strcat(OUTDIR,'/taiyaki/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_taiyaki{i});
end

for i=1:size(list_spiderman,1)
  fname=strcat(OUTDIR,'/spiderman/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_spiderman{i});
end

for i=1:size(list_deadpool,1)
  fname=strcat(OUTDIR,'/deadpool/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_deadpool{i});
end