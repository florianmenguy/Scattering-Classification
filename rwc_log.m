function samples = rwc_log(samples, epsilon)
nSamples = length(samples);
disp('Logarithmic compression');
for sample_index = 1:nSamples
    sample = samples(sample_index);
    samples(sample_index).data = log1p(max(sample.data,0)/epsilon);
    if mod(sample_index,100)==0
        disp(['Finished sample ', num2str(sample_index,'%1.4d'), ...
            ' / ', num2str(nSamples)]);
    end
end
end