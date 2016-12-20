function [RS1, tS1, State] = GetStageOne(LambdaA, Gamma, SigmaH)
%Define the RHS of the ODE:
R1 = @(t, R) R*(1 - LambdaA - Gamma/15*R.^2);

%Define the function for the nutrient distribution
Sigma1 = @(r, R, Gamma) 1 - Gamma/6*(R^2 - r.^2);

%Initial Condition:
R0 = 1;

%Timespan
tspan1 = [0, 2*15/Gamma];
% Most of the growth will happen in this timespan

% We need to figure out what setting we are in:
if (5*LambdaA > (2*SigmaH + 3)) % stable steady state attainable
    [tS1, RS1] = ode45(R1, tspan1, R0);
    State = 1;
    
    FigHandle = figure('Position', [140, 140, 1000, 500]);
    subplot(1, 2, 1), plot(tS1, RS1), title({'Stage One Tumour Growth R(t)', 'Steady State attained'}), xlabel('t'), ylabel('R'), grid;
    
    % This finds R(t), but we also would like to see the nutrient distribution when the final value for R is attained.
    % Plot nutrient distribution
    r = linspace(0, RS1(end));
    subplot(1, 2, 2), plot(r, Sigma1(r, RS1(end), Gamma)),grid,  title({'Stage One Tumour Growth', 'Final Nutrient Distribution'}), xlabel('r'), ylabel('\sigma(r, t) ');
 
elseif (5*LambdaA < (2*SigmaH + 3)) % steady state unattainable, model breakdown
    StopR1 = @(t, R) R1EventsFcn(t, R, Gamma, SigmaH); % Parametrise events function
    options = odeset('Events', @(t, R) StopR1(t, R)); % set options
    [tS1, RS1, teS1, yeS1, ieS1] = ode45(R1, tspan1, R0, options);
    State = 0;
end

end

