% addpath('mmread');

%% Read Input Video
[KW_VideoFileName, KW_pathName] = uigetfile('*.*','Select an Input Video'); 
if (KW_VideoFileName == 0)
    return ;
end

% Get Video Filename    
KW_VideoFile = strcat(KW_pathName, '/', KW_VideoFileName);

disp(strcat('Processing...',KW_VideoFileName));
    
% Read Video
if(exist('KW_inputMovie'))
    clearvars KW_inputMovie;
end
[KW_inputMovie, KW_height, KW_width, KW_frameRate, KW_numOfFrame] = readVideo(KW_VideoFile);

% Grab a frame
KW_randomFrame = KW_inputMovie.frames(ceil(KW_numOfFrame/3)).cdata;

% Get Image Filename
[KW_Pathstr ,KW_Name ,KW_Ext] = fileparts(KW_VideoFile);
KW_ImageFile = 'firstFrame.jpg';

% Save frame
imwrite(KW_randomFrame,KW_ImageFile);
disp('Frame Saved ... ');

%% Calculate Extrinsic parameters using First Frame 
extrinsic_computation;

%
KW_Points3D = zeros(KW_numOfFrame,4);
KW_Time = 0;
KW_Interval = KW_numOfFrame/(KW_frameRate*(KW_numOfFrame-1));
for KW_i=1:KW_numOfFrame
% for KW_i=1:2    
    KW_Mesg = strcat('Processing Frame ... ', num2str(KW_i));
    disp(KW_Mesg);
    
    KW_frame = KW_inputMovie.frames(KW_i).cdata;
%     [KW_Centroid, KW_ConvexImage, KW_BotExtrema, KW_BotBB, KW_Stats] = detectBotRedPatch(KW_frame);
    [kGreenPatchCentroid, kBlackPatchCentroid, kBotCentroid, kBoundingBoxBot, kPoints] = getAllPoints(KW_frame);
    
    if(~exist('KW_ExCompOrigin'))
        disp('Origin Not set');
        return;
    end
    
    if(mod(KW_i,100)==0)
%     if(KW_i==352||KW_i==355)
        figure(),imshow(KW_frame)
        hold on
        rectangle('Position',kBoundingBoxBot,'EdgeColor','r','LineWidth',2)
%         plot(KW_Points2D(:,1),KW_Points2D(:,2), '+');
        plot(kBotCentroid(1),kBotCentroid(2), '+');
        plot(KW_ExCompOrigin(1),KW_ExCompOrigin(2), '+');
        hold off
    end
    
    KW_Points3D(KW_i,1:2) = myCalculate3DCoor(KW_ExCompOrigin,kBotCentroid,cc,fc,Rc_ext,Tc_ext);
    KW_GPoint3D = myCalculate3DCoor(KW_ExCompOrigin,kGreenPatchCentroid,cc,fc,Rc_ext,Tc_ext);
    KW_BPoint3D = myCalculate3DCoor(KW_ExCompOrigin,kBlackPatchCentroid,cc,fc,Rc_ext,Tc_ext);
    KW_Points3D(KW_i,3) = myFindAngle(KW_BPoint3D,KW_GPoint3D);
    KW_Points3D(KW_i,4) = KW_Time;
    KW_Time = KW_Time + KW_Interval;
end

%% Save 3D Coordinates
save3DCoorVar(KW_Points3D,KW_VideoFileName);




