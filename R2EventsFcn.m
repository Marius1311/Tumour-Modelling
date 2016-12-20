function [position,isterminal,direction] = R2EventsFcn(t,R, Gamma, SigmaN)
%Events function for the termination of stage two
position = R - sqrt(6/Gamma*(1-SigmaN)); % The value that we want to be zero
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end
