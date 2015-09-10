% Ordre 1 en temps
opts{1}.time.T = 2048;
opts{1}.time.size = 4 * opts{1}.time.T;
opts{1}.time.max_scale = 4096; % Environ 93 ms
opts{1}.time.max_Q=8;

% Non-linearite entre les deux ordres
opts{1}.nonlinearity.name = 'uniform_log';
opts{1}.nonlinearity.denominator = 1e-2;

% Ordre 2 en temps (dimension horizontale)
opts{2}.time.handle = @morlet_1d;

% Ordre 2 en log-fréquence (dimension verticale)
transpinv_octaves = 4 ; % invariance maximale par transposition = 4 octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);
opts{2}.gamma.is_U_blurred = false;
opts{2}.gamma.T = transpinv_chromas;
opts{2}.gamma.gamma_bounds = [3 Inf];

datapath='~/datasets/rwc/';
archs = sc_setup(opts);

%%
metas = parse_rwc(datapath);
%%
nBatches = max([metas.batch_id]);
for batch_id = 1:nBatches
      batch = metas([metas.batch_id]==batch_id);
      rwc_scatter(archs, datapath, batch);
end