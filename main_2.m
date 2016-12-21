%% A continious model for avascular tumour growth, flexible cell proliferatin rate

% This is the same as main, the onl difference is that this tries to
% introduce a more flexible cell proliferation rate. Only the first stage
% of tumour growth is considered

%% Model definitions

%We will initialise a couple of parameters
LambdaA = 0.9; % nondimensional natural rate of cell death
LambdaN = 0.2; % Nondimensional necrosis rate
SigmaH = 0.1; % nondimensional limit at which cells become quiescent. Has to be within [0, 1]
SigmaN = 0.1; % nondimesnional limit at which cells besome nectrotic
Gamma = 0.3; % nondimensional nutrient consumption rate

%% Stage One

% This is the first stage, in which the tumour simply grows exponentially
% Two things can happen here: Either, a steady state is attained in this
% phase, or the model breaks down when the central region of quiescene
% starts forming. 

DeltaT = 0.1;
T = 100;

[RS1, tS1, State] = GetStageOne_2(LambdaA, Gamma, SigmaH, DeltaT, T);

%% Plotting the proliferation rate function f

FigHandle = figure('Position', [140, 140, 600, 300]);
subplot(1, 2, 1), fplot(@(x) 1 - exp(-3*(x - SigmaH)), [0, 1]), grid, ylim([0, 1]),  title('f_1(\sigma) = 1 - e^{-3 (\sigma - \sigma_H)}'), xlabel('\sigma'), ylabel('f_1');
subplot(1, 2, 2), fplot(@(x) 0.75 *(exp((x - SigmaH)/1.1) - 1), [0, 1]), ylim([0, 1]), grid, title('f_2(\sigma) = 0.75 * (e^{(\sigma - \sigma_H) / 1.1} - 1)'), xlabel('\sigma'), ylabel('f_2');

%% Comparing the behaviour for the two different functions

DeltaT = 0.1;
T = 100;

[RS1, tS1, State1, State2] = GetStageOne_C(LambdaA, Gamma, SigmaH, DeltaT, T);
    
        
