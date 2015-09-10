function samples = rwc_log(samples, epsilon)
nSamples = length(samples);
for sample_index = 1:nSamples
    sample = samples(sample_index);
    samples(sample_index).data = log1p(epsilon*max(sample.data,0))
end
end