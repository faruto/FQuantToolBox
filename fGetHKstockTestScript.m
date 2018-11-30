%% fGetHKstockTestScript
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

GetHKstock = fGetHKstock();

        GetHKstock.Code = '00700';
        
        GetHKstock.StartDate = 'All';
        GetHKstock.EndDate = datestr(today,'yyyymmdd');
        
        GetHKstock.isSave = 1;
        GetHKstock.isPlot = 1;
%% 
tic;
OutputData = GetHKstock.GetList();
toc;

%% 

GetHKstock.StartDate = '20150101';
GetHKstock.EndDate = datestr(today,'yyyymmdd');
% GetHKstock.EndDate = '20150501';

tic;

[OutputData,Headers] = GetHKstock.GetPrice();

toc;
%% 

[OutputData] = GetHKstock.GetProfile();
%% 

[OutputData] = GetHKstock.GetDividends();


%%

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);
