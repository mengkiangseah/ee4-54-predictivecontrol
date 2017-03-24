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
%% Set sample period and prediction horizon
Ts=1/10;
Tf=1.5; % duration of prediction horizon in seconds
N=ceil(Tf/Ts); % ceiling to ensure horizon length N is an integer

%% Determine criteria (position, angle) for state achievement
coordinateMargin = 0.05;
angleMargin = 15 * pi/180; 
angleChangeMargin = 3 * pi/180; 
stateMargin = [coordinateMargin, coordinateMargin, coordinateMargin, coordinateMargin, angleMargin, angleChangeMargin, angleMargin, angleChangeMargin]';
