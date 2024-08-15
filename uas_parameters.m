
%% INITIALIZATION

clear
close all
clc
addpath('maze\')
addpath('exercise_4_files\')
%% Map 3d 
maze_1_3D;

start_3d =[0 0 1] + 1;
finish_3d= [9 9 1] + 1;

route = greedy_3d(rot90(map,3),start_3d,finish_3d) -1     %[X, Y ,Z]

route = route_trimmer(route)



%% Position controller gains

pos_p = 1.9;
pos_i = 0;
pos_d = 0;

pos_z_p = 1;
pos_z_i = 0;
pos_z_d = 0;

vel_p = 1.6;
vel_i = 0;
vel_d = 0;

vel_z_p = 1;
vel_z_i = 0;
vel_z_d = 0;

%% Trajectory

knots = [0 5];
waypoints = cell(1,2);
waypoints{1} = [0 ; 0 ; 1];
waypoints{2} = [9 ; 9 ; 1];
% Fix this...
order = 7;
corridors.times = [1 3 5];  % Tim
% e intervals within the [0, 5] range

% Define x, y, z bounds for each segment within the maze
corridors.x_lower = [2 7 9];  % Incremental x bounds as the drone moves right
corridors.x_upper = [3 9 9.5];

corridors.y_lower = [0 0 7];  % Incremental y bounds as the drone moves upward
corridors.y_upper = [0 2 9.5];

corridors.z_lower = [0 0 0];  % Keeping z constant since it's a 2D maze at z = 1
corridors.z_upper = [2 2 2];  % Slight tolerance in z-axis
% ...until here
make_plots = true;

poly_traj = uas_minimum_snap(knots, order, waypoints, corridors, make_plots);


%% Parameters

wall_color = [0.8 0.2 0.2];
sample_time = 4e-2;
publish_rate = 1 * sample_time;
x0 = 36;
y0 = 80;
z0 = 1;
g = 9.80665 ;
mass_drone = 0.68 ;
mass_rod = 0.0;
mass_tip = 0;
mass_total = mass_drone + mass_rod + mass_tip;
stiffness_rod = 100 ;
critical_damping_rod = 2 * sqrt(mass_total * stiffness_rod) ;
stiffness_wall = 100 ;
critical_damping_wall = 2 * sqrt(mass_total * stiffness_wall) ;
inertia_xx = 0.007 ;
inertia_yy = 0.007 ;
inertia_zz = 0.012 ;
arm_length = 0.17 ;
rotor_offset_top = 0.01 ;
motor_constant = 8.54858e-06 ;
moment_constant = 0.016 ;
max_rot_velocity = 838 ;
allocation_matrix = ...
    [1 1 1 1
     0 arm_length 0 -arm_length
     -arm_length 0 arm_length 0
     -moment_constant moment_constant -moment_constant moment_constant] ;
mix_matrix = inv(motor_constant * allocation_matrix) ;
air_density = 1.2041;
drag_coefficient = 0.47;
reference_area = pi * 75e-3^2;




