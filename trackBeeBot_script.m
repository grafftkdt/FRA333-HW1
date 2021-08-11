%{
 NAME           : trackBeeBot_script
 AUTHOR         : Thanacha Choopojcharoen
 DATE           : August 11th 2021
 MODIFIED BY    : -
 DESCRIPTION    : An example of how to use trackBeeBot() and plot_trackBeeBot()
%}

clear;
load('testcase_without_wall');
%[A,P] = trackBeeBot(a_i,c,O);
plot_trackBeeBot(A,O)    

clear;
load('testcase_with_wall');
%[A,P] = trackBeeBot(a_i,c,O);
plot_trackBeeBot(A,O)    
