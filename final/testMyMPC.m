%% Get ready
close all
clc

%% Load the dynamics matrices using a solution from last assignment
[A,B,C,~] = myCraneODE(m,M,MR,r,g,Tx,Ty,Vm,Ts);

%% Declare penalty matrices and tune them here:
Q=zeros(8);
Q(1,1)=1; % weight on X
Q(3,3)=10; % weight on Y
% In order to test constraints, do not penalise angle or derivative of
% angle. Instead impose soft constraints on them. 
%Q(5,5)=1; % weight on theta
%Q(7,7)=1; % weight on psi
R=eye(2)*0.01; % very small penalty on input to demonstrate hard constraints
P=Q; % terminal weight

%% Declare contraints
% Constrain only states (X,Y,theta,psi)
% Constrained vector is Dx, hence
D=zeros(4,8);D(1,1)=1;D(2,3)=1;D(3,5)=1;D(4,7)=1;

angleConstraint=2*pi/180; % in radians
cl=[0;  0; -angleConstraint;  -angleConstraint];
ch=[0.9*xRange(2);  0.9*yRange(2);  angleConstraint;  angleConstraint];

% Input constraints (hard)
ul=[-1; -1];
uh=[1; 1];

%% Compute stage constraint matrices and vector
[Dt,Et,bt]=myStageConstraints(A,B,D,cl,ch,ul,uh);

%% Compute trajectory constraints matrices and vector
[DD,EE,bb]=myTrajectoryConstraints(Dt,Et,bt,N);

%% Compute QP constraint matrices
[Gamma,Phi] = myPrediction(A,B,N); % get prediction matrices:
[F,J,L]=myConstraintMatrices(DD,EE,Gamma,Phi,N);

%% Compute QP cost matrices
[H,G]=myCostMatrices(Gamma,Phi,Q,R,P,N);

%% Compute matrices and vectors for soft constraints
% Define weights for constraint violations
rho = 1e3; % weight for exact penalty term
S = 1e-3*eye(size(D,1)); % small positive definite quadratic cost to ensure uniqueness
[Hs,gs,Fs,bs,Js,Ls] = mySoftPadding(H,F,bb,J,L,S,rho,size(B,2));

%% replace matrices and vectors to simplify code 
H = Hs;
F = Fs;
bb = bs;
J = Js;
L = Ls;

%% Prepare cost and constraint matrices for mpcqpsolver
% Calculating the inverse of the lower triangular H. see doc mpcqpsolver.
% We do it here rather than inside myMPController for speed and generality
[H,p] = chol(H,'lower');
H=H\eye(size(H));

%% Running a Matlab simulation and visualising the results:
MatlabSimulation
GantryResponsePlot(t,allU,x,ul,uh,cl,ch,[1 3 5 7],xTarget,'Linear simulation');

%% Run the Simulink simulation for your controller
% Note that in order to test your controller you have to navigate to
% SimscapeCrane_MPCsoft/MPC to copy and paste your controller code inside the
% Matlab Function block

SimscapeCrane_MPCsoft
sim('SimscapeCrane_MPCsoft');
responseRHC.output=GantryCraneOutput;
responseRHC.input=GantryCraneInput;
%% visualise the performance:
GantryResponsePlot(responseRHC.output.time,responseRHC.input.signals.values,...
    responseRHC.output.signals.values,ul,uh,cl,ch,[1 3 5 7],xTarget,'Nonlinear simulation');