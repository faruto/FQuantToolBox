%% DataResampleTestScript
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/06/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% Get Tick Data Using FQuantToolBox

StockCode = 'sz002269';

BeginDate = '20150504';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
D1 = StockTick; 

BeginDate = '20150505';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
D2 = StockTick;

BeginDate = '20150506';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
D3 = StockTick;

BeginDate = '20150507';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
D4 = StockTick;

BeginDate = '20150508';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
D5 = StockTick;


D = [D1;D2;D3;D4;D5];

% load ResampleTestData.mat

%% DataResampleClass

DResample = DataResampleClass();

%% 参数设置

        % 'DownSampling' 'UpSampling'
        DResample.DownUpSampling = 'DownSampling';
        % '1min' '5min' ...
        DResample.Fre = '1min';
        % 'SHSZ' 'CFFEX' ...
        DResample.Market = 'SHSZ';
        % 'OHLC2OHLC' 'OHLCVA2OHLCVA'
        % 'OHLCVA' 'OHLC'
        % 'first' 'last' 'median' 'max' 'min' 'sum' 'prod'
        DResample.HowMethod = 'OHLCVA';
        
        % 'ffill' 'bfill' 'nan'
        DResample.FillMethod = 'ffill';
        % 'right' 'left'
        DResample.Closed = 'right';
        % 'right' 'left'
        DResample.Label = 'right';
        % 'Datenum' 'PureDouble'
        DResample.DateFormatInput = 'PureDouble';
        % 'Datenum' 'PureDouble'
        DResample.DateFormatOutput = 'PureDouble';
        
        % 1 0 Resample后是否作图
        DResample.isPlot = 1;
        % For LabelSet函数
        DResample.LabelSetStyle = 0;
        DResample.XTRot = 55;

  
%% OneDay tick2min
DResample.Fre = '1min';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
%% OneDay 1minTo5min
DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA2OHLCVA';

OutputData3 = DResample.Resample(OutputData1);

%% OneDay tick2min

DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
%% OneDay tick2day
DResample.Fre = '1day';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);


%% MultiDay tick2min

DResample.Fre = '1min';
DResample.HowMethod = 'OHLCVA';  

InputData2 = D(:,[1 2 4 5]);

OutputData2 = DResample.Resample(InputData2);
%% MultiDay 1minTo5min
DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA2OHLCVA';
OutputData4 = DResample.Resample(OutputData2);
%% MultiDay tick2day
DResample.Fre = '1day';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
%% Get Index Data Using FQuantToolBox

StockCode = '000001';
% StockCode = '000300';

BeginDate = '20100101';

EndDate = datestr(today,'yyyy-mm-dd');

[Data] = GetIndexTSDay_Web(StockCode,BeginDate,EndDate);

DateTemp = Data(:,1)*1e4+1500*ones(length(Data),1);
InputData =[DateTemp,Data(:,2:end)]; 


%% dayToday

DResample.Fre = '3day';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);

%% dayToweek

DResample.Fre = '1week';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);


%% dayTomonth

DResample.Fre = '1month';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);

%% dayToquarter

DResample.Fre = '1quarter';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);
%% dayToyear

DResample.Fre = '1year';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);

%%




%% Record Time
toc;
displayEndOfDemoMessage(mfilename);
