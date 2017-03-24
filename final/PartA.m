% Runs for Part A graphs and data
% Area is only 0 to 0.52 x-wise
% Area is only 0 to 0.62 y-wise

% Establish the trajectory of the square
xTargets = [0.1, 0.1; ...
            0.4, 0.1; ...
            0.4, 0.4; ...
            0.1, 0.4];
% Constants  
Ts=1/30;
N=10;
T=30;

% Determine criteria (position, angle) for state achievement
coordinateMargin = 0.05;
angleMargin = 15 * pi/180; 
angleChangeMargin = 3 * pi/180; 
stateMargin = [coordinateMargin, coordinateMargin, coordinateMargin, coordinateMargin, angleMargin, angleChangeMargin, angleMargin, angleChangeMargin]';

testMyRHC;

%%
craneMovementPlot(responseRHC.output.signals.values(:,1),...
    responseRHC.output.signals.values(:,3),responseRHC.output.signals.values(:,5),...
    responseRHC.output.signals.values(:,7),xTargets,stateMargin,r,'RHC Performance', 'filename');