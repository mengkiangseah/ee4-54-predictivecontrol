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
coordinateMargin = 0.05;
angleMargin = 15 * pi/180; 
angleChangeMargin = 3 * pi/180; 
stateMargin = [coordinateMargin, coordinateMargin, coordinateMargin, coordinateMargin, angleMargin, angleChangeMargin, angleMargin, angleChangeMargin]';

%% Define other simulation parameters
T=30; % duration of simulation
xTarget=0.8*[xRange(2) 0 yRange(2) 0 0 0 0 0]'; % target equilibrium state
xZero=xRange(1); yZero=yRange(1);
x0=[xZero 0 yZero 0 0 0 0 0]'; % initial state

%% Declare penalty matrices and tune them here:
Q=eye(8) * 10;
R=eye(2) * .001;
P=Q * 10;
Q(1,1) = 100;
Q(3,3) = 100;
%% Run.
testMyRHC;

%% Plot output.
X = responseRHC.output.signals.values(:,1);
Y = responseRHC.output.signals.values(:,3);
THETA = responseRHC.output.signals.values(:,5);
PSI = responseRHC.output.signals.values(:,7);

% Outer Square
massX = X + r*sin(THETA);
massY = Y + r*sin(PSI);
outerArea = abs(max(massX) - min(massX)) * abs(max(massY) - min(massY));


stateAim = [permute(outputStates.data(1,1,:), [3, 1, 2]), permute(outputStates.data(3,1,:), [3, 1, 2])];

% state 2: ymindash
% state 3: xmaxdash
% state 4: ymaxdash
% state 1: xmindash

minYdash = max(Y(ismember(stateAim, xTargets(2, :), 'rows')));
maxXdash = max(X(ismember(stateAim, xTargets(3, :), 'rows')));
maxYdash = max(Y(ismember(stateAim, xTargets(4, :), 'rows')));
minXdash = max(X(ismember(stateAim, xTargets(1, :), 'rows')));

% Inner area:
innerArea = abs(minYdash - maxYdash) * abs(maxXdash - minXdash);

overallError = outerArea - innerArea;
the_title = ['RHC Performance, Error: ', num2str(overallError)];

craneMovementPlot(X,...
    Y, ...
    THETA, ...
    PSI, ...
    xTargets, stateMargin, r, ...
    the_title, 'rhc');