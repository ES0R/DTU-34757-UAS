function [pos, dp, Euler, w] = dronedynamics(pos, dp, Euler, w, OMEGA, p, samp_time)
    % Calculate the rotation matrix from Euler angles
    R = rotz(rad2deg(Euler(3))) * roty(rad2deg(Euler(2))) * rotx(rad2deg(Euler(1)));
    
    % Linear acceleration calculation
    thrust = [0; 0; sum(p.b*OMEGA)];
    ddp = (p.m * p.g + R * thrust - p.D * dp) / p.m;
    
    % Torque calculation
    tau = [p.k * (OMEGA(1)^2 - OMEGA(3)^2) * p.L;
           p.k * (OMEGA(2)^2 - OMEGA(4)^2) * p.L;
           p.b * (OMEGA(1)^2 - OMEGA(2)^2 + OMEGA(3)^2 - OMEGA(4)^2)];
    
    % Angular acceleration calculation
    dw = pinv(p.I) * (tau - cross(w, p.I * w));
    
    % Motion update: position and velocity
    pos = pos + dp * samp_time + 0.5 * ddp * samp_time^2;  % Update position
    dp = dp + ddp * samp_time;  % Update velocity
    
    % Orientation update: Euler angles
    w = w + dw * samp_time;  % Update angular velocity
    dEuler = [1, sin(Euler(1)) * tan(Euler(2)), cos(Euler(1)) * tan(Euler(2));
              0, cos(Euler(1)), -sin(Euler(1));
              0, sin(Euler(1)) / cos(Euler(2)), cos(Euler(1)) / cos(Euler(2))] * w;
    Euler = Euler + dEuler * samp_time;  % Update Euler angles
    % Ensure Euler angles wrap correctly within [-pi, pi]
    Euler(1) = wrapToPi(Euler(1));
    Euler(2) = wrapToPi(Euler(2));
    Euler(3) = wrapToPi(Euler(3));
end