function [A,B,C,D] = myCraneODE(m,M,MR,r,g,Tx,Ty,Vm,Ts)
% Inputs:
% m = Pendulum mass (kg)
% M = Cart mass (kg)
% MR = Rail mass (kg)
% r = String length (m)
% g = gravitational acceleration (m*s^-2)
% Tx = Damping coefficient in X direction (N*s*m^-1)
% Ty = Damping coefficient in Y direction (N*s*m^-1)
% Vm = Input multiplier (scalar)
% Ts = Sample time of the discrete-time system (s)
% Outputs:
% A,B,C,D = State Space matrices of a discrete-time or continuous-time state space model

% The motors in use on the gantry crane are identical and therefore Vx=Vy=Vm.
Vx=Vm;
Vy=Vm;

% Replace A,B,C,D with the correct values
% A is 8 x 8. B is 8 x 2. 
A = zeros(8, 8);
B = zeros(8, 2);

% Assign values to A
A(1, 2) = 1;
A(3, 4) = 1;
A(5, 6) = 1;
A(7, 8) = 1;

A(2, 2) = -(Tx)/(M+MR);
A(2, 5) = (g * m)/(M+MR);

A(4, 4) = -(Ty)/M;
A(4, 7) = (g * m)/M;

A(6, 2) = Tx/(r * (M + MR));
A(6, 5) = -((g * m) + g * (M + MR))/(r * (M + MR));

A(8, 4) = Ty/(M * r);
A(8, 7) = -((M * g) + (m * g))/(M * r);

% Assign values to B
B(2, 1) = Vx/(M + MR);
B(4, 2) = Vy/M;
B(6, 1) = -(Vx)/(r * (M + MR));
B(8, 2) = -(Vy)/(M * r);

% y = Cx + Du = x
% Hence C = I and D = 0, C is 8 x 8, D is 8 x 2. 
C=eye(8);
D=zeros(8, 2);

% If Ts>0 then sample the model with a zero-order hold (piecewise constant)
% input, otherwise return a continuous-time model 
if Ts>0
    % Return discrete-time SS model matrices
    % Create SS system
    sys = ss(A, B, C, D);
    % Convert to discrete
    sysd = c2d(sys, Ts, 'zoh');
    % Reassign to A, B, C, D
    A = sysd.A;
    B = sysd.B;
    C = sysd.C;
    D = sysd.D;
end

end