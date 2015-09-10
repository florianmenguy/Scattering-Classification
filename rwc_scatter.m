function instrument_features = rwc_scatter(archs, batch, datapath)
% Fonction realisant l'extraction des coefficients de scattering au sein
% d'un tableau de cellules (instrument_features). Les coefficients sont
% "standardisés" (moyenne 0, variance 1) sur toute la base RWC.
% instrument_features{i}{z} est une matrice temps-features contenant la
% transformée de scattering du fichier z pour l'instrument i.

nFiles = length(batch);

% Measure elapsed time with tic() and toc()
tic();
for file_index = 1:nFiles
    meta = batch(file_index);
    % Chargement du signal
    filename = [datapath '/' meta.subfolder '/' meta.wavfile_name];
    [y,fs] = audioread_compat(filename);
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
    batch(file_index).data = sc_format(S);
end

elapsed = toc();
elapsed_str = num2str(elapsed,'%2.0f');

% Get host name
pcinfo = java.net.InetAddress.getLocalHost();
host = pcinfo.getHostName(); % class is java.lang.String
host = char(host); % convert to MATLAB char array

% Get date
date = datestr(now());

% Save
savefile_name = [setting2prefix(setting), num2str(batch_id,'%1.2d')];
if ~exist('features','dir')
    mkdir('features');
end
savefile_path = ['features/', savefile_name];
save(savefile_path, 'batch', 'setting', 'host', 'elapsed', 'date');

% Print termination message
disp('--------------------------------------------------------------------------------');
disp(['Finished batch ', batch_id_str, ' on host ', host, ...
    ' at ', date,' with settings:']);
disp(setting);
disp(['Elapsed time is ', elapsed_str ' seconds.']);
end


