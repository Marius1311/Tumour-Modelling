function [ ] = PlotTheta( Theta, t, L, R, w, Delay )
%This function Plots a circle and then adds little crosses for the cars.
%All the crosses have the same color which is not very nice. Also, the
%circle is plotted again every single time which is rather unnecessary.

        angle = linspace(0, 2*pi);
        x = R*cos(angle);
        y = R*sin(angle);
        X = R .* cos(Theta);
        Y = R .* sin(Theta);
        plot(X, Y, 'bx', x, y, 'r-'), title({'Time: ', num2str(t), ' Light: ', L, ' w = ' num2str(w), ' Delay:' num2str(Delay)});

end

