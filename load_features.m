function features = load_features(featurespath)
nBatches = 45;
batch_features = cell(nBatches, 1);
for batch_id = 1:nBatches
    disp(['loading batch #', int2str(batch_id)])
    batch_id_str = num2str(batch_id,'%1.2d');
    file_path = [featurespath, '/jointrwc_', batch_id_str, '.mat'];
    load(file_path, 'batch');
    batch_features{batch_id} = batch;
end
features = [batch_features{:}];
end
