%% Main_GetStockDataTest
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% 获取股票代码列表测试

[StockList,StockListFull] = GetStockList_Web;
StockCodeDouble = cell2mat( StockList(:,3) );
save('StockList','StockList');

%% 获取指数代码列表

[IndexList] = GetIndexList_Web;

save('IndexList','IndexList');
%% 指数参数设置

IndexCode_G = '000001'

str = ['全局指数参数设置完毕！'];
disp(str);
%% 股票参数设置
StockCode_G = '000562'

str = ['全局股票参数设置完毕！'];
disp(str);
%% 获取指数数据

StockCode = '000001';
StockCode = '000300';

BeginDate = '20140101';

EndDate = datestr(today,'yyyy-mm-dd');

[Data] = GetIndexTSDay_Web(StockCode,BeginDate,EndDate);
%% GetStockInfo_Web
% 获取股票基本信息以及所属行业板块（证监会行业分类）和所属概念板块（新浪财经定义）

StockCode = '600588';
StockCode = '600000';
StockCode = 'sh600012';
StockCode = 'sz000981';

[StockInfo] = GetStockInfo_Web(StockCode);
%% BaiduSearchAdvancedNews
StockCode = '600588';

BeginDate = '20141226';

EndDate = datestr(today,'yyyy-mm-dd');

StringIncludeAny = [];
[NewsDataCell] = BaiduSearchAdvancedNews(StockCode,StringIncludeAny,BeginDate,EndDate);
%% BaiduSearchAdvancedNews Word Test
StringIncludeAll = '习近平';

BeginDate = '20141226';

EndDate = datestr(today,'yyyy-mm-dd');

StringIncludeAny = [];
[NewsDataCell] = BaiduSearchAdvancedNews(StringIncludeAll,StringIncludeAny,BeginDate,EndDate);
%% SinaSearchAdvanced
StringIncludeAll = '600588';

BeginDate = '20141201';

EndDate = datestr(today,'yyyy-mm-dd');

[NewsDataCell] = SinaSearchAdvanced(StringIncludeAll,BeginDate,EndDate);
%% GetStockNotice_Web
tic;
StockCode = '600588';

BeginDate = '20141001';

EndDate = datestr(today,'yyyy-mm-dd');

[NoticeDataCell] = GetStockNotice_Web(StockCode,BeginDate,EndDate);
toc;
%% GetStockInvestRInfo_Web
tic;

StockCode = '000001';

BeginDate = '20101001';

EndDate = datestr(today,'yyyy-mm-dd');

[IRDataCell] = GetStockInvestRInfo_Web(StockCode,BeginDate,EndDate);
toc;
%% 获取股票某日交易明细

StockCode = 'sh600000';
StockCode = 'sh600588';
StockCode = StockCode_G;

BeginDate = '20141205';
[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);

%% 获取股票日线（除权除息）数据测试

StockCode = 'sh600030';
StockCode = 'sh600000';
StockCode = StockCode_G;

BeginDate = '20130101';
EndDate = '20150101';

[StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);

%% 股票日线（除权除息） plot
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);

AX1 = subplot(3,1,1:2);
OHLC = StockDataDouble(:,2:5);
KplotNew(OHLC);
Dates = StockDataDouble(:,1);
LabelSet(gca, Dates, [], [], 2);

if StockCode(1,1) == 's'
    StockCode = StockCode(3:end);
end
ind = find( StockCodeDouble == str2double(StockCode) );
str = [StockList{ind,1},'-',StockList{ind,2},'除权价格'];
title(str,'FontWeight','Bold');

AX2 = subplot(3,1,3);
V = StockDataDouble(:,6);
bar(V);
xlim([0,length(V)]);
LabelSet(gca, Dates, [], [], 2);

linkaxes([AX1, AX2], 'x');
%% 获取股票除权除息数据
StockCodeInput = '600537';
StockCodeInput = '600001';

StockCodeInput = StockCode_G;

[ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = GetStockXRD_Web(StockCodeInput);
Web_XRD_Cell_1;
Web_XRD_Cell_2;

%% 进行前复权数据生成

StockData = StockDataDouble(:,1:end);
XRD_Data = [];
AdjFlag = 1;
[StockDataXRD, factor] = CalculateStockXRD(StockData, XRD_Data, AdjFlag);

%% 复权价格plot
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);

AX1 = subplot(211);
OHLC = StockDataDouble(:,2:5);
KplotNew(OHLC);
Dates = StockDataDouble(:,1);
LabelSet(gca, Dates, [], [], 1);
ind = find( StockCodeDouble == str2double(StockCode) );
str = [StockList{ind,1},'-',StockList{ind,2},'除权价格'];
title(str,'FontWeight','Bold');

AX2 = subplot(212);
OHLC = StockDataXRD(:,2:5);
KplotNew(OHLC);
Dates = StockDataDouble(:,1);
LabelSet(gca, Dates, [], [], 1);
ind = find( StockCodeDouble == str2double(StockCode) );
str = [StockList{ind,1},'-',StockList{ind,2},'前复权价格'];
title(str,'FontWeight','Bold');

linkaxes([AX1, AX2], 'x');
%% 获取股票财务指标测试

StockCodeInput = '600588';
StockCodeInput = StockCode_G;

Year = '2014';
[FIndCell,YearList] = GetStockFinIndicators_Web(StockCodeInput,Year);
FIndCell
%% 获取三张表

StockCodeInput = '600588';
StockCodeInput = StockCode_G;

Year = '2014';
[BalanceSheet,ProfitSheet,CashFlowSheet,YearList] = GetStock3Sheet_Web(StockCodeInput,Year);
BalanceSheet
ProfitSheet
CashFlowSheet

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);