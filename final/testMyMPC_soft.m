%% Start from Running simulation.
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