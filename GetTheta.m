function [ Theta ] = GetTheta(Theta, Light, DeltaT, vMax, Delay )
%This function updates the angle for each car. Either, they are moved
%foreward or they have to wait! The first car is treated seperately because
%the car in front of it is car number N and that is a bit clumsy to handle

N = length(Theta);
% Okay, lets start with the first car. There are three things that can
% cause the car to stop (that holds for all cars, not only the first one).
% The light can be red, I can be waiting behind someone, or the light is
% grean and there in no one in front but I have to wait because of my "reaction time"
j = 1;
if (Light == 0 &&  (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0 ))... % Red Light
        || (  (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0)...
        && (2*pi - mod(Theta(end), 2*pi) < DeltaT*vMax || Theta(end) == 0) && Theta(j) > Theta(end) )... % Car in Front
        || ((   (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0)...
        && mod(Theta(end), 2*pi) < (DeltaT*vMax + Delay*vMax) ) && Theta(j) > Theta(end) ) % Delay Time
        Theta(j) = Theta(j);
%     if Theta(j) ~= 0
%         Theta(j) = Theta(j) + 2*pi - mod(Theta(j), 2*pi);
%     else
%         Theta(j) = Theta(j);
%     end % Don't move
    
else
    Theta(j) = Theta(j) + vMax*DeltaT; %move
end

% So, now we do almost the same for all the other guys.
for j = 2:N % We have to treat the first car seperately
    if (Light == 0 &&  (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0 ))... % Red Light
            || (  (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0)...
            && (2*pi - mod(Theta(j-1), 2*pi) < DeltaT*vMax || Theta(j-1) == 0) && Theta(j) >= Theta(j-1) )... % Car in Front
            || ((   (2*pi - mod(Theta(j), 2*pi) < DeltaT*vMax || Theta(j) == 0)...
            && mod(Theta(j-1), 2*pi) < (DeltaT*vMax + Delay*vMax) ) ) % Delay Time
        Theta(j) = Theta(j);
%         if Theta(j) ~= 0
%             Theta(j) = Theta(j) + 2*pi - mod(Theta(j), 2*pi);
%         else
%             Theta(j) = Theta(j);
%         end
        
    else
        Theta(j) = Theta(j) + vMax*DeltaT;
    end
end

end

