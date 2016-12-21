function [position,isterminal,direction] = R1EventsFcn_2(t,R, Gamma, SigmaH)
%Events function for the termination of stage one
position = R - sqrt(6/Gamma*(1-SigmaH)); % The value that we want to be zero
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end
