function instrument_features = rwc_scatter( opts,datapath )
%Fonction réalisant l'extraction des coefficients de scattering au sein
%d'un tableau de cellule (instrument_features).Après standardisation des
%données. Les lignes du tableau correspondent aux classes des
%instruments(ligne1: Ba ligne2: Bo ....).



%Création architecture
archs = sc_setup(opts);
display_bank(archs{1}.banks{1});
%display_bank(archs{2}.banks{1});

% Chargement du signal
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
        S_matrix{z} =(S1_matrix);% S2_matrix];
    
        %imagesc(S_matrix{z}); % en vertical pas de signification particulière
        S_matrixMean=mean(S_matrix{z},2);
        S_matrixVar=var(S_matrix{z},[],2);
        S_matrixCenter=bsxfun(@minus,S_matrix{z},S_matrixMean);
        S_matrixStd=bsxfun(@rdivide,S_matrixCenter,S_matrixVar);
       instrument_features{i,z}=S_matrixStd;
    end
end



