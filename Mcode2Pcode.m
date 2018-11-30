%% Mcode2Pcode
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01

%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% All

fun = fullfile('*.m');

pcode(fun);

%% Ñ¡¶¨

pcode('GetStockReport_Web.m');

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);