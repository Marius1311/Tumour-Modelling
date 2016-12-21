function [RS1, tS1, State] = GetStageOne_2(LambdaA, Gamma, SigmaH, DeltaT, T)

%Define the function for the nutrient distribution
Sigma1 = @(r, R, Gamma) 1 - Gamma/6*(R^2 - r.^2);

% Define the cell proliferatin function. This should be a function of
% Sigma. Logically, cells should proliferate more as Sigma Increases. The
% function should not become negative on [0, 1]
f = @(x)  0.75 *(exp((x - SigmaH)/1.1) - 1 );

%Initialise:
R0 = 1;
ROld = R0;
N = floor(T/DeltaT);
RS1 = zeros(N, 1);
RS1(1, 1) = 1;
tS1 = zeros(N, 1);
n = 2;

while n <= N
    I = integral(@(r) f(Sigma1(r, ROld, Gamma)).*r.^2, 0, ROld);
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
    State = 'Steady State attained';
else
    State = 'Model breakdown';
    RS1 = RS1(1:n-1);
    tS1 = tS1(1:n-1);
end

FigHandle = figure('Position', [140, 140, 600, 300]);
subplot(1, 2, 1), plot(tS1, RS1), title({'Stage I Tumour Growth R(t)', State}), xlabel('t'), ylabel('R'), grid;

% This finds R(t), but we also would like to see the nutrient distribution when the final value for R is attained.
% Plot nutrient distribution
r = linspace(0, RS1(end));
subplot(1, 2, 2), plot(r, Sigma1(r, RS1(end), Gamma)),grid,  title({'Stage I Tumour Growth', 'Final Nut. Dist.'}), xlabel('r'), ylabel('\sigma(r, t) ');



end

