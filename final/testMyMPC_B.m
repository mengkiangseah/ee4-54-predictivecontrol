%% Declare penalty matrices and tune them here:
Q=zeros(8,8);
Q(1,1)= 25;
Q(3,3)= 25;
Q(5,5) = 50;
Q(7,7) = 50;
R=eye(2) * 0.01;
P = Q;

%% Compute QP constraint matrices
[Gamma,Phi] = myPrediction(A,B,N); % get prediction matrices:
[F,J,L]=myConstraintMatrices(DD,EE,Gamma,Phi,N);


%% Compute QP cost matrices
[H,G] = myCostMatrices(Gamma,Phi,Q,R,P,N);

%% Prepare cost and constraint matrices for mpcqpsolver
% Calculating the inverse of the lower triangular H. see doc mpcqpsolver.
[H,p] = chol(H,'lower');
H=(H'\eye(size(H)))';

%% Run linear
% MatlabSimulation;
% GantryResponsePlot(t,allU,...
%     x,[-1 -1],[1 1],[0 0],[xRange(2) yRange(2)],[1 3],xTarget(1, :),'Linear simulation: MPC performance');
%% Run the Simulink simulation for your controller
% Note that in order to test your controller you have to navigate to
% SimscapeCrane_MPChard/MPC and copy paste your controller code inside the
% Matlab Function block
SimscapeCrane_MPChard
sim('SimscapeCrane_MPChard');
responseRHC.output=GantryCraneOutput;
responseRHC.input=GantryCraneInput;
%% visualise the performance:
% GantryResponsePlot(responseRHC.output.time,responseRHC.input.signals.values,...
%     responseRHC.output.signals.values,[-1 -1],[1 1],[0 0],[xRange(2) yRange(2)],...
%     [1 3],xTarget,'Nonlinear simulation: MPC performance');