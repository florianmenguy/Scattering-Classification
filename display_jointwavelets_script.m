T = 2048; % QuantitÃ© d'invariance 46ms 
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = T;
opts{1}.time.max_scale = 4096; % environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;

max_firstorder_context = 32; % in ms
firstorder_scales = [archs{1}.banks{1}.metas.scale] / fs * 1000;
[~, max_gamma] = find(firstorder_scales>max_firstorder_context,1);
opts{1}.time.gamma_bounds = [1 max_gamma];

% Non-linéarité
opts{1}.nonlinearity.name = 'modulus';

% Second ordre
opts{2}.time = struct();
transpinv_octaves = 0.5; % transposition invariance in octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);
opts{2}.gamma.T = 32;
opts{2}.gamma.U_log2_oversampling = Inf;

archs = sc_setup(opts);
%%
Y2 = jointwavelets(archs);

%%
j2 = 5;
beta = 2;
strf = real(Y2{end}{1}.data{j2}{beta});
scaling = 64/max(strf(:));
strf_asc = scaling * strf(:,:,1).';
strf_desc = scaling * strf(:,:,2).';

subplot(211);
imagesc(strf_asc);
subplot(212);
imagesc(strf_desc);
colormap rev_hot;