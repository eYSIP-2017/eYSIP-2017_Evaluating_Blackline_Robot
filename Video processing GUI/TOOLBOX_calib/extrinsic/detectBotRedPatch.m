function[BotCentroid, ConvexImage, ExtremaBoxBot, boundingBoxBot, stats, patch] = detectBotRedPatch(data)
    % data = imread('vlcsnap_small.png');

    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,1), rgb2gray(data));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.24);
    
    
%     %% detect green
%     diff_im = imsubtract(data(:,:,2), rgb2gray(data));
%     %Use a median filter to filter out noise
%     diff_im = medfilt2(diff_im, [3 3]);
%     % Convert the resulting grayscale image into a binary image.
%     diff_im = im2bw(diff_im,0.05);
    

    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,500);

    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);

    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid', 'Area', 'Extrema', 'ConvexImage');

%     %     Finding bounding box of red color on bot based on Largest Area.
%     min_area = stats(1).Area;
%     min_obj = 1;
%     for object = 2:length(stats)
%          area=stats(object).Area;
%          if area < min_area
%              min_area=area;
%              min_obj=object;
%          end
%     end
    
%     Finding bounding box of red color on bot based on min y.
    min_y = stats(1).Centroid(1,2);
    min_obj = 1;
    for object = 2:length(stats)
         y=stats(object).Centroid(1,2);
         if y < min_y
             min_y=y;
             min_obj=object;
         end
    end
    boundingBoxBot = stats(min_obj).BoundingBox;
    
    ExtremaBoxBot = stats(min_obj).Extrema;
    
    ConvexImage = stats(min_obj).ConvexImage;
    
    BotCentroid = stats(min_obj).Centroid;
    
    boundingBoxBot = round(boundingBoxBot);
    width = boundingBoxBot(3);
    height = boundingBoxBot(4);
    patch = diff_im(boundingBoxBot(2):boundingBoxBot(2)+height-1,boundingBoxBot(1):boundingBoxBot(1)+width-1,:);
    patch = imfill(patch,'holes');
    
%     boundingBoxBot = round(boundingBoxBot);
% 
%     [sx,sx]=sort([stats.Centroid(:,2)]);
%     sortedStats = stats(sx);
    
%     boundingBoxBot = sortedStats(1).BoundingBox;
    
%     % Find all corners
%     cornerCor = zeros(4,2);
%     corner = 1;
%     for object = length(stats)-3:length(stats)
% %          area=stats(object).Area;
% %          if area < max_area
%              cornerCor(corner,:) = stats(object).Centroid;
%              corner = corner + 1;
% %          end
%     end
% %     cornerCor = round(cornerCor);
%     
%     % Order the corners
%     tempCornerCor = cornerCor;
%     [~ , I1] = max(tempCornerCor(:,2));
%     point1 = tempCornerCor(I1,:);
%     tempCornerCor = tempCornerCor(~ismember(1:size(tempCornerCor, 1), [I1]), :);
%     [~ , I2] = max(tempCornerCor(:,2));
%     point2 = tempCornerCor(I2,:);
%     if(point1(1) > point2(1))
%         tempPoint = point1;
%         point1 = point2;
%         point2 = tempPoint;
%     end
% 
%     tempCornerCor = cornerCor;
%     [~ , I3] = min(tempCornerCor(:,2));
%     point3 = tempCornerCor(I3,:);
%     tempCornerCor = tempCornerCor(~ismember(1:size(tempCornerCor, 1), [I3]), :);
%     [~ , I4] = min(tempCornerCor(:,2));
%     point4 = tempCornerCor(I4,:);
%     if(point3(1) < point4(1))
%         tempPoint = point3;
%         point3 = point4;
%         point4 = tempPoint;
%     end
%     
%     cornerCor = [point1;point2;point3;point4];
%     
% %     Finding bounding box of each corner.
%     boundingBox = zeros(4,4);
%     for object = 1:length(sortedStats)
%          centroid = sortedStats(object).Centroid;
%          ind = find(round(cornerCor(:,1)) == round(centroid(1)) & round(cornerCor(:,2)) == round(centroid(2)))
%          if(~isempty(ind));
%             boundingBox(ind,:) = sortedStats(object).BoundingBox;
%          end
%     end
%     
%     boundingBox(1,1) = boundingBox(1,1)+boundingBox(1,3);
%     boundingBox(3,2) = boundingBox(3,2)+boundingBox(3,4);
%     boundingBox(4,1) = boundingBox(4,1)+boundingBox(4,3);
%     boundingBox(4,2) = boundingBox(4,2)+boundingBox(4,4);
    

    % Display the image
%     figure(),imshow(data)
%     
%     hold on
% 
%     
%         bb = boundingBoxBot;
% %         bc = cornerCor(object,:);
%         rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
% 
% 
%     hold off

end