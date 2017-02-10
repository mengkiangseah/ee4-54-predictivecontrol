function [F, J, L] = myConstraintMatrices(DD, EE, Gamma, Phi, N)
% MYCONSTRAINTMATRICES [F, J, L] = myConstraintMatrices(DD, EE, Gamma, Phi, N)
% F, J, L are from the inequality equation. 
% DD, EE, are from the expanded trajectory constraints.
% Gamma and Phi are from the prediciton equation.
% N is number of x
    
    % F is defined as Dbar x Gamma + Ebar
    F = (DD * Gamma) + EE;
    
    % J is defined as - Dbar * Phi
    J = -(DD * Phi);
    
    % L is defined as - J - (Dbar * (1N kron I))
    % I needs to have columns of number of rows in x, i.e. n
    % Phi is Nn * n, so n is columns in Phi
    n = size(Phi, 2);
    L = - J - (DD * kron(ones(N, 1), eye(n)));
end

