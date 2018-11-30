%% fGetFutruesTestScript
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/06/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%%

GetFutrues = fGetFutrues();
GetFutrues.isPlot = 1;
GetFutrues.isSave = 0;
GetFutrues.isTicToc = 1;

%% 


OutputData = GetFutrues.GetHotMonth();


%%

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);