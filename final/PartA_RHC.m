% Runs for Part A graphs and data
% Area is only 0 to 0.52 x-wise
% Area is only 0 to 0.62 y-wise

%% Load the parameters
load('Params_Simscape.mat');
load('SSmodelParams.mat');

%% Determine start point
xZero = xTargets(1,1);
yZero = xTargets(1,2);

%% Establish the trajectory of the square
xTargets = [0.1, 0.1; ...
            0.4, 0.1; ...
            0.4, 0.4; ...
            0.1, 0.4];
% Bottom left, bottom right, top right, top left
%% Constants  
Ts=1/30;
N=10;
T=30;

%% Determine criteria (position, angle) for state achievement
coordinateMargin = 0.02;
angleMargin = 15 * pi/180; 
angleChangeMargin = 3 * pi/180; 
stateMargin = [coordinateMargin, coordinateMargin, coordinateMargin, coordinateMargin, angleMargin, angleChangeMargin, angleMargin, angleChangeMargin]';

%% Declare penalty matrices and tune them here:
Q=eye(8) * 10;
R=eye(2) * .001;
P= Q * 10;
Q(1,1) = 100;
Q(3,3) = 100;
%% Run.
testMyRHC;

%% Plot output.
X = responseRHC.output.signals.values(:,1);
Y = responseRHC.output.signals.values(:,3);
THETA = responseRHC.output.signals.values(:,5);
PSI = responseRHC.output.signals.values(:,7);

massX = X+r*sin(THETA);
massY = Y+r*sin(PSI);

% Calculate inner limits
stateAim = [permute(outputStates.data(1,1,:), [3, 1, 2]), permute(outputStates.data(3,1,:), [3, 1, 2])];

% state 2: ymindash
% state 3: xmaxdash
% state 4: ymaxdash
% state 1: xmindash

minYdash = max(massY(ismember(stateAim, xTargets(2, :), 'rows')));
maxXdash = min(massX(ismember(stateAim, xTargets(3, :), 'rows')));
maxYdash = min(massY(ismember(stateAim, xTargets(4, :), 'rows')));
minXdash = max(massX(ismember(stateAim, xTargets(1, :), 'rows')));

% Plot it all
craneMovementPlot(X,...
    Y, ...
    THETA, ...
    PSI, ...
    xTargets, stateMargin, [minXdash, maxXdash, minYdash, maxYdash], r, ...
    'RHC Unconstrained', 'rhc');