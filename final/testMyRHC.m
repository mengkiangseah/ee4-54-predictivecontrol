close all
%% Load the parameters
load('Params_Simscape.mat');
load('SSmodelParams.mat');
%% Declare simulation parameters
% Load the matrices using a solution from the previous assignment
[A,B,C,D] = myCraneODE(m,M,MR,r,g,Tx,Ty,Vm,Ts);

% Determine start point
xZero = xTargets(1,1);
yZero = xTargets(1,2);
%% Declare penalty matrices and tune them here:
Q=eye(8) * 10;
R=eye(2) * .001;
P=Q * 10;
Q(1,1) = 100;
Q(3,3) = 100;
%% Compose prediction matrices for RHC
% your myPrediction function is called here and the variables Gamma and Phi are 
% declared in the workspace. 
[Gamma,Phi]=myPrediction(A,B,N);
%% Declare RHC control law
% The linear control law K is declared here. It will be visible to a Simulink 
% constant block and can be used to implement the control law.
% See how this is implemented here: SimscapeCrane_RHC/Controllers
[H,G] = myCostMatrices(Gamma,Phi,Q,R,P,N);
K = myRHC(H,G,size(B,2));
%% Run the simulations for your controller and the PID controller
% Select controller, Uncomment as required
% controlCase=1; % your RHC 

% Open the model
SimscapeCrane_RHC; 

controlCase=1;
sim('SimscapeCrane_RHC');
responseRHC.output=GantryCraneOutput;
responseRHC.input=GantryCraneInput;
responseRHC.input.signals.values = permute(responseRHC.input.signals.values, [3,1,2]);

%% visualise the performance:
% help GantryResponsePlot
% GantryResponsePlot(responseRHC.output.time, responseRHC.input.signals.values,...
%     responseRHC.output.signals.values,[-1 -1],[1 1],[0 0],[xRange(2) yRange(2)],[1 3],xTarget,'RHC performance');