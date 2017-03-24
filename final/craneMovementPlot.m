function craneMovementPlot(x ,y, x_ang, y_ang, targetStates, stateError, stringLength, figureTitle, filetitle)
    % craneMovementPlot(xValues ,yValues, xAngles, yAngles, xTargets, stateMargin, coordinateMargin, figureTitle)
    % Tracks gantry crane, pendulum, points, 
    % also plots corners of the square to be tracked and the set constraints
    % requires "hline and vline" toolbox
    % Legend: 
    % green - crane
    % blue - pendulum
    % red point - square corner
    % red dotted line - constraint

    % Create picture
    figure('position', [0 0 1280 800]);
    % Plot mass
    massX = x+stringLength*sin(x_ang);
    massY = y+stringLength*sin(y_ang);
    plot(massX, massY, '.b', 'markersize', 5); 
    hold on;
    % Plot cart
    plot(x,y,'.g', 'markersize', 5); 

    % corners of the square
    for index = 1:size(targetStates,1)
        scatter(targetStates(index,1),targetStates(index,2), 'r');
        viscircles(targetStates(index,:), stateError(1), 'Color', 'r', 'LineWidth', 2, 'LineStyle', ':');
    end

    % Scale axis
    axis square;
    % plot elements
    legend({'Pendulum','Cart', 'Target Limit'}, 'location', 'northeastoutside');
    title(figureTitle);
    xlabel('X coordinates');
    ylabel('Y coordinates');

    set(findall(gcf,'type','axes'),'fontsize',25);
    set(findall(gcf,'type','text'),'fontSize',25);
    % Save data
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print(filetitle,'-dpng','-r0');

end