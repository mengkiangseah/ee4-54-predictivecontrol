function [Gamma,Phi] = myPrediction(A,B,N)
% MYPREDICTION  [Gamma,Phi] = myPrediction(A,B,N). 
% A and B are discrete-time state space matrices for x[k+1]=Ax[k]+Bu[k]
% N is the horizon length. 
% Your code is suppose to work for any linear system, not just the gantry crane. 

    % n is number of states
    % m is number of inputs
    % A is n x n
    % B is n x m
    n = size(B, 1);
    % m = size(B, 2);
    
    % Phi is Nn x n, is [A; 0]
    % But Phi = Abar\E
    % E is [A; zeros], size Nn x n.
    E = [A; zeros((N-1)*n, n)];
    % Abar is I - [zeros, zero; I kron A, zeros], size Nn x Nn
    Abar_part = [zeros(n, N*n); kron(eye(N-1), A), zeros((N-1) * n, n)];
    Abar = eye(N*n) - Abar_part;
    % Obtain Phi value.
    Phi = Abar\E;
    
    % Gamma is Nn x Nm, is [B, 0; AB, B, 0;, A^2 B, AB, B, 0; etc.]
    % But Gamma = Abar\Bbar
    % Bbar is I kron B, Nn * Nm
    Bbar = kron(eye(N), B);
    % Abar is Nn x Nn
    Gamma = Abar\Bbar;
end
