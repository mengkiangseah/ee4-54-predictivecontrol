clear variables
close all
clc
%% SimscapeCrane_MPC_start;
load('Params_Simscape.mat');
load('SSmodelParams.mat');
%% Load the dynamics matrices using a solution from last assignment
Ts=1/20;
[A,B,C,~] = genCraneODE(m,M,MR,r,g,Tx,Ty,Vm,Ts);

%% Define other parameters
N=ceil(3/Ts); % ceiling to ensure N is an integer
T=5;
xTarget=[0.4 0 0.5 0 0.1 0 0.1 0]';% target equilibrium state
x0=[0.1 0 0.1 0 0 0 0 0]'; % starting offset

%% Declare penalty matrices and tune them here:
Q=eye(8);
Q(1,1)=10;
Q(3,3)=10;
R=eye(2);
P=Q;

%% Declare contraints
% Declaring constraints only on states (X,Y,theta,psi) and inputs u
angleConstraint=8*pi/180; % in radians
cl=[0.02; 0.02; -angleConstraint; -angleConstraint];
ch=[0.45; 0.55;  angleConstraint;  angleConstraint];
ul=[-1; -1];
uh=[1; 1];
% constrained vector is Dx, hence
D=zeros(4,8);D(1,1)=1;D(2,3)=1;D(3,5)=1;D(4,7)=1;

%% Compute stage constraint matrices and vector
[Dt,Et,bt]=myStageConstraints(A,B,D,cl,ch,ul,uh);

%% Compute trajectory constraints matrices and vector
[DD,EE,bb]=myTrajectoryConstraints(Dt,Et,bt,N);

%% Compute QP constraint matrices
[Gamma,Phi] = genPrediction(A,B,N); % get prediction matrices:
[F,J,L]=myConstraintMatrices(DD,EE,Gamma,Phi,N);


%% Compute QP cost matrices
[H,G] = genCostMatrices(Gamma,Phi,Q,R,P,N);

%% Prepare cost and constraint matrices for mpcqpsolver
% Calculating the inverse of the lower triangular H. see doc mpcqpsolver.
[H,p] = chol(H,'lower');
H=(H'\eye(size(H)))';

%% Running a matlab simulation and visualisng the results:
MatlabSimulation
GantryResponsePlot(t,allU,...
    x,[-1 -1],[1 1],[0 0],[xRange(2) yRange(2)],[1 3],xTarget,'Linear simulation: MPC performance');
%% Run the Simulink simulation for your controller
% Note that in order to test your controller you have to navigate to
% SimscapeCrane_MPChard/MPC and copy paste your controller code inside the
% Matlab Function block

SimscapeCrane_MPChard
sim('SimscapeCrane_MPChard');
responseRHC.output=GantryCraneOutput;
responseRHC.input=GantryCraneInput;
%% visualise the performance:
GantryResponsePlot(responseRHC.output.time,responseRHC.input.signals.values,...
    responseRHC.output.signals.values,[-1 -1],[1 1],[0 0],[xRange(2) yRange(2)],...
    [1 3],xTarget,'Nonlinear simulation: MPC performance');