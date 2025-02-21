list_R2D2_50=textread('url_R2-D2_50.txt', '%s');
list_R2D2_interesting=textread('url_R2-D2_interesting.txt', '%s');

OUTDIR='img'
for i=1:size(list_R2D2_50,1)
  fname=strcat(OUTDIR,'/R2-D2_50/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_R2D2_50{i});
end

for i=1:size(list_R2D2_interesting,1)
  fname=strcat(OUTDIR,'/R2-D2_interesting/',num2str(i,'%04d'),'.jpg');
  websave(fname,list_R2D2_interesting{i});
end