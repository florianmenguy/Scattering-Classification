function samples = rwc_summarize(samples)
nSamples = length(samples);
disp('Summarization');
for sample_index = 1:nSamples
    sample = samples(sample_index);
    samples(sample_index).data = [mean(sample.data,2); std(sample.data,2)];
    if mod(sample_index,100)==0
        disp(['Finished sample ', num2str(sample_index,'%1.4d'), ...
            ' / ', num2str(nSamples)]);
    end
end
end