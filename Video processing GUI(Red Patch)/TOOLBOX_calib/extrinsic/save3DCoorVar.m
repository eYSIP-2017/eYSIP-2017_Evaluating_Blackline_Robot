function [] = save3DCoorVar(pos,videoFileName)
%% Save Sampled Points to File
outFolder = 'Output';
baseFileName = 'Path';

% TO DO : just Remove below two lines in case you dont want to round.
% roundPos = pos;
% pos = round(roundPos);

% Get Image Filename
[~ ,fileName ,ext] = fileparts(videoFileName);

fileName = strrep(strrep(fileName,'Video','Path'),ext,'');

% Save as Mat file
save(strcat(outFolder, '/', fileName, '.mat'),'pos');

% Save as Text File
fileID = fopen(strcat(outFolder, '/', fileName, '.txt'),'w');
fprintf(fileID,'%f,%f,%f,%f\r\n',pos');
fclose(fileID);
end