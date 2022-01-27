clear all;
close all;
% dbstop if error;

%%
addpath(genpath('helperFunctions'));
addpath(strjoin(genpath_exclude("filters",{'verifications'}),''));
% addpath("/home/hakcar/phd/ZUPT-aided-INS/src/")