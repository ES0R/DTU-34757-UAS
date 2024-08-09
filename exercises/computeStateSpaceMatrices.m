function [A, B] = computeStateSpaceMatrices(p)
    % Define symbolic variables
    syms x y z dx dy dz phi theta psi dphi dtheta dpsi Omega1 Omega2 Omega3 Omega4 real

    % Define state and input vectors
    X = [x; y; z; dx; dy; dz; phi; theta; psi; dphi; dtheta; dpsi];
    U = [Omega1; Omega2; Omega3; Omega4];

    % Equilibrium values
    Xe = zeros(12, 1);
    Omega_eq = sqrt(p.m * norm(p.g) / (4 * p.k));
    Ue = [Omega_eq; Omega_eq; Omega_eq; Omega_eq];

    % Define the drone dynamics
    R = rotz(rad2deg(psi)) * roty(rad2deg(theta)) * rotx(rad2deg(phi));
    thrust = [0; 0; p.k * sum(U)];
    ddp = (p.m * p.g + R * thrust - p.D * [dx; dy; dz]) / p.m;
    tau = [p.k * (U(1)^2 - U(3)^2) * p.L;
           p.k * (U(2)^2 - U(4)^2) * p.L;
           p.b * (U(1)^2 - U(2)^2 + U(3)^2 - U(4)^2)];
    dw = pinv(p.I) * (tau - cross([dphi; dtheta; dpsi], p.I * [dphi; dtheta; dpsi]));

    % Define the equations of motion
    f = [dx; dy; dz; ddp; dphi; dtheta; dpsi; dw];

    % Compute Jacobians
    A = jacobian(f, X);
    B = jacobian(f, U);

    % Evaluate at equilibrium
    A = double(subs(A, [X, U], [Xe; Ue]));
    B = double(subs(B, [X, U], [Xe; Ue]));
end