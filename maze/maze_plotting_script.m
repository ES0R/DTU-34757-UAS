

% This file contains parameters and calculations needed for running
% MatLab with rotorS ROS package for interfacing with a position controlled
% drone

%%
clc;
close all;
clear all;

%%

maze_1_3D;

start  =[1 1 2]
end_ = [4,6,2]

%start = [1, 1];
%end_ = [6,1];

fig_num = 1;


plot_map(map, fig_num);
plot_start_stop(start-1, end_-1, fig_num)

map = rot90(map,3)

route = greedy_3d(map,start,end_)

plot_route(route, fig_num);

