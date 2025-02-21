list_spiderman=textread('url_spiderman.txt', '%s');

OUTDIR='img'
for i=1:size(list_spiderman,1)
  fname=strcat(OUTDIR,'/spiderman/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_spiderman{i});
end