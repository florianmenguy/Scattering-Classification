function rwc_filelinks()
fileID = fopen('filelinks.html','w');

for n = 1:45
    fprintf(fileID, '<a href="jointrwc_%1.2d.mat">%1.2d</a>\n', n, n);
end

fclose(fileID);
end
