%% Main_GetFuturesDataTest
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% 获取期货各机构持仓数据-IF
tic

DateStr = '20150518';
Futurecode = 'tf';
Futurecode = 'if';

[DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, Futurecode);

toc
%% 获取期货各机构持仓数据-TF
tic

DateStr = '20141215';
Futurecode = 'tf';

[DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, Futurecode);

toc 
%% 获取期货某交易所某日数据-中金所-IF
DateStr = '20141216';
MarketCode = 'CFFEX';
FuturesCode = 'IF';
[DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);
%% 获取期货某交易所某日数据-中金所-TF
DateStr = '20141216';
MarketCode = 'CFFEX';
FuturesCode = 'TF';
[DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);

%%











%% Record Time
toc;
displayEndOfDemoMessage(mfilename);