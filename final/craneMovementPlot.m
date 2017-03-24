function craneMovementPlot(x ,y, x_ang, y_ang, targetStates, stateError, stringLength, figureTitle, filetitle)
% cranePendulumMovement(xValues ,yValues, xAngles, yAngles, xTargets, stateMargin, coordinateMargin, figureTitle)
% plots the movement of the gantry crane, and of the pendulum in XY plane
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
plot(x+stringLength*sin(x_ang),y+stringLength*sin(y_ang), '.b', 'markersize', 3); % pendulum
hold on;
% Plot cart
plot(x,y,'.g'); % crane
% Scale axis
axis square;
% corners of the square
for index = 1:size(targetStates,1)
    scatter(targetStates(index,1),targetStates(index,2), 'r');
    viscircles(targetStates(index,:), stateError(1), 'Color', 'r', 'LineWidth', 1, 'LineStyle', ':');
end


% constraint lines
% hline(con(2,2));
% hline(con(2,4));
% hline(con(2,6));
% hline(con(2,8));
% 
% vline(con(1,1));
% vline(con(1,3));
% vline(con(1,5));
% vline(con(1,7));

% plot elements
legend({'Pendulum','Cart', 'Target Limit'}, 'location', 'northeastoutside');
title([figureTitle , ' with ', num2str(size(targetStates,1)) , ' states']);
xlabel('X coordinates');
ylabel('Y coordinates');

set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print(filetitle,'-dpng','-r0');

end