function craneMovementPlot(x ,y, x_ang, y_ang, targetStates, stateError, innerLimits, stringLength, figureTitle, filetitle)
    % craneMovementPlot(xValues ,yValues, xAngles, yAngles, xTargets, stateMargin, coordinateMargin, figureTitle)
    % Tracks gantry crane, pendulum, points, 
    % Draws corners of square to be tracked, and margin.
    % Legend: 
    % Cart green, mass blue.
    % Red dot corner, red circle margin. 
    
    % Create picture
    figure('position', [0 0 1280 800]);
    % Plot mass
    massX = x+stringLength*sin(x_ang);
    massY = y+stringLength*sin(y_ang);
    plot(massX, massY, '.b', 'markersize', 10); 
    hold on;
    % Plot cart
    plot(x,y,'.g', 'markersize', 10); 

    % corners of the square
    for index = 1:size(targetStates,1)
        scatter(targetStates(index,1),targetStates(index,2), 'r');
        viscircles(targetStates(index,:), stateError(1), 'Color', 'r', 'LineWidth', 5, 'LineStyle', ':');
    end

    % Scale axis
    axis square;
    % plot elements
    legend({'Pendulum','Cart', 'Target Limit'}, 'location', 'northeastoutside');
    xlabel('X coordinates');
    ylabel('Y coordinates');
    
    % Error calculation
    maxX = max(massX);
    minX = min(massX);
    maxY = max(massY);
    minY = min(massY);
    outerArea = abs(maxX - minX) * abs(maxY - minY);
    
    % Inner area:
    minXdash = innerLimits(1);
    maxXdash = innerLimits(2);
    minYdash = innerLimits(3);
    maxYdash = innerLimits(4);
    
    innerArea = abs(minXdash - maxXdash) * abs(minYdash - maxYdash);
    % Overall
    overallError = outerArea - innerArea;
    figureTitle = [figureTitle , ' Error: ', num2str(overallError)];
    title(figureTitle);

    % Add lines to plot.
    plot([0 .5], [maxY maxY], 'k-', 'LineWidth', 4);
    plot([0 .5], [maxYdash maxYdash], 'k-', 'LineWidth', 4);
    plot([0 .5], [minYdash minYdash], 'k-', 'LineWidth', 4);
    plot([0 .5], [minY minY], 'k-', 'LineWidth', 4);

    plot([minX  minX], [0.05 0.45], 'k-', 'LineWidth', 4);
    plot([maxX  maxX], [0.05 0.45], 'k-', 'LineWidth', 4);
    plot([maxXdash maxXdash], [0.05 0.45], 'k-', 'LineWidth', 4);
    plot([minXdash minXdash], [0.05 0.45], 'k-', 'LineWidth', 4);
    
    set(findall(gcf,'type','axes'),'fontsize',25);
    set(findall(gcf,'type','text'),'fontSize',25);
    % Save data
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print(filetitle,'-dpng','-r0');

end