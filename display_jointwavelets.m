function display_jointwavelets(archs)
% Initialisation avec du silence
N = archs{1}.banks{1}.spec.size;
signal = zeros(N,1);

% Initialisation de la structure de scattering
nLayers = length(archs);
S = cell(1,1+nLayers);
U = cell(1,1+nLayers);
Y = cell(1,1+nLayers);

U{1+0} = initialize_variables_auto(size(target_signal));
U{1+0}.data = signal;

% on calcule le scalogramme U1
Y{1} = U_to_Y(U{1+0}, archs{1});

end