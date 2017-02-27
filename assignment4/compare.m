% Test for mySoftPadding.m

m = 2;
n = 3;
N = 5;
c = 4;

H = randn(N * m , N * m);
F = randn(2 * N * (c + m), N * m);
bb = randn(2 * N * (c + m), 1);
J = randn(2 * N * (c + m), n);
L = randn(2 * N * (c + m), n);
S = randn(c, c);
rho = 0.1;

[Hs, gs, Fs, bs, Js, Ls] = mySoftPadding(H, F, bb, J, L, S, rho, m);
[Hs2, gs2, Fs2, bs2, Js2, Ls2] = otherfunction(H, F, bb, J, L, S, rho, m);

wrongs = [sum(sum(Hs ~= Hs2)); ...
sum(sum(gs ~= gs2)); ...
sum(sum(Fs ~= Fs2)); ...
sum(sum(bs ~= bs2)); ...
sum(sum(Js ~= Js2)); ...
sum(sum(Ls ~= Ls2))];

disp(wrongs);

