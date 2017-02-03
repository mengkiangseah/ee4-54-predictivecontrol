function [Dt,Et,bt] = myStageConstraints(A ,B, D, cl , ch, ul, uh)
% MYSTAGECONSTRAINTS  [Dt,Et,bt] = myStageConstraints(A ,B, D, cl , ch, ul, uh)
% A and B are discrete-time state space matrices for x[k+1]=Ax[k]+Bu[k]
% D is the weighting for the constraints, Dx_k within interval
% cl is the Dx_k lower limit, ch is the Dx_k upper limit
% ul is the u_k lower limit, uh is the u_k upper limit

    % Acquire sizes needed
    n = size(B, 1);
    m = size(B, 2);

    % Dt or D tilda is DA, -DA stacked on top of each other
    % Followed by 2 zero matries (m x n) sized, i.e. (2m x n)
    Dt = [D * A; -(D * A); zeros(2 * m, n)];
    
    % Et or E tilda is DB, -DB stacked on top of each other
    % Followed by 2 identity matrices, m sized, second one negative.
    Et = [D * B; -(D * B); eye(m); -1 * eye(m)];
    
    % bt or b tilda is upper c, negative lower c, upper u, negative lower u
    % All stacked
    bt = [ch; -cl; uh; -ul];
end

