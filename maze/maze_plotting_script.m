
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
end_ = [2,1,2]

%start = [0, 0];
%end_ = [5,0];

fig_num = 1;


plot_map(map, fig_num);
plot_start_stop(start, end_, fig_num)



route = greedy_3d(map,start,end_)

plot_route(route, fig_num);
