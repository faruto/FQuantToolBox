%% Main_SaveFuturesData2Local
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

DateList = [];
FutureCode = 'if';
UpdateFlag = 1;
[SaveLog,IF_DateListOut,ProbList,NewList] = SaveFuturesVolOIRankingData(FutureCode,DateList,UpdateFlag);

%% 获取期货各机构持仓数据-TF
DateList = [];
FutureCode = 'tf';
UpdateFlag = 1;

[SaveLog,TF_DateListOut,ProbList,NewList] = SaveFuturesVolOIRankingData(FutureCode,DateList,UpdateFlag);
%% 获取期货日线数据-IF
MarketCode = 'CFFEX';
FutureCode = 'IF';
DateList = [];
[SaveLog,ProbList,NewList] = SaveFuturesDay(MarketCode,FutureCode,DateList);

%% 获取期货日线数据-TF
MarketCode = 'CFFEX';
FutureCode = 'TF';
DateList = [];

[SaveLog,ProbList,NewList] = SaveFuturesDay(MarketCode,FutureCode,DateList);

%%











%% Record Time
toc;
displayEndOfDemoMessage(mfilename);