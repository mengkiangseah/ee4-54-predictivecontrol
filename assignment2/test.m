A = magic(3);
B = randn(3, 2);
N = 3;

[Gamma, Phi] = myPrediction(A, B, N);

Phi_actual = [A; A^2; A^3];
zr = zeros(3, 2);
Gamma_actual = [B, zr, zr; A*B, B, zr; A*A*B, A*B, B];

wrong = sum(sum(round(Gamma, 8) ~= round(Gamma_actual, 8))) + sum(sum(round(Phi, 8) ~= round(Phi_actual, 8)));
disp(wrong);