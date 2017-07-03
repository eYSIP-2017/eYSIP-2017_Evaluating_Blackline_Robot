%% Save Sampled Points to File
%{
outFolder = 'Saved Paths';
baseFileName = 'Path';

% TO DO : just Remove below two lines in case you dont want to round.
roundPos = pos;
pos = round(roundPos);

listDir = dir(outFolder);
[~,lastFileName,~] = fileparts(listDir(end).name);
suffix = str2num(strrep(lastFileName,baseFileName,''))+1;
fileName = strcat(baseFileName,num2str(suffix));

% Save as Mat file
save(strcat(outFolder, '/', fileName, '.mat'),'pos');

% Save as Text File
fileID = fopen(strcat(outFolder, '/', fileName, '.txt'),'w');
fprintf(fileID,'%d,%d\r\n',pos);
fclose(fileID);
%}
roundPos = pos;
pos = round(roundPos);

dlmwrite('Ideal_test.txt',pos,'\t');