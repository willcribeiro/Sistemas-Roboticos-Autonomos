function [X, Y, Theta, a, b, Mat] = poli_cubic(qi,qf,p)
    dx = qf(1) - qi(1);
    dy = qf(2) - qi(2);
    theta_i = (qi(3)*pi)/180;
    theta_f = (qf(3)*pi)/180;
    alf_i = tan(theta_i);
    alf_f = tan(theta_f);
    if(((theta_i > 89) & (theta_i < 91)) & ((theta_f > 89) & (theta_f < 91)))
        a0 = qi(1);
        a1 = 0;
        a2 = 3*dx;
        a3 = -2*dx;
        b0 = qi(2);
        b1 = dy;
        b2 = 0;
        b3 = dy - b1 - b2;
    elseif((theta_i > 89) & (theta_i < 91))
        a0 = qi(1);
        a1 = 0;
        a3 = -dx/2;
        a2 = dx - a3;
        b0 = qi(2);
        b2 = 1; %% Qualquer valor
        b1 = 2*(dy - alf_f*dx) - alf_f*a3 + b2;
        b3 = (2*alf_f*dx-dy) + alf_f*a3 - 2*b2;        
    elseif ((theta_f > 89) & (theta_f < 91))
        a0 = qi(1);
        a1 = 3*dx/2;
        a2 = 3*dx - 2*a1;
        a3 = a1 - 2*dx;
        b0 = qi(2);
        b1 = alf_i*a1;
        b2 = 1; %% Qualquer valor
        b3 = dy - alf_i*a1 - b2;
    else
        a0 = qi(1);
        a1 = dx;
        a2 = 0;
        a3 = dx - a1 - a2;
        b0 = qi(2);
        b1 = alf_i*a1;
        b2 = 3*(dy - alf_f*dx) + 2*(alf_f - alf_i)*a1 + alf_f*a2;
        b3 = 3*alf_f*dx - 2*dy - (2*alf_f - alf_i)*a1 - alf_f*a2;
    end
    a = [a0, a1, a2, a3];
    b = [b0, b1, b2, b3];
    lambda = 0:p:1;
    X = a0 + a1*lambda + a2*(lambda.^2) + a3*(lambda.^3);
    Y = b0 + b1*lambda + b2*(lambda.^2) + b3*(lambda.^3);
    Theta = atan((a1 + a2*(lambda) + a3*(lambda.^2))./(b1 + b2*(lambda) + b3*(lambda.^2)))*180/pi;
    
    Z = ones(101,1)*0.05;
    Mat = [X' Y' Z];
    csvwrite('file.csv',Mat)
    figure(1)
    plot(X,Y)
    grid on;
    ylabel('Y (Lambda)')
    xlabel('X (Lambda)')
end
