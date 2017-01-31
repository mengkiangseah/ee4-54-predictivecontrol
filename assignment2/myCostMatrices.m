function [H,G] = myCostMatrices(Gamma,Phi,Q,R,P,N)
% MYCOSTMATRICES [H, G] = myCostMatrices(Gamma,Phi,Q,R,P,N).
% Gamma and Phi are the prediction matrices from myPrediction.m
% Q is the stage cost weight on the states, i.e. x'Qx
% R is the stage cost weight on the inputs, i.e. u'Ru
% P is the terminal weight on the final state

    % H = 2 * (Rbar + Gamma' * Qbar * Gamma)
    % Have Gamma, need Qbar and Rbar
    
    % Q is n x n
    n = size(Q, 1);
    
    % Qbar is Nn x Nn, [I kron Q, 0; 0, P]
    % Zero matrix used is (N-1)n x n and n x (N-1)n
    zr = zeros(n * (N - 1), n);
    Qbar = [kron(eye(N-1), Q), zr; zr', P];
    
    % Rbar is I kron R, R is m x m
    % Rbar is Nm x Nm
    Rbar = kron(eye(N), R);
    
    % Time for H
    H = 2 * (Rbar + Gamma' * Qbar * Gamma);
    
    % G = 2 * Gamma' * Qbar * Phi
    G = 2 * Gamma' * Qbar * Phi;
end