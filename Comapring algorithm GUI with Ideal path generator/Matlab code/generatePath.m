%% Load Background Image

% bgImage = imread('Background Image/bgImage.jpg');
% figure(), imshow(bgImage);


figure(), imshow('pout.tif');
h = imfreehand(gca);
setClosed(h,0);
setColor(h,'r');
pos = getPosition(h);

% fcn = makeConstrainToRectFcn('imfreehand',get(h,'XLim'),get(h,'YLim'));
fcn = makeConstrainToRectFcn('imfreehand',[52 0],[42 0]);
setPositionConstraintFcn(h,fcn);

% hold on;
% plot(pos(:,1), pos(:,2), '*');
