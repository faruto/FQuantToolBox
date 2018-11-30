%% fGetRTQuotesTestScript
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

GetRTQuotes = fGetRTQuotes();

GetRTQuotes.Code = {'600036';'M0';'IF1506';'150197';'TA0';'RB0';'510050'};

DataCell = GetRTQuotes.GetRTQuotes();

%%

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);
