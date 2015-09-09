% TODO définir architecture jointe ici

%%
U2 = jointwavelets(archs);

%%
j2 = 7;
beta = 1;
scaling = 64/max(U2{1}.data{j2}{beta}(:));
strf_asc = scaling * U2{1}.data{j2}{beta}(:,:,1).';
strf_desc = scaling * U2{1}.data{j2}{beta}(:,:,2).';

subplot(211);
image(strf_asc);
subplot(212);
image(strf_desc);
colormap rev_hot;