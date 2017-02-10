function [F, J, L] = myConstraintMatrices(DD, EE, Gamma, Phi, N)
% MYCONSTRAINTMATRICES [F, J, L] = myConstraintMatrices(DD, EE, Gamma, Phi, N)
% F, J, L are from the inequality equation. 
% DD, EE, are from the expanded trajectory constraints.
% Gamma and Phi are from the prediction equation.
% N is number of x
    
    % F is defined as Dbar x Gamma_tilda + Ebar
    % Gamma_tilda defined as: [zeros(n, Nm); [I(n * (N - 1))] * Gamma]
    % Gamma is Nn * Nm
    n = size(Gamma, 1)/N;
    m = size(Gamma, 2)/N;
    Gamma_tilda = [zeros(n, (N * m)); Gamma(1:n*(N-1), :)];
    F = (DD * Gamma_tilda) + EE;
    
    % J is defined as - Dbar * Phi_tilda
    % Phi_tilda is defined as: [I(n); [In(N-1); 0]Phi]
    Phi_tilda = [eye(n); Phi(1:n*(N-1), :)];
    J = -(DD * Phi_tilda);
    
    % L is defined as - J - (Dbar * (1N kron I))
    % I needs to have columns of number of rows in x, i.e. n

    L = - J - (DD * kron(ones(N, 1), eye(n)));
end

