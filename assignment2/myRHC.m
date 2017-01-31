function K = myRHC(H,G,m)
% MYRHC K = myRHC(H,G,m)
% H and G are the cost function matrices
% m is the number of control inputs
% K is the RHC law gain

    % U_bar_star = -(H\G)x0
    % But only want u0, so:
    % u0_star(x0) = -[Im 0]*(H\G)*x0
    % Alternatively, select first m rows of -(H\G) = L
    L = -(H\G);
    K = L(1:m, :);
end