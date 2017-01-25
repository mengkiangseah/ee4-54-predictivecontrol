clear;
m = .2;
M = .5;
MR = 1.7;
r = .5;
g = 10;
Tx = .7;
Ty = .7;
Vm = 4;
Ts = 0;

[A, B, C, D] = myCraneODE(m, M, MR, r, g, Tx, Ty, Vm, Ts);
[T, ~, ~, ~] = myCraneODE(0.5, 1, 3, 0.5, 9.8, 0.2, 0.2, 0.6, 0.01);
[Ad, Bd, Cd, Dd] = myCraneODE(m, M, MR, r, g, Tx, Ty, Vm, .5);