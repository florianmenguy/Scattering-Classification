function [strf_asc,strf_asc] = display_joint(j2, beta)
scaling = 64/max(S{1+2}{1}.data{j2}{beta}(:));
strf_asc = scaling * S{1+2}{1}.data{j2}{beta}(:,:,1).';
strf_desc = scaling * S{1+2}{1}.data{j2}{beta}(:,:,2).';

subplot(211);
image(strf_asc);
subplot(212);
image(strf_desc);
colormap rev_hot;
end