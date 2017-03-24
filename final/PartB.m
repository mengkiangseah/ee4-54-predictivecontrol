clear variables
close all
clc
%% SimscapeCrane_MPC_start;
load('Params_Simscape.mat');
load('SSmodelParams.mat');
%% Load the dynamics matrices using a solution from last assignment
Ts=1/20;
[A,B,C,~] = myCraneODE(m,M,MR,r,g,Tx,Ty,Vm,Ts);

%% Define other parameters
N=20; % ceiling to ensure N is an integer
T=15;
%% Establish the trajectory of the square
xTargets = [0.1, 0.1; ...
            0.4, 0.1; ...
            0.25, 0.4]
% Bottom left, bottom right, top middle
numberStates = size(xTargets, 1);

%% Determine start point
xZero = xTargets(1,1);
yZero = xTargets(1,2);
x0=[xZero 0 yZero 0 0 0 0 0]'; % initial state

%% Other things
coordinateMargin = 0.02;
angleMargin = 15 * pi/180; 
angleChangeMargin = 10 * pi/180; 
stateMargin = [coordinateMargin, coordinateMargin, coordinateMargin, coordinateMargin, angleMargin, angleChangeMargin, angleMargin, angleChangeMargin]';

%% Declare contraints
% Declaring constraints only on states (X,Y,theta,psi) and inputs u
angleConstraint=5*pi/180; % in radians
ul=[-1; -1];
uh=[1; 1];

% THree sets of constraints due to 3 states. Angle constraint the same, just
% different X Y constraint. Between current and previous state, what is max/min X/Y?.
% xTargets = [0.1, 0.1; ...
%             0.4, 0.1; ...
%             0.25, 0.4]
cl1=[0.1; 0.1; -angleConstraint; -angleConstraint];
ch1=[0.25; 0.4; angleConstraint;  angleConstraint];
cl2=[0.1; 0.1; -angleConstraint; -angleConstraint];
ch2=[0.4; 0.1; angleConstraint;  angleConstraint];
cl3=[0.25; 0.1; -angleConstraint; -angleConstraint];
ch3=[0.4; 0.4; angleConstraint;  angleConstraint];
% constrained vector is Dx, hence
D=zeros(4,8);D(1,1)=1;D(2,3)=1;D(3,5)=1;D(4,7)=1;

%% Compute stage constraint matrices and vector
[Dt,Et,bt1]=myStageConstraints(A,B,D,cl1,ch1,ul,uh);
[~,~,bt2]=myStageConstraints(A,B,D,cl2,ch2,ul,uh);
[~,~,bt3]=myStageConstraints(A,B,D,cl3,ch3,ul,uh);

%% Compute trajectory constraints matrices and vector
[DD,EE,bb1]=myTrajectoryConstraints(Dt,Et,bt1,N);
[~,~,bb2]=myTrajectoryConstraints(Dt,Et,bt2,N);
[~,~,bb3]=myTrajectoryConstraints(Dt,Et,bt3,N);

bbs = [bb1, bb2, bb3];
bb = bbs(:,1);       % Apparently needs one to not crash.


%% Run simulation
testMyMPC_B;

%% Plot things
X = responseRHC.output.signals.values(:,1);
Y = responseRHC.output.signals.values(:,3);
THETA = responseRHC.output.signals.values(:,5);
PSI = responseRHC.output.signals.values(:,7);


% Plot it all
craneMovementPlotB(X,...
    Y, ...
    THETA, ...
    PSI, ...
    xTargets, stateMargin, r, ...
    'MPC Constraints', 'mpc_tri');