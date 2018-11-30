%% fGetIndexTestScript
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/06/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% 50 
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '000016';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 300
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '000300';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 500
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '000905';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 中证1000
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '000852';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 中小板指
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399005';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 创业板指
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399006';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% i100
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399415';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% i300
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399416';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;
%% 399354
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399354';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;

%%
%% Record Time
toc;
displayEndOfDemoMessage(mfilename);