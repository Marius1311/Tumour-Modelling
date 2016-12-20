function [tS2, RS2, State, RH2] = GetStageTwo(LambdaA, Gamma, SigmaH, SigmaN, RS1, tS1)

% First, we will define functions for R_H and for the RHS of the new
% boundary equation:

R_H = @(R, Gamma, SigmaH) sqrt(R.^2 + 6/Gamma*(SigmaH - 1));
R2 = @(t, R) R*(1 - LambdaA) - R_H(R, Gamma, SigmaH).^3./R.^2 - Gamma/2*(2*R.^5 ...
    - 5*R_H(R, Gamma, SigmaH).^3.*R.^2 + 3*R_H(R, Gamma, SigmaH).^5)./(15*R.^2);

%Define the function for the nutrient distribution
Sigma2 = @(r, R, Gamma) 1 - Gamma/6*(R^2 - r.^2);

%Initial Condition:
R0 = RS1(end);

%Timespan
tspan2 = [tS1(end), 50];
% Most of the growth will happen in this timespan

%This time it is harder to predict whether a steady state will be attained
%or not. We will just calculate the numeric solution and roll with it.
 StopR2 = @(t, R) R2EventsFcn(t, R, Gamma, SigmaN); % Parametrise events function
 options2 = odeset('Events', @(t, R) StopR2(t, R)); % set options
 [tS2, RS2, teS2, yeS2, ieS2] = ode45(R2, tspan2, R0, options2);
 
 if tS2(end) == tspan2(end)
     
     FigHandle = figure('Position', [140, 140, 1000, 500]);
     
     %Plot R(t)
     State = 1;
     subplot(1, 2, 1), plot([tS1; tS2], [RS1; RS2],'b-', tS1(end), RS1(end), 'rx'), title({'Stage One and Two Tumour Growth R(t)', 'Steady State attained'}), xlabel('t'), ylabel('R'), grid;
     
     %Plot nutrient distribution
     r = linspace(0, RS2(end));
     subplot(1, 2, 2), plot(r, Sigma2(r, RS2(end), Gamma), 'b-', R_H(RS2(end), Gamma, SigmaH), SigmaH, 'rx'), ...
         title({'Stage One and Two Tumour Growth',' Final Nutrient Distribution'}), xlabel('r'),...
         ylabel('\sigma(r, t) '), grid;
     
 else
     State = 0;
 end
 


% Just to check:
RH2 = sqrt(RS2(end)^2 + 6/Gamma*(SigmaH - 1));

end

