list_taiyaki=textread('url_taiyaki.txt', '%s');

OUTDIR='img'
for i=1:size(list_taiyaki,1)
  fname=strcat(OUTDIR,'/taiyaki/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_taiyaki{i});
end