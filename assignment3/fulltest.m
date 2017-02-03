% Testing script for Assignment 3 functions.

% 0 to choose not to test. 1 to select.
choices = [0, 0, 0, 0];

% Prepare some reused stuff.
A = magic(3);
B = randn(3, 2);
D = randn(4, 3);

cl = ones(4, 1);
ch = ones(4, 1) * 4;
ul = ones(2, 1) * 0.5;
uh = ones(2, 1) * 5;

% Test for myStageConstraints.m
if choices(1) == 1    
    [Dt,Et,bt] = myStageConstraints(A, B, D, cl, ch, ul, uh);
    
    Dt_correct = [D * A; -(D * A); zeros(4, 3)];
    Et_correct = [D * B; -(D * B); I(2); I(2)];
    bt_correct = [4; 4; 4; 4; -1; -1; -1; -1; 5; 5; -.5; -.5];
    
    wrong1 = sum(sum(round(Dt_correct) ~= round(Dt))) + ...
        sum(sum(round(Et_correct) ~= round(Et))) + ...
        sum(sum(round(bt_correct) ~= round(bt)));
    
    if wrong1 > 0
        disp('Test for myStageConstraints.m failed.');
        disp('Wrong values: ');
        disp(wrong1);
    end
    
end

% Test for myTrajectoryConstraints.m
if choices(2) == 1    
    [Dt,Et,bt] = myStageConstraints(A, B, D, cl, ch, ul, uh);
    N = 3;
    [DD,EE,bb] = myTrajectoryConstraints(Dt,Et,bt,N);
    
    zrd = zeros(12, 3);
    DD_correct = [Dt, zrd, zrd; zrd, Dt, zrd; zrd, zrd, Dt];
    
    zre = zeros(12, 2);
    EE_correct = [Et, zre, zre; zre, Et, zre; zre, zre, Et];
    
    bb_correct = [bt; bt; bt];
    
    wrong2 = sum(sum(round(DD_correct) ~= round(DD))) + ...
        sum(sum(round(EE_correct) ~= round(EE))) + ...
        sum(sum(round(bb_correct) ~= round(bb)));
    
    if wrong2 > 0
        disp('Test for myTrajectoryConstraints.m failed.');
        disp('Wrong values: ');
        disp(wrong2);
    end
end

% Test for myConstraintMatrices.m
if choices(3) == 1
end

% Test for myMPController.m
if choices(4) == 1
end