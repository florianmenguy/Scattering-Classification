 clear all;
 close all;
 clc;
rng(0)

% Bank setup
fs=44100;
% Valeurs
T=16384; % Quantité d'invariance 185ms
N = 4*T;% Chunk de taille 740ms

% Ordre 1 en temps
opts{1}.time.T = 16384;
opts{1}.time.max_scale = 4096;%Environ 93 ms
opts{1}.time.max_Q=8;
opts{1}.time.size=N;
% 
% max_firstorder_context = 32; % in ms
% firstorder_scales = [archs{1}.banks{1}.metas.scale] / fs * 1000;
% [~, max_gamma] = find(firstorder_scales>max_firstorder_context,1);
% opts{1}.time.gamma_bounds = [1 max_gamma];
% % 
% 
% % Non-linéarité entre les deux ordres
% % opts{1}.nonlinearity.name = 'modulus'; % par défaut
% opts{1}.nonlinearity.name = 'uniform_log';
% opts{1}.nonlinearity.denominator = 1e-2;

% Ordre 2 en temps
% opts{2}.time.max_Q=1;
% opts{2}.time.bank_metas=@morlet_1d;

%Création architecture
archs = sc_setup(opts);
display_bank(archs{1}.banks{1});
%display_bank(archs{2}.banks{1});

% Chargement du signal
datapath='~/Documents/MATLAB/Stage/rwc/';
instrument={'Ba' 'Bo'  'Cl' 'Co' 'Fh' 'Fl' 'Ob' 'Pn' 'Sa' 'Ta' 'Tb' 'Tr' 'Va' 'Vl'};
for i=1:length(instrument)
    files = dir([datapath instrument{i} '/*WAV']);
    nomFichier = [instrument{1,i}];
    S_matrixTotaleTrain=[];
    S_matrixTotaleTest=[];
    finalvote=[];
    S_matrix=cell(1,length(files));%Crétion tableau de cellule
    for z=1:length(files)
        eval(['number_files' nomFichier '=ones(1,length(files))*i;']);
        %% Audioread
        
        filename=[datapath instrument{i} '/' files(z,1).name];
        [y,fs]=audioread(filename);
        time=length(y)/fs;
        
        if time > 3 %On coupe les sons supérieurs à 3s
            y=y(1:3*fs);
        end
        
        % Normalisation du signal
        ymean=y-mean(y);
        maxabs=max(abs(ymean));
        y=ymean/maxabs;
        %
        
        %% Recuperation de S U et Y
        %archs{1}.nonlinearity.denominator = 1e-2;
        [S,U,Y] = sc_propagate(y,archs);
        % Formatage à la main
        S1_matrix = S{1+1}.data.';
        %S2_matrix = [S{1+2}.data{:}].';
        S_matrix{z} =log(S1_matrix);% S2_matrix];
        %imagesc(S_matrix{z}); % en vertical pas de signification particulière
    end
    
    %Création partition test et entrainement
    labels=i;
    groups = (ceil(ones(z,1)))*labels;
    [train,test] = crossvalind('HoldOut',groups, 0.5);
    temp=S_matrix;
    trainSamples=temp(train);
    eval(['trainLabel' nomFichier '=groups(train,1);']);%Création des labels d'entrainement
    testSamples=temp(test);
    eval(['testLabel' nomFichier '=groups(test,1);']);%Création des données de test
    
    
    for i=1:length(testSamples)
        [~,n]=size(testSamples{i});
        finalvote=[finalvote , n];
        S_matrixTotaleTest=[S_matrixTotaleTest , testSamples{i} ];
    end
    eval(['finalvote' nomFichier '=[finalvote];']);
    
    for i=1:length(trainSamples)
        S_matrixTotaleTrain=[S_matrixTotaleTrain , trainSamples{i} ];
    end
    
    %Standardisation des valeurs
    S_matrixMeanTest=mean(S_matrixTotaleTest,2);
    S_matrixMeanTrain=mean(S_matrixTotaleTrain,2);
    S_matrixVarTest=var(S_matrixTotaleTest,[],2);
    S_matrixVarTrain=var(S_matrixTotaleTrain,[],2);
    S_matrixCenterTest=bsxfun(@minus,S_matrixTotaleTest,S_matrixMeanTest);
    S_matrixCenterTrain=bsxfun(@minus,S_matrixTotaleTrain,S_matrixMeanTrain);
    S_matrixStdTest=bsxfun(@rdivide,S_matrixCenterTest,S_matrixVarTest);
    S_matrixStdTrain=bsxfun(@rdivide,S_matrixCenterTrain,S_matrixVarTrain);
    eval(['S_matrixStdTrain' nomFichier '=S_matrixStdTrain;']);
    eval(['S_matrixStdTest' nomFichier '=S_matrixStdTest;']);
    
end
