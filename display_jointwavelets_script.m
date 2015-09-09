T = 2048; % QuantitÃ© d'invariance 46ms 
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = T;
opts{1}.time.max_scale = 4096; % environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;

% Non-linéarité
opts{1}.nonlinearity.name = 'modulus';

% Second ordre
opts{2}.time = struct();
transpinv_octaves = 4; % transposition invariance in octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);
opts{2}.gamma.T = transpinv_chromas;
opts{2}.gamma.U_log2_oversampling = Inf;

archs = sc_setup(opts);
%% Display wavelets
j2 = 5;
beta = 5;

figure(1);
Y2_wavelets = jointwavelets(archs);
wavelet_strf = real(Y2_wavelets{end}{1}.data{j2}{beta});
scaling = 64/max(strf(:));
wavelet_strf_asc = scaling * strf(:,:,1).';
wavelet_strf_desc = scaling * strf(:,:,2).';

subplot(211);
imagesc(wavelet_strf_asc);
subplot(212);
imagesc(wavelet_strf_desc);
colormap rev_hot;

%% Scatter cello
full_cello_signal = audioread('Vc-scale-chr-asc.wav');
cello_signal = full_cello_signal(1:65536);