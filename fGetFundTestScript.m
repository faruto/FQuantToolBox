%% fGetFundTestScript
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

GetFund = fGetFund();

        GetFund.Code = '510050';
        
        GetFund.StartDate = 'All';
        GetFund.StartDate = '20150101';
        GetFund.EndDate = datestr(today,'yyyymmdd');
        
        GetFund.isSave = 0;

%%
tic;

[OutputData,Headers] = GetFund.GetNetValue();

toc;
%%
tic;

[OutputData] = GetFund.GetFundProfile();

toc;
%%
tic;

        GetFund.StartDate = 'All';
%         GetFund.StartDate = '20150101';
        GetFund.EndDate = datestr(today,'yyyymmdd');

[OutputData,Headers] = GetFund.GetFundShareChg();

toc;
%% 




%% Record Time
toc;
displayEndOfDemoMessage(mfilename);
