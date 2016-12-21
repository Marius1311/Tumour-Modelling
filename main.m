%% A continious model for avascular tumour growth

% This will be a very simple simulation for thw growth of a tumour in one
% dimension, assuming spherical symmetry and no blood vessels. The growth
% of the tumour will only deoend on the availability of one single
% nutrient. The cells can do three things: Either they proliferate, they
% are quiescent or they die. We will compute results for the value of the
% outer radius with respect of time and for the nutrient concentration in
% terms of r.

%% Model definitions

%We will initialise a couple of parameters
LambdaA = 0.1; % nondimensional natural rate of cell death
LambdaN = 0.2; % Nondimensional necrosis rate
SigmaH = 0.9; % nondimensional limit at which cells become quiescent. Has to be within [0, 1]
SigmaN = 0.8; % nondimesnional limit at which cells besome nectrotic
Gamma = 0.3; % nondimensional nutrient consumption rate

%% Stage One

% This is the first stage, in which the tumour simply grows exponentially
% Two things can happen here: Either, a steady state is attained in this
% phase, or the model breaks down when the central region of quiescene
% starts forming. 

[RS1, tS1, State] = GetStageOne(LambdaA, Gamma, SigmaH);

%% Stage Two

% This the the stage in which a quiescent core forms of cells that are not
% dead but equally not quite happy enough to proliferate.

if State == 0
    [tS2, RS2, State, RH2] = GetStageTwo(LambdaA, Gamma, SigmaH, SigmaN, RS1, tS1);
end

%% Stage Three

% In this stage, there will be three regions within the tomour: One
% necrotic region at the core, a quiescent region surrounding the core and
% an outer rim of proliferating cells

%Maximum Time
T = 10;

%Initialise timestep
DeltaT = 0.1;

if State == 0
    [tS3, RS3] = GetStageThree(LambdaA, LambdaN, SigmaH, SigmaN, Gamma, RS1, tS1, tS2, RS2, DeltaT, T, RH2);
end



    
        
