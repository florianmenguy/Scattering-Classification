clear all;
close all;
clc;
rng(0)

% Bank setup
fs=44100;
% Valeurs
T=2048; % Quantité d'invariance 46 ms
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = 2048;
opts{1}.time.max_scale = 4096;%Environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;


% Non-linéarité entre les deux ordres
opts{1}.nonlinearity.name = 'modulus'; % par défaut
opts{1}.nonlinearity.name = 'uniform_log';
opts{1}.nonlinearity.denominator = 1e-2;

%

opts{2}.time = struct();
transpinv_octaves = 4 ; % transposition invariance in octaves
nChromas = opts{1}.time.max_Q;
transpinv_chromas = round(transpinv_octaves * nChromas);

opts{2}.gamma.is_U_blurred = false;
opts{2}.gamma.T = transpinv_chromas;

 datapath='~/Documents/MATLAB/Stage/rwc/';
 
 instrument_features = rwc_scatter( datapath,opts);
archs = sc_setup(opts);
