list_dorayaki=textread('url_dorayaki.txt', '%s');


OUTDIR='img'
for i=1:size(list_dorayaki,1)
  fname=strcat(OUTDIR,'/dorayaki/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_dorayaki{i});
end
