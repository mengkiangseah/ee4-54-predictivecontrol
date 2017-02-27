function [Hs, gs, Fs, bs, Js, Ls] = mySoftPadding(H, F, bb, J, L, S, rho, m)
% MYSOFTPADDING [Hs, gs, Fs, bs, Js, Ls] = mySoftPadding(H, F, bb, J, L, S, rho, m)
% S = weight for quadratic cost of constraint violations
% rho = scalar weight for 1-norm of constraint violations
% m = number of inputs
% H = quadratic thing
% F, bb, J, L from inequality: F * ubar <= bb + J * x0 + L * xe + T * ue

    % Output: Hs and gs into the cost function
    % Fs, bs, Js, Ls into the inequality

    % Obtain N:
    % H = 2(Rbar - Gamma' * Q * Gamma), Rbar is: eye(N) kron R. 
    % R is used as u' * R * u, hence R is: m x m. eye(N) kron R is: Nm x Nm.
    % Therefore, H is: Nm x Nm.
    N = size(H, 2)/m;

    % Obtain c:
    % cl - sk and cu + sk. Hence, sk is same as cl and cu, c x 1.
    % sk' * S * sk, hence S is: c x c.
    c = size(S, 2);

    % Hs is: [H, 0; 0, 2 * eye(N) kron S)
    % eye(N) kron S is: Nc x Nc, H is: Nm x Nm.
    % First zero is: Nm x Nc, second: Nc x Nm.
    z1 = zeros(N * m, N * c);
    z2 = zeros(N * c, N * m);
    Hs = [H, z1; z2, kron(eye(N), S)];

    % gs is: rho * ones(N*c)
    gs = rho * ones(N*c, 1);

    % Fs is: [F, I_bar; 0, -eye(N*c)]
    % 0 is: N*c x size(F, 2)
    % I_bar is: eye(N) kron I_tilda
    % I_tilda is: [eye(c; -eye(c); 0; 0]
    % Combined, 0s in I_tilda are 2m x c.
    I_tilda = [eye(c); -eye(c); zeros(2 * m, c)];
    I_bar = kron(eye(N), I_tilda);
    Fs = [F, I_bar; zeros(N*c, size(F, 2)), -eye(N*c)];

    % bs, aka bs_bar = [b_bar (aka bb); 0]
    % 0 is N*c x size(bb, 2)
    bs = [bb; zeros(N*c, size(bb, 2))];

    % Js = [J; 0]
    % 0 is N*c x size(J, 2)
    Js = [J; zeros(N*c, size(J, 2))];

    % Ls = [L; 0]
    % 0 is N*c x size(L, 2)
    Ls = [L; zeros(N*c, size(L, 2))];

end

