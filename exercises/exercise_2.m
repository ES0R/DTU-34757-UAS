clear; clc;
%% Parameters and Initial Conditions
OMEGA = [10000; 10000; 10000; 10000];  % Motor speeds
p = parameters();

% Plot parameters
lim = 1;

% Simulation parameters
running_time = 1;  % Total simulation time
samp_time = 1e-3;  % Time step

% Initialize state vectors for logging
ORIENTATION_nonlinear = p.ORIENTATION_nonlinear;
POSITION_nonlinear = p.POSITION_nonlinear;
ORIENTATION_linear = p.ORIENTATION_linear;
POSITION_linear = p.POSITION_linear;

% Initialize state vectors
w = p.w;
dp = p.dp;
pos = p.pos;
Euler = p.Euler;

% Equilibrium motor speed
Omega_eq = sqrt(p.m * norm(p.g) / (4 * p.k));

% Initialize linear state vector and matrices
x_linear = zeros(12, 1);

%A, B = computeStateSpaceMatrices(p)

iter = round(running_time / samp_time);
for i = 1:iter
    % Non-linear dynamics
    [pos, dp, Euler, w] = dronedynamics_nonlinear(pos, dp, Euler, w, OMEGA, p, samp_time);
    
    % Linear dynamics
    %[x_linear, A, B] = dronedynamics_linear(x_linear, OMEGA, p, Omega_eq, samp_time);
    
    % Logging for non-linear model
    POSITION_nonlinear = [POSITION_nonlinear, pos];
    ORIENTATION_nonlinear = [ORIENTATION_nonlinear, Euler];
   
end

% Plot results for non-linear model
figure;
subplot(2, 1, 1);
plot3(ORIENTATION_nonlinear(1, :), ORIENTATION_nonlinear(2, :), ORIENTATION_nonlinear(3, :));
xlabel('w_x');
ylabel('w_y');
zlabel('w_z');
xlim([0, 2 * pi]);
ylim([0, 2 * pi]);
zlim([0, 2 * pi]);
title("Non-linear Model Orientation");
grid on;

subplot(2, 1, 2);
plot3(POSITION_nonlinear(1, :), POSITION_nonlinear(2, :), POSITION_nonlinear(3, :));
xlabel('x');
ylabel('y');
zlabel('z');
xlim([-lim, lim]);
ylim([-lim, lim]);
zlim([-lim, lim]);
grid on;
title("Non-linear Model Position");



figure;
subplot(2, 1, 1);
plot([0:iter] * samp_time, ORIENTATION_nonlinear(1, :));
hold on;
plot([0:iter] * samp_time, ORIENTATION_nonlinear(2, :));
hold on;
plot([0:iter] * samp_time, ORIENTATION_nonlinear(3, :));
xlabel('time/s');
ylabel('radian');
legend('phi', 'theta', 'psi');
ylim([-pi, pi]);
title("Non-linear Model Orientation");

subplot(2, 1, 2);
plot([0:iter] * samp_time, POSITION_nonlinear(1, :));
hold on;
plot([0:iter] * samp_time, POSITION_nonlinear(2, :));
hold on;
plot([0:iter] * samp_time, POSITION_nonlinear(3, :));
xlabel('time/s');
ylabel('meter');
legend('x', 'y', 'z');
title("Non-linear Model Position");



