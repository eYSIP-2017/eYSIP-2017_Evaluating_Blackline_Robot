%% Clear
clc;clear;

%% Create GUI
cell_list = {};
fig_number = 1;
title_figure = 'Comparator - Select mode';
cell_list{1,1} = {'Generate Path','generatePath_gui;'};
cell_list{2,1} = {'Run Simulation','runSimulation;'};
cell_list{3,1} = {'Compare','main;'};
cell_list{4,1} ={'Exit',['disp(''Bye. To run again, type sim_gui.''); close(' num2str(fig_number) ');']};

%% Show GUI
show_window(cell_list,fig_number,title_figure,250,20,0,'clean',12);