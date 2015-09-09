% TODO définir architecture jointe ici

opts{2}.gamma.T = 32;
opts{2}.gamma.U_log2_oversampling = Inf;

%%
U2 = jointwavelets(archs);

%%
j2 = 5;
beta = 1;
scaling = 64/max(U2{1}.data{7}{beta}(:));
strf_asc = scaling * U2{1}.data{j2}{beta}(:,:,1).';
strf_desc = scaling * U2{1}.data{j2}{beta}(:,:,2).';

subplot(211);
imagesc(strf_asc);
subplot(212);
imagesc(strf_desc);
colormap rev_hot;