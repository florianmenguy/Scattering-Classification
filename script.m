clear all;
close all;
clc;
rng(0)

% Bank setup
fs=44100;
% Valeurs
T=2048; % Quantité d'invariance 46ms 
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = 2048;
opts{1}.time.max_scale = 4096;%Environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;

% max_firstorder_context = 32; % in ms
% firstorder_scales = [archs{1}.banks{1}.metas.scale] / fs * 1000;
% [~, max_gamma] = find(firstorder_scales>max_firstorder_context,1);
% opts{1}.time.gamma_bounds = [1 max_gamma];


% Non-linéarité entre les deux ordres
opts{1}.nonlinearity.name = 'modulus'; % par défaut
opts{1}.nonlinearity.name = 'uniform_log';
opts{1}.nonlinearity.denominator = 1e-2;

%

opts{2}.time = struct();
transpinv_octaves = 0.5; % transposition invariance in octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);

opts{2}.gamma.is_U_blurred = false;
opts{2}.gamma.T = transpinv_chromas;

% % Création architecture
archs = sc_setup(opts);
% % display_bank(archs{1}.banks{1});
% % display_bank(archs{2}.banks{1});

datapath='~/Documents/MATLAB/Stage/rwc/';
 instrument_features = rwc_scatter( datapath,opts);

[predicted_label, true_labels,dureeTotal,testLabelTot,accuracy] = rwc_classify(instrument_features);
[mean_accuracy, confusion_matrix ,matrixDeci] = rwc_evaluate(predicted_label,dureeTotal,testLabelTot);
