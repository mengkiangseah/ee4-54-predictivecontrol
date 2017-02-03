function [DD, EE, bb] = myTrajectoryConstraints(Dt, Et, bt, N)
% MYTRAJECTORYCONSTRAINTS  [DD, EE, bb] = myTrajectoryConstraints(Dt, Et, bt, N)
% DD is Dt expanded for all x
% EE is Et expanded for all x
% bb is bt expanded for all x
% N is number of x

    % DD is just Dt on a diagonal, sized N
    DD = kron(eye(N), Dt);
    
    % EE is just Et on a diagonal, sized N
    EE = kron(eye(N), Et);
    
    % bb is just bt stacked as many as N
    bb =  kron(ones(N, 1), bt);

end

