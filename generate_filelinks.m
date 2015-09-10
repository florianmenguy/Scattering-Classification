function generate_filelinks()
nFiles = 45;
for file_index = 1:nFiles
    nbstr = num2str(file_index, '%1.2d');
    filestring = ['<a href="jointrwc_',nbstr, '.mat" >', nbstr, '</a>'];
    disp(filestring);
end
end