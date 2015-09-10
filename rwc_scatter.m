function batch = rwc_scatter(archs, datapath, batch)

nFiles = length(batch);
batch_id = batch(1).batch_id;

% Measure elapsed time with tic() and toc()
tic();
disp(['Number of files in batch ', num2str(batch_id), ' : ', num2str(nFiles)]);
parfor file_index = 1:nFiles
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
    
    current_task = getCurrentTask();
    worker_id = current_task.ID;
    disp(['Finished file ', num2str(file_index,'%1.3d'), ' on worker ', ...
        num2str(worker_id,'%1.2d')]);
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
savefile_name = ['jointrwc_', num2str(batch_id,'%1.2d')];
if ~exist('features','dir')
    mkdir('features');
end
savefile_path = ['features/', savefile_name];
save(savefile_path, 'batch', 'setting', 'host', 'elapsed', 'date');

% Print termination message
disp('--------------------------------------------------------------------------------');
disp(['Finished batch ', batch_id_str, ' on host ', host, ...
    ' at ', date]);
disp(['Elapsed time is ', elapsed_str ' seconds.']);
end


