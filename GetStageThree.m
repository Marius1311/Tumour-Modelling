function [tS3, RS3] = GetStageThree(LambdaA, LambdaN, SigmaH, SigmaN, Gamma, RS1, tS1, tS2, RS2, DeltaT, T, RH2)

% Function Definitions

%Singularität bei R_N = R

Z = @(SigmaN, R, R_N, Gamma) (1 - SigmaN) - Gamma/6*(R.^2 - R_N^2);
D1 = @(SigmaN, R, R_N, Gamma) (SigmaN - 1 + Gamma/6*(R.^2 - R_N.^2) )./(2 *(1./R.^3 - 1./R_N.^3));
D2 = @(SigmaN, R, R_N, Gamma) 1 +2*D1(SigmaN, R, R_N, Gamma) ./R^3 - R.^2/6*Gamma;

Sigma3Out = @(SigmaN, R, R_N, Gamma, r) r.^2/6 *Gamma-2*D1(SigmaN, R, R_N, Gamma)./r.^3 +D2(SigmaN, R, R_N, Gamma);
W = @(SigmaN, R, R_N, Gamma) SigmaN - Gamma/6 *R_N.^2 -Z(SigmaN, R, R_N, Gamma).* R_N.^3 ./(R.^3 - R_N.^3);
X = @(R, R_H) (R.^5 - R_H.^5)./(5*R.^2);
Y = @(R, R_N) (R.^6 - R_N.^6)./(R.^3 - R_N.^3);

%This is the result of the integration
R3 = @(SigmaN, R, R_N, R_H, Gamma, LambdaA, LambdaN) (R.^3 - R_H.^3) ./R.^2 .* W(SigmaN, R, R_N, Gamma) + Gamma/2 * X(R, R_H) + Z(SigmaN, R, R_N, Gamma)...
    ./(2*R.^2) .*Y(R, R_N) - LambdaA *R - LambdaN * R_N.^3./R.^2;
G = @(R, R_N, Gamma, SigmaN) R_N./3*Gamma + 6 * D1(SigmaN, R, R_N, Gamma)./R_N.^4; % To find R_N

% Define the function for Sigma
Sigma3 = @(SigmaN, R, R_N, Gamma, r) SigmaN .* (r <= R_N) + Sigma3Out(SigmaN, R, R_N, Gamma, r) .*(r > R_N);

% Initial values
R0 = RS2(end);
t0 = tS2(end);

% We need ROld and RNew
ROld = R0;

%Numbber of timepoints
N = ceil((T - t0)/DeltaT);

% Create Array to store points
RS3 = zeros(N, 1);
tS3 = zeros(N, 1);
RNec = zeros(N, 1);
RHy = zeros(N, 1);

%Set loop counter
n = 1;

% Use explicit Euler scheme
while n <= N
    % This first part is to ensure good initial guesses for the root
    % finding
    if n == 1
        R_N = 0.1; % Starting guess is extremly important, otherwise it goes badly wrong
        R_H = fzero(@(r) Sigma3Out(SigmaN, ROld, R_N, Gamma, r) - SigmaH, [RH2 - 0.1, ROld- 0.1] );
    else
        if n == 2
            R_N = fzero(@(R_N) G(ROld, R_N, Gamma, SigmaN), [0.1, RHy(n-1, 1)]);
            R_H = fzero(@(r) Sigma3Out(SigmaN, ROld, R_N, Gamma, r) - SigmaH, [RHy(n- 1, 1), ROld - 0.1] );
        else
            R_N = fzero(@(R_N) G(ROld, R_N, Gamma, SigmaN), [RNec(n-1, 1), RHy(n-1 , 1)]); 
            R_H = fzero(@(r) Sigma3Out(SigmaN, ROld, R_N, Gamma, r) - SigmaH, [RHy(n-1), ROld - 0.1] );
        end
    end
    
RNew = ROld + R3(SigmaN, ROld, R_N, R_H, Gamma, LambdaA, LambdaN) * DeltaT;
RS3(n, 1) =  RNew;
tS3(n, 1) = tS2(end) + n*DeltaT;
RNec(n, 1) = R_N;
RHy(n, 1) = R_H;
ROld = RNew;
n = n+1;
end

FigHandle = figure('Position', [140, 140, 1000, 500]);

%Plot R(t)
subplot(1, 2, 1), plot([tS1; tS2; tS3], [RS1; RS2; RS3], 'b-', tS1(end), RS1(end), 'rx', tS2(end), RS2(end), 'rx' ), title({'Stage One, Two and Three Tumour Growth R(t)', 'Steady state attained'}), xlabel('t'), ylabel('R'), grid;

% Plot Nutrient distribution
r = linspace(0, RS3(end));
subplot(1, 2, 2), plot(r, Sigma3(SigmaN, RS3(end), R_N, Gamma, r),'b-', R_N, SigmaN, 'rx', R_H, SigmaH, 'rx'),  ...
    title({'Stage One, Two and Three Tumour Growth', 'Final Nutrient Distribution'}), xlabel('r'),...
    ylabel('\sigma(r, t) '), grid;

end


