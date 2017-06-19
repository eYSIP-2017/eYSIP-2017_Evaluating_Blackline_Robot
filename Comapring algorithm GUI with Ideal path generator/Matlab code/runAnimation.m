function [] = runAnimation(pos,bgImage)
    x = pos(:,1);
    y = pos(:,2);
    t = pos(:,3);

    % Calculate delay interval
    for k=2:size(t,1)
        t(k-1) = t(k)-t(k-1);
    end

    figure(3), imshow(bgImage,'InitialMagnification','fit');
    hold on,
    % create the figure
    %  figure;
    % get a handle to a plot graphics object
    hPlot = plot(NaN,NaN,'ro','MarkerSize',10,'LineWidth',2);
    % set the axes limits
    %  xlim([min(x) max(x)]);
    %  ylim([min(y) max(y)]);
    % iterate through each point on line
    for k=1:length(x)
        % update the plot graphics object with the next position
        set(hPlot,'XData',x(k),'YData',y(k));
        plot(x(1:k),y(1:k),'g-','LineWidth',2);
        % pause for 0.5 seconds
        pause(t(k));
    end
end