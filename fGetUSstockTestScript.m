%% fGetUSstockTestScript
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

GetUSstock = fGetUSstock();

GetUSstock.Code = 'AAPL';
% GetUSstock.Code = 'MSFT';
% GetUSstock.Code = 'IXIC';

GetUSstock.StartDate = 'All';
GetUSstock.StartDate = '20150101';
GetUSstock.EndDate = datestr(today,'yyyymmdd');

GetUSstock.ListSource = 'sina';
GetUSstock.ListSource = 'ifeng';

GetUSstock.isSave = 1;
GetUSstock.isPlot = 1;
GetUSstock.isTicToc = 1;
%%

GetUSstock.StartDate = '20140101';
[OutputData,Headers] = GetUSstock.GetHistQuote();
Headers
%%
tic;
OutputData = GetUSstock.GetList();
toc;
%%

[OutputData,Headers] = GetUSstock.GetDividends();
Headers

%% 
%% Record Time
toc;
displayEndOfDemoMessage(mfilename);
