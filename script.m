
% Ordre 1 en temps
opts{1}.time.T = 2048;
opts{1}.time.size = 4 * opts{1}.time.T;
opts{1}.time.max_scale = 4096; % Environ 93 ms
opts{1}.time.max_Q = 8;

% Non-linearite entre les deux ordres
opts{1}.nonlinearity.name = 'uniform_log';
opts{1}.nonlinearity.denominator = 1e-2;

% Ordre 2 en temps (dimension horizontale)
opts{2}.time.handle = @gammatone_1d;

% Ordre 2 en log-frequence (dimension verticale)
transpinv_octaves = 4 ; % invariance maximale par transposition = 4 octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);
opts{2}.gamma.T = transpinv_chromas;

datapath='~/datasets/rwc/';
archs = sc_setup(opts);

%%
metas = rwc_parse(datapath);

%% This for loop is handled on the server
%nBatches = max([metas.batch_id]);
%for batch_id = 1:nBatches
%      batch = metas([metas.batch_id]==batch_id);
%      rwc_scatter(archs, datapath, batch);
%end

%% Load features
featurespath = '~/Documents/MATLAB/rwc_jointfeatures';
samples = rwc_load(featurespath);

%% Apply logarithmic transformation to the features
samples = rwc_log(samples, 1e-6);

%% Summarize features
samples = rwc_summarize(samples);

%% Transform data into a matrix
feature_matrix = [samples.data];

%% Standardize features to null mean and unit variance
feature_matrix = bsxfun(@minus, feature_matrix, mean(feature_matrix,2));
feature_matrix = bsxfun(@rdivide, feature_matrix, std(feature_matrix,[],2));
%
[temp,feature_matrix,ai,as,temporaire,w,train,test,predicted_label,A1, V, accuracy]= rwc_classif(feature_matrix,samples);
