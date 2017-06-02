addpath('mmread');

%% Read Input Video
[KW_fileName, KW_pathName] = uigetfile('*.*','Select an Input Video'); 
if (KW_fileName == 0)
    return ;
end

% [~,outFolder,~] = fileparts(fileName);

KW_file = strcat(KW_pathName, KW_fileName);
[KW_inputMovie, KW_height, KW_width, KW_frameRate, KW_numOfFrame] = readVideo(KW_file);
KW_outputMovie = KW_inputMovie;

KW_firstFrame = KW_inputMovie.frames(1).cdata;
imwrite(KW_firstFrame,'../../calib_example/firstFrame.jpg');

% Calculate Extrinsic parameters using First Frame 
extrinsic_computation;

for KW_i=1:KW_numOfFrame
    KW_frame = KW_inputMovie.frames(KW_i).cdata;
    [KW_bb, ~] = detectBotRedPatch(KW_frame);
    
end

