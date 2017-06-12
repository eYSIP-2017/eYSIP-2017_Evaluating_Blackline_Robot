% addpath('mmread');

KW_pathName = 'Input Videos';
KW_ListFiles = ls(strcat(KW_pathName,'/'));

for KW_i=3:size(KW_ListFiles,1)
    % Get Video Filename
    KW_VideoFileName = KW_ListFiles(KW_i,:);    
    KW_VideoFile = strcat(KW_pathName, '/', KW_VideoFileName);
    
    disp(strcat('Processing...',KW_VideoFileName));
    
    % Read Video
    [KW_inputMovie, KW_height, KW_width, KW_frameRate, KW_numOfFrame] = readVideo(KW_VideoFile);
    
    % Grab a frame
    KW_randomFrame = KW_inputMovie.frames(ceil(KW_numOfFrame/3)).cdata;
    
    % Get Image Filename
    [KW_Pathstr ,KW_Name ,KW_Ext] = fileparts(KW_VideoFile);
    KW_ImageFile = strrep(strrep(KW_VideoFileName,'Video','Image'),KW_Ext,'.jpg');
    
    % Save frame
    imwrite(KW_randomFrame,KW_ImageFile,'jpg');
    
    disp(strcat('Generated...',KW_ImageFile));
    clearvars KW_inputMovie;
end