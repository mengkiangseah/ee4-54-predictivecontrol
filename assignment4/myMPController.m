function [u,status,iA1] = myMPController(H, G, gs, F, bb, J, L, x, xTarget, nu, iA)
% H       - quadratic term in the cost function (Linv if using mpcqpsolver).
% G       - matrix in the linear term of the cost function.
% gs      - vector in the linear term of the cost function.
% F       - LHS of the inequalities term.
% bb      - RHS of the inequalities term.
% J       - RHS of inequalities term.
% L       - RHS of inequalities term. Use this to shift constraints around target point
% x       - current state
% xTarget - target equilibrium point.
% nu      - Number of inputs.
% iA      - active inequalities, see doc mpcqpsolver
%
% u is the first input vector u_0 in the sequence [u_0; u_1; ...; u_{N-1}]; 
% In other words, u is the value of the receding horizon control law
% evaluated with the current state x and target xTarget

% Please read the documentation on mpcqpsolver to understand how it is
% suppose to be used. Use iA and iA1 to pass the active inequality vector 

    opt = mpcqpsolverOptions;
    %opt.IntegrityChecks = false; % for code generation
    opt.FeasibilityTol = 1e-3;
    opt.DataType = 'double';
    % Your code starts here
    % H = Hs; F = Fs; bb = bs; J = Js; L = Ls;
    % Has already happened.
    A = -F;
    b = -(bb + (J * x) + (L * xTarget));
    [U, status, iA1] = mpcqpsolver(H, [(x - xTarget)' * G', gs']', A, b, [], zeros(0,1), iA, opt);
    % Your code ends here
    % Copy and paste the indicated parts of your code above to the Simulink model
    u=U(1:nu);
end

