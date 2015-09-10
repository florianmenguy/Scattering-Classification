function generate_filelinks()
fileID = fopen('filelinks.html','w');
fprintf(fileID, '<a href="jointrwc_%1.2d.mat">%1.2d</a>\n', 1:45, 1:45)
fclose(fileID);
end