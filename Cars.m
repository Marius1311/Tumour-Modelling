%% Finding the optimal stoplight frequency

% This is an agent based model of cars driving around in a circle with one
% red stop light at Theta = 0. The cars have to sopt there when it is red,
% otherwise they can go. If the cars are not stationary, they are going at
% the speed limit. If a car is stationary at the stop light and the car in
% front starts moving, it has to wait for some time until it can start,
% which is supossed to model reaction time. The aim here is to find the
% optimal frequency omega such that the cars travel the biggest distance in
% a given time.

%At time t=0, all the cars will be stationary at theta = 0 and the stop
%light will turn from red to green.

%% Definitions

% We will start out by defining a lot of stuff:
N = 10; % Number of Cars
Theta = zeros(N, 1); % Position (Angle) of the cars
vMax = 1; % Speed limit as angular velocity (rad/sec)
R = 2; %Radius of the circle.
Delay = 0.5; %Delay Time in seconds
tMax = 20; %Total time it runs
DeltaT = 0.01; % This is how we will discretize time
M = tMax/DeltaT; %Mesh points
Range = linspace(1, 40, 40); % Range of stoplight frequencies
D = zeros(length(Range), 1); % In here, the total disctance of all the cars will stored (as a function of w)
t = 0; %Time
Light = 1; % The light is green to start with. 1 is green, 0 is red.


%% Main Loop, get everybody moving!

PlotCars = 0; % If this is 1 then you will see the cars moving around. 

k = 1;
for w = Range % Loop over stoplight frequencies
    if PlotCars == 1
    hFig = figure(1);
    set(hFig, 'Position', [100 100 500 500]);
    end
    Theta = [zeros(N, 1)];
    for m = 1:M % Loop over time
        t = m*DeltaT; %This is the current time
        [Light, L] = SetLight(t, w); %Determine whether the light is red or green
        Theta = GetTheta(Theta, Light, DeltaT, vMax, Delay); % Update the angles
        if PlotCars == 1
        PlotTheta( Theta, t, L, R, w, Delay );
        pause(0.006);
        end
    end
    D(k) = sum(Theta);
    k = k+1;
end

%% Plot the results

plot(Range, D, 'rx-'), xlabel('T/2 Half Period of the Light'), ylabel('Total Distance'), title('Frequencies vs. Total Distance');
shg;
% There are local and global optima which is nice. Also, if omega becomes
% greater than TMax the distance is constant, as expected.






