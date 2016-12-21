function [RS1, tS1, State1, State2] = GetStageOne_C(LambdaA, Gamma, SigmaH, DeltaT, T)

%Define the function for the nutrient distribution
Sigma1 = @(r, R, Gamma) 1 - Gamma/6*(R^2 - r.^2);

% Define the cell proliferatin function. This should be a function of
% Sigma. Logically, cells should proliferate more as Sigma Increases. The
% function should not become negative on [0, 1]
f1 = @(x)  1 - exp(-3*(x - SigmaH));
f2 = @(x)  0.75 *(exp((x - SigmaH)/1.1) - 1);


%Initialise:
R0 = 1;
ROld = R0;
N = floor(T/DeltaT);
RS1 = zeros(N, 1);
RS1(1, 1) = 1;
tS1 = zeros(N, 1);
n = 2;

while n <= N
    I = integral(@(r) f1(Sigma1(r, ROld, Gamma)).*r.^2, 0, ROld);
    RHS = 3*I/ROld^2 - LambdaA*ROld;
    RNew = ROld + DeltaT *RHS;
     if Sigma1(0, RNew, Gamma) <= SigmaH
        break
     end
    RS1(n, 1) = RNew;
    tS1(n, 1) = tS1(n-1, 1) + DeltaT;
    ROld = RNew;
    n = n+1;
end

if n >= N
    State1 = 'Steady State attained';
else
    State1 = 'Model breakdown';
    RS1 = RS1(1:n-1);
    tS1 = tS1(1:n-1);
end

%Initialise:
R0 = 1;
ROld = R0;
N = floor(T/DeltaT);
RS2 = zeros(N, 1);
RS2(1, 1) = 1;
tS2 = zeros(N, 1);
n = 2;

while n <= N
    I = integral(@(r) f2(Sigma1(r, ROld, Gamma)).*r.^2, 0, ROld);
    RHS = 3*I/ROld^2 - LambdaA*ROld;
    RNew = ROld + DeltaT *RHS;
     if Sigma1(0, RNew, Gamma) <= SigmaH
        break
     end
    RS2(n, 1) = RNew;
    tS2(n, 1) = tS2(n-1, 1) + DeltaT;
    ROld = RNew;
    n = n+1;
end

if n >= N
    State2 = 'Steady State attained';
else
    State2 = 'Model breakdown';
    RS2 = RS2(1:n-1);
    tS2 = tS2(1:n-1);
end

FigHandle = figure('Position', [140, 140, 600, 300]);
subplot(1, 2, 1), plot(tS1, RS1), title({'Stage I using f_1(\sigma)'}), xlabel('t'), ylabel('R'), grid;
subplot(1, 2, 2), plot(tS2, RS2), title({'Stage I using f_2(\sigma)'}), xlabel('t'), ylabel('R'), grid;
end
