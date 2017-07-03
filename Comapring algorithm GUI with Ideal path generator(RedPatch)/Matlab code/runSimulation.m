%% Load Input Path file
[fileName, path] = uigetfile('*.*','Select an Input Path File'); 
if (fileName == 0)
    return ;
end

% load path    
file = strcat(path, '/', fileName);
load(file);


%% Load Background Image
bgImage = imread('Background Image/bgImage.jpg');


%% 3D Coordinate to Pixel Conversion
% pos contains 3D coordinate in cm
arenaXsize = 174;   % Size of Arena along X axis
arenaYsize = 174;   % Size of Arena along Y axis
originXshift = 12;  % Origin is shifted by 12cm along X axis on Arena
originYshift = 12;  % Origin is shifted by 12cm along Y axis on Arena

% Compensate for Origin Shift 
pos(:,1) = pos(:,1) + 12;
pos(:,2) = pos(:,2) + 12;
% Invert Y axis (Matlab Y axis is top to bottom)
pos(:,2) = 174 - pos(:,2);

% cm to pixel conversion
pos(:,1) = pos(:,1)*(size(bgImage,2)/arenaXsize);
pos(:,2) = pos(:,2)*(size(bgImage,1)/arenaYsize);


%% Run animation
runAnimation(pos,bgImage);