function[points2D] = calculatePatchCorners(botBoundingBox,Extrema,patch)
%     width = botBoundingBox(3);
%     height = botBoundingBox(4);
%     % First Point
%     xi = botBoundingBox(1)+width/4;
%     yi = botBoundingBox(2)+height/4;
%     wintx = ceil(width/2);  
%     winty = ceil(height/2);
%     fp = cornerfinder([xi;yi],patch,winty,wintx)';
%     
%     % Second Point
%     xi = botBoundingBox(1) + 3*width/4;
%     yi = botBoundingBox(2)+height/4;
% %     wintx = ceil(botBoundingBox(3)/2);  
% %     winty = ceil(botBoundingBox(4)/2);
%     sp = cornerfinder([xi;yi],patch,winty,wintx)';
%     
%     % Third Point
%     xi = botBoundingBox(1) + 3*width/4;
%     yi = botBoundingBox(2) + 3*height/4;
% %     wintx = ceil(botBoundingBox(3)/2);  
% %     winty = ceil(botBoundingBox(4)/2);
%     tp = cornerfinder([xi;yi],patch,winty,wintx)';
%     
%     % Fourth Point
%     xi = botBoundingBox(1)+width/4;
%     yi = botBoundingBox(2) + 3*height/4;
% %     wintx = ceil(botBoundingBox(3)/2);  
% %     winty = ceil(botBoundingBox(4)/2);
%     fop = cornerfinder([xi;yi],patch,winty,wintx)';
%     
%     points2D = [fp; sp; tp; fop];
    
    width = botBoundingBox(3);
    height = botBoundingBox(4);
    % First Point
    xi = botBoundingBox(1)+width/4;
    yi = botBoundingBox(2)+height/4;
    wintx = ceil(width/3);  
    winty = ceil(height/3);
    fp = cornerfinder([xi;yi],patch,winty,wintx)';
    
    % Second Point
    xi = botBoundingBox(1) + 3*width/4;
    yi = botBoundingBox(2)+height/4;
%     wintx = ceil(botBoundingBox(3)/2);  
%     winty = ceil(botBoundingBox(4)/2);
    sp = cornerfinder([xi;yi],patch,winty,wintx)';
    
    % Third Point
    xi = botBoundingBox(1) + 3*width/4;
    yi = botBoundingBox(2) + 3*height/4;
%     wintx = ceil(botBoundingBox(3)/2);  
%     winty = ceil(botBoundingBox(4)/2);
    tp = cornerfinder([xi;yi],patch,winty,wintx)';
    
    % Fourth Point
    xi = botBoundingBox(1)+width/4;
    yi = botBoundingBox(2) + 3*height/4;
%     wintx = ceil(botBoundingBox(3)/2);  
%     winty = ceil(botBoundingBox(4)/2);
    fop = cornerfinder([xi;yi],patch,winty,wintx)';
    
    points2D = [fp; sp; tp; fop];
end