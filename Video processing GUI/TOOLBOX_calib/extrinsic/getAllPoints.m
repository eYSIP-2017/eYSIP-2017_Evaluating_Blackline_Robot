% I  = imread('imageFive5.jpg');
% 
% cd('data');
% files = dir;
% for i=3:size(files,1)
% % for i=4:4
% fileName = files(i).name;
% I = imread(fileName);
% 
% [BotCentroid, ConvexImage, ExtremaBoxBot, boundingBoxBot, stats, redBI] = detectBotRedPatch(I);
% 
% 
% 
% 
% redBI = imdilate(redBI,strel('disk',2));
% % redBI = bwmorph(redBI,'close');
% % figure(), imshow(redBI);
% points = findFourCorners(redBI);
% % points = round(ExtremaBoxBot);
% % stats = regionprops(redBI, 'BoundingBox', 'Centroid', 'Area', 'Extrema', 'ConvexImage');
% % ExtremaBoxBot = stats(1).Extrema;
% % 
% % leftEdge = [ExtremaBoxBot(8,:);ExtremaBoxBot(7,:)];
% % bottomEdge = [ExtremaBoxBot(6,:);ExtremaBoxBot(5,:)];
% % rightEdge = [ExtremaBoxBot(4,:);ExtremaBoxBot(3,:)];
% % topEdge = [ExtremaBoxBot(2,:);ExtremaBoxBot(1,:)];
% 
% figure(),imshow(redBI)
% % figure(),imshow(I)
% hold on
% %     plot(leftEdge(:,1), leftEdge(:,2), 'b-o' ,'LineWidth',2)
% %     plot(bottomEdge(:,1), bottomEdge(:,2), 'c-o','LineWidth',2)
% %     plot(rightEdge(:,1), rightEdge(:,2), 'g-o','LineWidth',2)
% %     plot(topEdge(:,1), topEdge(:,2), 'r-o','LineWidth',2)
%     plot(points(:,2), points(:,1),'b+')
% hold off
% end
% cd('..');

%%
function [greenPatchCentroid, blackPatchCentroid, BotCentroid, boundingBoxBot, cornerPoints] = getAllPoints(I)

cornerPoints = [];

[BotCentroid, ConvexImage, ExtremaBoxBot, boundingBoxBot, stats, redBI] = detectBotRedPatch(I);
 
% redBI = imdilate(redBI,strel('disk',2));

boundingBoxBot = round(boundingBoxBot);
width = boundingBoxBot(3);
height = boundingBoxBot(4);
patch = I(boundingBoxBot(2):boundingBoxBot(2)+height-1,boundingBoxBot(1):boundingBoxBot(1)+width-1,:);

patchRedBI = uint8(repmat(redBI,1,1,3)).*patch;
invRedBI = uint8(~redBI);
invRedBI(invRedBI == 1) = 255;
invPatchRedBI = uint8(repmat(invRedBI,1,1,3))+patchRedBI;

% figure(), imshow(patch);
% figure(),imshow(redBI);
% figure(),imshow(patchRedBI);
% figure(),imshow(invPatchRedBI);

%% Find cetroid of green patch
[greenPatchCentroid, ~, ~, ~, ~] = detectBotGreenPatch(patchRedBI);
greenPatchC = [greenPatchCentroid(2),greenPatchCentroid(1)]; 
greenPatchCentroid(1) = boundingBoxBot(1)+greenPatchCentroid(1)-1;
greenPatchCentroid(2) = boundingBoxBot(2)+greenPatchCentroid(2)-1;
greenPatchCentroid = round(greenPatchCentroid);

%% Find centroid of black patch
[blackPatchCentroid, ~, ~, ~, ~] = detectBotBlackPatch(invPatchRedBI);
blackPatchC = [blackPatchCentroid(2),blackPatchCentroid(1)]; 
blackPatchCentroid(1) = boundingBoxBot(1)+blackPatchCentroid(1)-1;
blackPatchCentroid(2) = boundingBoxBot(2)+blackPatchCentroid(2)-1;
blackPatchCentroid = round(blackPatchCentroid);

% %% Find four corner points of red patch
% points = findFourCorners(redBI);
% points(:,2) = boundingBoxBot(1)+points(:,2)-1;
% points(:,1) = boundingBoxBot(2)+points(:,1)-1;

% figure(),imshow(I)
% hold on
%     plot(points(:,2), points(:,1),'b+')
%     plot(BotCentroid(1),BotCentroid(2),'g*');
%     plot(greenPatchCentroid(1),greenPatchCentroid(2),'r*')
%     plot(blackPatchCentroid(1),blackPatchCentroid(2),'c*')
% hold off

% cornerPoints = [];
% distFromBlack = sqrt((points(:,2)-blackPatchCentroid(1)).^2 + (points(:,1)-blackPatchCentroid(2)).^2);
% [~,index] = min(distFromBlack);
% cornerPoints(1,:) = points(index,:);
% points(index,:) = [];
% 
% distFromGreen = sqrt((points(:,2)-greenPatchCentroid(1)).^2 + (points(:,1)-greenPatchCentroid(2)).^2);
% [~,index] = min(distFromGreen);
% cornerPoints(2,:) = points(index,:);
% points(index,:) = [];
% 
% cornerPoints = [cornerPoints;points];
end