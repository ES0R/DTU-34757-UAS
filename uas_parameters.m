
%% INITIALIZATION

clear
close all
clc

%% SIMULATION PARAMETERS


%% Map 3d 
maze_1_3D;



%Map 2d

map_2d = [0 0 0 0 0 0 0 0 0 0;
       0 1 0 1 1 1 1 1 1 0;
       1 1 0 1 1 0 0 0 1 0;
       0 0 0 0 1 0 1 0 1 0;
       0 1 1 0 0 0 1 0 0 0;
       0 0 1 1 1 1 1 1 1 0;
       1 0 0 0 1 0 0 0 1 0;
       1 1 1 0 0 0 1 0 1 0;
       1 1 1 1 1 1 1 0 1 0;
       0 0 0 0 0 0 0 0 0 0];

%rot90(map,3)

start_3d =[1 1 2]
finish_3d= [4 6 2]

start_2d = [0 0 ]
finish_2d =[9 9 ]
route_2d =greedy_2d(map_2d,start_2d,finish_2d);
route_3d =greedy_3d(map,start_3d,finish_3d);



%route_temp = transpose(rot90(route_3d,1))-1;

%X = route_temp(:,2);
%Y = route_temp(:,3);
%Z = route_temp(:,1);

route = greedy_3d(rot90(map,3),start_3d,finish_3d) -1     %[X, Y ,Z]
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

%% Exercise 6.2

pos_p = 1.8;
pos_i = 0;
pos_d = 0;

pos_z_p = 1;
pos_z_i = 0;
pos_z_d = 0;

vel_p = 4;
vel_i = 0;
vel_d = 0;

vel_z_p = 1;
vel_z_i = 0;
vel_z_d = 0;


