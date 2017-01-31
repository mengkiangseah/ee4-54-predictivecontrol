% Test for myPrediction
A = magic(3);
B = randn(3, 2);
N = 3;

[Gamma, Phi] = myPrediction(A, B, N);

Phi_actual = [A; A^2; A^3];
zr = zeros(3, 2);
Gamma_actual = [B, zr, zr; A*B, B, zr; A*A*B, A*B, B];

wrong1 = sum(sum(round(Gamma, 8) ~= round(Gamma_actual, 8))) + sum(sum(round(Phi, 8) ~= round(Phi_actual, 8)));
disp(wrong1);

% Test for myCostMatrices
Qtild = randn(5, 3);
Q = Qtild' * Qtild;
Rtild = randn(6, 2);
R = Rtild' * Rtild;
Ptild = randn(4, 3);
P = Ptild' * Ptild;

[H, G] = myCostMatrices(Gamma,Phi,Q,R,P,N);

zr22 = zeros(2, 2);
zr33 = zeros(3, 3);
Rbar = [R, zr22, zr22; zr22, R, zr22; zr22, zr22, R];
Qbar = [Q, zr33, zr33; zr33, Q, zr33; zr33, zr33, P];
H_actual = 2 * (Rbar + Gamma' * Qbar * Gamma);
G_actual = 2 * Gamma' * Qbar * Phi;

wrong2 = sum(sum(round(H, 8) ~= round(H_actual, 8))) + sum(sum(round(G, 8) ~= round(G_actual, 8)));
disp(wrong2);

% Test for myRHC
m = 2;
K = myRHC(H,G,m);
L = -(H\G);
Lm = L(1:2, 1:3);
wrong3 = sum(sum(round(Lm, 8) ~= round(K, 8)));
disp(wrong3);
