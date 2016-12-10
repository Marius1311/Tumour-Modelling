function [ Light, L ] = SetLight( t, w )
%This function determines whether the light is red or green

        i = floor(t/w); % Which stoplight cycle are we in? i starts with zero.
        %Even values of i correspond to green, odd ones to red
        if round(i/2) == i/2
            Light = 1; % Green light (even)
            L = 'green';
        else
            Light = 0; %Red light (odd)
            L = 'red';
        end
end

