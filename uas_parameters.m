
%% INITIALIZATION

clear
close all
clc
addpath('maze\')
addpath('exercise_4_files\')
%% Map 3d
maze_1_3D;

start_3d =[0 0 1] + 1;
finish_3d= [9 0 1] + 1;

route = greedy_3d(rot90(map,3),start_3d,finish_3d) -1;     %[X, Y ,Z]

route = route_trimmer(route);



%% Position controller gains

pos_p = 1.9;
pos_i = 0;
pos_d = 0;

pos_z_p = 1.9;
pos_z_i = 0;
pos_z_d = 0;

vel_p = 1.9;
vel_i = 0;
vel_d = 0;

vel_z_p = 1.9;
vel_z_i = 0;
vel_z_d = 0;

%% Trajectory

knots = [0 5];
waypoints = cell(1,2);
waypoints{1} = [0 ; 0 ; 1];
waypoints{2} = [9 ; 9 ; 1];
% Fix this...
order = 7;
corridors.times = [2 3 4.6];  % Tim
% e intervals within the [0, 5] range

% Define x, y, z bounds for each segment within the maze
corridors.x_lower = [5.5 8.8 8.8];  % Incremental x bounds as the drone moves right
corridors.x_upper = [8 9 9];

corridors.y_lower = [-0.5 1 8.8];  % Incremental y bounds as the drone moves upward
corridors.y_upper = [0 2 9];

corridors.z_lower = [0 0 0];  % Keeping z constant since it's a 2D maze at z = 1
corridors.z_upper = [2 2 2];  % Slight tolerance in z-axis
% ...until here
make_plots = false;

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



%% Simulate

pos_p = 1;
vel_p = 1;

simulate = true;

routes = {
    [0 0 1; 1 0 1], 
    [0 0 1; 3 0 1], 
    [0 0 1; 9 0 1]
};

if simulate
    open_system('uas_main');
    
    for route_idx = 1:length(routes)
        % Set the current route
        route = routes{route_idx};
        fprintf('Simulating for route %d...\n', route_idx);
        
        % Initialize results storage for each route
        results = struct('pos_p', [], 'vel_p', [], 'rise_time', [], 'settling_time', [], 'overshoot', [], 'undershoot', [], 'peaktime', []);
        
        pos_p_range = 1:0.1:5;  % Example range for position gain
        vel_p_range = 1:0.1:5;  % Example range for velocity gain

        total_iterations = length(pos_p_range) * length(vel_p_range);
        current_iteration = 0;

        % Loop through the gain values
        for i_pos_p = pos_p_range
            for i_vel_p = vel_p_range
                current_iteration = current_iteration + 1;

                % Calculate the percentage of completion
                percent_complete = (current_iteration / total_iterations) * 100;
                fprintf("Position gain: %.2f, Velocity gain: %.2f, Completion: %.2f%%\n", i_pos_p, i_vel_p, percent_complete);
                
                % Set the current gains
                pos_p = i_pos_p;
                vel_p = i_vel_p;
                
                % Simulate the system with the current route
                simOut = sim('uas_main', 'ReturnWorkspaceOutputs', 'on');

                % Extract position signal
                position_signal = simOut.logsout.getElement('drone_pos').Values;

                % Analyze step response
                step_response = analyze_step_response(position_signal);

                % Save the results
                results.pos_p = [results.pos_p; pos_p];
                results.vel_p = [results.vel_p; vel_p];
                results.rise_time = [results.rise_time; step_response.RiseTime];
                results.settling_time = [results.settling_time; step_response.SettlingTime];
                results.overshoot = [results.overshoot; step_response.Overshoot];
                results.undershoot = [results.undershoot; step_response.Undershoot];
                results.peaktime = [results.peaktime; step_response.PeakTime];
            end
        end

        % Convert the results to a table for easier analysis
        results_table = struct2table(results);

        % Filter results for 1% overshoot max
        zero_overshoot_results = results_table(results_table.overshoot <= 1, :);

        % Sort the filtered results by settling time in ascending order
        sorted_results = sortrows(zero_overshoot_results, 'peaktime');

        % Display the sorted results
        disp(sorted_results);
        
        % Save the sorted results to a file named based on the route
        save_filename = sprintf('sorted_results_%d.mat', route(end,1)); % The end,1 gets the last x-coordinate in the route
        save(save_filename, 'sorted_results');
    end
end
