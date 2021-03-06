T = 16384; 
N = 4*T;

% Ordre 1 en temps
opts{1}.time.T = T;
opts{1}.time.max_scale = 8192;
opts{1}.time.max_Q=8;
opts{1}.time.size=N;

% Non-lin�arit�
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
j2 = 10;
beta = 3;
fraction = 0.25;

Y2_wavelets = jointwavelets(archs, fraction);
wavelet_strf = real(Y2_wavelets{end}{1}.data{j2}{beta});
wavelet_scaling = 64 / max(wavelet_strf(:));
wavelet_strf_asc = wavelet_scaling * wavelet_strf(:,:,1).';
wavelet_strf_desc = wavelet_scaling * wavelet_strf(:,:,2).';

figure(2);
subplot(211);
imagesc(wavelet_strf_asc);
subplot(212);
imagesc(wavelet_strf_desc);
colormap rev_hot;

%% Scatter cello
full_cello_signal = audioread('Vc-scale-chr-asc.wav');
cello_signal = full_cello_signal(1:65536);
[cello_S,cello_U,cello_Y] = sc_propagate(cello_signal,archs);
cello_U = sc_unchunk(cello_U);

%% Display cello
cello_strf = cello_U{1+2}{1}.data{j2}{beta};
cello_scaling = 64 / max(cello_strf(:));
cello_strf_asc = cello_scaling * cello_strf(:,:,1).';
cello_strf_desc = cello_scaling * cello_strf(:,:,2).';

figure(2);
subplot(211);
image(cello_strf_asc);
subplot(212);
image(cello_strf_desc);
colormap rev_hot;
