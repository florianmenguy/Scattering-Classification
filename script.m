 clear all;
 close all;
 clc;
 rng(0)

% Bank setup
fs=44100;
% Valeurs
T=8192; % Quantité d'invariance 185ms
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = 16384;
opts{1}.time.max_scale = 4096;%Environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;

%%A mettre dans la fonction rwc_scatter après archs = sc_setup(opts) %%
% max_firstorder_context = 32; % in ms
% firstorder_scales = [archs{1}.banks{1}.metas.scale] / fs * 1000;
% [~, max_gamma] = find(firstorder_scales>max_firstorder_context,1);
% opts{1}.time.gamma_bounds = [1 max_gamma];


% Non-linéarité entre les deux ordres
opts{1}.nonlinearity.name = 'modulus'; % par défaut
opts{1}.nonlinearity.name = 'uniform_log';
opts{1}.nonlinearity.denominator = 1e-2;

datapath='~/Documents/MATLAB/Stage/rwc/';
instrument_features = rwc_scatter( opts,datapath );
[predicted_label, true_labels,dureeTotal,testLabelTot,accuracy] = rwc_classify(instrument_features);
[mean_accuracy, confusion_matrix,matrixDeci] = rwc_evaluate(predicted_label,dureeTotal,testLabelTot);
