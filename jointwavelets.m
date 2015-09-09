function Y2 = jointwavelets(archs)
% Initialisation avec du silence
N = archs{1}.banks{1}.spec.size;
signal = zeros(N,1);

% Initialisation de la structure de scattering
nLayers = length(archs);
S = cell(1,1+nLayers);
U = cell(1,1+nLayers);
Y = cell(1,1+nLayers);

U{1+0} = initialize_variables_auto(size(signal));
U{1+0}.data = signal;

% on calcule le scalogramme U1
Y{1} = U_to_Y(U{1+0}, archs{1});
U{1+1} = Y_to_U(Y{1}{end}, archs{1});

% on met un Dirac dans le scalogramme
U{1+1}.data{round(end/2)}(end/2) = 1;

% scattering joint (ondelette horizontale puis ondelette verticale)
Y2 = U_to_Y(U{1+1}, archs{2});
end