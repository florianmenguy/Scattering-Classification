function instrument_features = rwc_scatter( opts,datapath )
% Fonction realisant l'extraction des coefficients de scattering au sein
% d'un tableau de cellules (instrument_features). Les coefficients sont
% "standardisés" (moyenne 0, variance 1) sur toute la base RWC.
% instrument_features{i}{z} est une matrice temps-features contenant la
% transformée de scattering du fichier z pour l'instrument i.

% Creation de l'architecture
archs = sc_setup(opts);

% Liste des instruments
instruments = ...
    {'Ba' 'Bo'  'Cl' 'Co' 'Fh' 'Fl' 'Ob' 'Pn' 'Sa' 'Ta' 'Tb' 'Tr' 'Va' 'Vl'};
nInstruments = length(instruments);
instrument_features = cell(nInstruments,1);
concatenated_features = cell(nInstruments,1);

for i = 1:nInstruments
    % On ne garde que les noms de fichiers se terminant par WAV
    files = dir([datapath instruments{i} '/*WAV']);
    nFiles = length(files);
    instrument_features{i} = cell(nFiles,1);
    
    for z = 1:nFiles
        % Chargement du signal
        filename = [datapath instruments{i} '/' files(z,1).name];
        [y,fs] = audioread(filename);
        time = length(y)/fs;
        if time > 3 % on coupe les sons plus longs que 3 s
            y=y(1:3*fs);
        end
        
        % Normalisation du signal
        ymean = y - mean(y);
        maxabs = max(abs(ymean));
        y = ymean/maxabs;
        
        % Scattering
        S = sc_propagate(y,archs);
        instrument_features{i}{z} = sc_format(S);
    end
    % On concatène ensemble tous les fichiers de chaque instrument
    concatenated_features{i} = [instrument_features{i}{:}];
end

% On concatène tout
full_matrix = [concatenated_features{:}];

% Calcul de la moyenne et de la variance globale de chaque feature
full_mean = mean(full_matrix,2);
full_variance = var(full_matrix,2);

% Standardisation
for i = 1:nInstruments
    nFiles=length(instrument_features{i});
    for z = 1:nFiles
        instrument_features{i}{z} = ...
            bsxfun(@minus,instrument_features{i}{z}, full_mean);
        instrument_features{i}{z} = ...
            bsxfun(@rdivide, instrument_features{i}{z}, full_variance);
    end
end
end


