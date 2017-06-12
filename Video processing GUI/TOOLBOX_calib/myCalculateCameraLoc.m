
for kk = ima_proc
   if active_images(kk)
      if (exist(['X_' num2str(kk)]) && exist(['x_' num2str(kk)]))
          eval([strcat('KHx_', num2str(kk)) '= x_' num2str(kk) ';']);
          eval([strcat('KHX_', num2str(kk)) '= X_' num2str(kk) ';']);        
      end
   end
end

KHitr = 1;
KHdata = [];
KHitrMax = 100;
for i=1:KHitrMax
    % Select 20 points randomly
    KHnpts = size(KHx_1,2);
    KHind = randsample(KHnpts, 35);
    
    for kk = ima_proc
        if active_images(kk)
            eval([strcat('x_', num2str(kk)) '= KHx_' num2str(kk) '(:,KHind)' ';']);
            eval([strcat('X_', num2str(kk)) '= KHX_' num2str(kk) '(:,KHind)' ';']);
        end
    end

    
    
%     figure(3);
%     image(I); colormap(map); hold on;
%     plot(KHx(1,:)+1,KHx(2,:)+1,'go');
%     drawnow;
%     hold off;

%     x = KHx;
%     X = KHX;

    KHitr = i;
    go_calib_optim
    ext_calib2
%     BASEk(:,1)
end

for kk = ima_proc
   if active_images(kk)
      if (exist(['X_' num2str(kk)]) && exist(['x_' num2str(kk)]))
          eval([strcat('x_', num2str(kk)) '= KHx_' num2str(kk) ';']);
          eval([strcat('X_', num2str(kk)) '= KHX_' num2str(kk) ';']);        
      end
   end
end

KHdata = KHdata/3;

for kk = ima_proc
% Mean Error
    KHMean = mean(KHdata,3);
    KHMeanError = KHdata - repmat(KHMean,1,1,KHitrMax);

% Graph
    KHdataX = reshape(KHdata(1,kk,:),1,KHitrMax);
    KHdataY = reshape(KHdata(2,kk,:),1,KHitrMax);
    KHdataZ = reshape(KHdata(3,kk,:),1,KHitrMax);
    
    figure(kk+10);rotate3d on;
    plot3(mean(KHdataX),mean(KHdataY),mean(KHdataZ),'r+');
    
%     hold on;
%     [KHsphereX,KHsphereY,KHsphereZ] = sphere(1);
%     plot3(KHsphereX+mean(KHdataX), KHsphereY+mean(KHdataY), KHsphereZ+mean(KHdataZ)) % where (a,b,c) is center of the sphere
%     drawnow;
%     hold off;
    
    hold on;
    plot3(KHdataX,KHdataY,KHdataZ,'g+');
    drawnow;
    hold off;
    
    title('Camera Locations (world-centered)');
%     axis('equal');
    xlabel('X_{world}');
    ylabel('Y_{world}');
    zlabel('Z_{world}');
    axis vis3d;
%     axis tight;
    grid on;
%     hold on;
%     plot3(mean(KHdataX),mean(KHdataY),mean(KHdataZ),'r+');
%     drawnow;
%     hold off;
    
end

% %% Write tracked coordinates to file
% mkdir(['trace/' outFolder]);
% outPath = ['trace/' outFolder '/'];
% loc = loc(2:frameNo,:);
Data = reshape(KHdata(:,1,:),100,3);
save('KHdata.mat','KHdata');
fileID = fopen('Data.txt','w');
fprintf(fileID,'%d %d %d\r\n',Data);
fclose(fileID);
