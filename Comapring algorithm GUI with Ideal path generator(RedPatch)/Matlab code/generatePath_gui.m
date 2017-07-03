%% Load Background Image
bgImage = imread('Background Image/bgImage.jpg');
figure(2), imshow(bgImage,'InitialMagnification','fit');
% set (gcf, 'WindowButtonMotionFcn', @mouseMove);
%% Create drawing environment
h = imfreehand(gca);
setClosed(h,0);
setColor(h,'r');
% mycb1 = @() timeFunc();
% id = addNewPositionCallback(h,mycb1);
pos = getPosition(h);

%% Create GUI
cell_list = {};
fig_number = 1;
title_figure = 'Generate Path';
cell_list{1,1} = {'Redraw Path','redrawPath;'};
cell_list{2,1} = {'Show Points','displaySamplePoints;'};
cell_list{3,1} = {'Save','savePath;'};
% cell_list{4,1} = {'Exit',['disp(''Bye. To run again, type calib_gui.''); close(' num2str(fig_number) ');']};
cell_list{4,1} = {'Back','close(2);SIMULATION_GUI'};

%% Show
show_window(cell_list,fig_number,title_figure,250,20,0,'clean',12);
