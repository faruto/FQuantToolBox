%% FQuantToolBoxHelpOnLine
% FQuantToolBox: A Data and Backtesting Quant Tool Box based on MATLAB by faruto.
% 
% by LiYang_faruto @ <http://www.matlabsky.com MATLAB技术论坛> <http://faruto.matlabsky.com FQuantStudio> 
%
% Email:farutoliyang@foxmail.com 
% 
% Version: V1.4
%
% Last Modified 2015.06.01
% 
% History:
% 
% * V1.4-2015.06.01(新发布版本)
% * V1.3-2015.01.24
% * V1.2-2015.01.01
% * V1.1-2014.12.18
% * V1.0-2014.12.12
%
% <html>
% <table border="0" width="600px" id="table1">	
% <tr><td><b><font size="2">本Demo为FQuantToolBox的函数测试帮助文档</font></b></td></tr>	
% <tr><td><span class="tip"><font size="2">FQuantToolBox最新版下载地址：<a target="_blank" href="http://pan.baidu.com/s/1gdIiccN"><font color="#0000FF">百度网盘</font></a></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">FQuantToolBox使用交流讨论论坛：<a target="_blank" href="http://www.matlabsky.com/forum-112-1.html"><font color="#0000FF">MATLAB技术论坛</font></a></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">FQuantToolBox使用交流讨论QQ群：QuantGroup1群[MATLAB] 279908629</font></span></td></tr> 	
% <tr><td><span class="tip"><font size="2">作者faruto的联系方式：<a target="_blank" href="http://weibo.com/faruto"><font color="#0000FF">微博-faruto</font></a>，<a target="_blank" href="http://blog.sina.com.cn/faruto"><font color="#0000FF">博客</font></a>，微信公众号-FQuantStudio(欢迎扫码关注)</font></span></td></tr>
% <tr><td><span class="tip"><font size="2"><img src="./FQuantStudioWeChat.jpg" width="90" height="90"></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">书籍推荐：</font></span></td></tr>
% </table>
% <img src="./QuMBook.jpg" width="300" height="400">
% <img src="./ANN.jpg" width="300" height="400">
% </html>
% 
%% FQuantToolBox是做什么用的？
%   FQuantToolBox定位是个数据和回测工具箱，没有实盘交易相关接口的实现（但未来不排除增加相关功能）。
% 
%   数据方面，FQuantToolBox数据获取函数完全基于网络的免费数据源（主要为新浪财经、雅虎财经等金融网站），不但可以积累历史数据，也可以进行动态更新，
% 现已实现的数据获取为A股市场的全部股票名称和对应代码（包含已退市股票）、A股市场的股票日线除权数据以及复权因子、A股市场的股票的除权除息信息、
% A股市场的股票每日交易明细数据（Tick数据）、A股市场的的股票财务指标数据、A股市场的股票的三张表（资产负债表、现金流量表、利润表）数据，
% 未来数据方面会增加更多的数据，包括期货数据以及其他金融标的的数据，整体的思想还是完全基于网络获取和更新，完全免费。
% 
%   基于网络的数据获取的实现方式大体过程就是网络数据网址寻找——> 网址分析——> urlread+正则表达式 数据提取。进行网络数据的抓取，正则表达式是一定会遇到的，
% MATLAB中有相应的正则表达式函数，有关正则表达式的东西这里不做展开，各位看官需要自行做些功课，FQuantToolBox工具箱的Doc文件夹内有个我重新整理过的
% 《MATALB正则表达式零基础起步教程.doc》文档，可以帮助您学习正则表达式相关的东西。
% 
%   回测方面，FQuantToolBox工具箱当下提供了一个“如何构建基于MATLAB的回测系统”的demo样例，此部分内容来自我出版的《量化投资：以MATLAB为工具》的相关章节，
% 未来回测方面会增添更多的辅助函数和插件，方便您使用MATLAB进行股票以及期货相关策略的回测。
% 
%   未来FQuantToolBox工具箱每次发布都会提供两个版本，无历史数据版本和有历史数据版本。无历史数据版本仅提供相关函数，你可以在自己本地运行相关脚本来批量获取历史数据；
% 有历史数据版本不但提供相关函数，还提供已经获取好的历史数据（A股市场全部股票股票名称和代码、日线数据、每日交易明细数据、除权除息信息、财务指标数据、三张变数据），
% 节省您获取历史数据的时间，但相应的下载文件也会比较大（尤其股票每日交易明细数据），新的数据更新只需运行相应脚本函数就可以进行全市场最新数据的更新。
%% 分类数据-全市场交易代码和对应名称（股票、指数）

% 获取A股市场的全部股票名称和对应代码（包含已退市股票）
% 函数名称：GetStockList_Web.m
% 函数作用：获取A股市场的全部股票名称和对应代码（包含已退市股票）
% 函数句柄：[StockList,StockListFull] = GetStockList_Web
% 函数说明：从http://quote.eastmoney.com/stocklist.html抓取最新的股票名称和代码列表，返回的StockList为股票名称和对应的代码
% 测试样例：
% [StockList,StockListFull] = GetStockList_Web;
% StockCodeDouble = cell2mat( StockList(:,3) );
% save('StockList','StockList');
% 运行结果：StockList如下
%%
% 
% <<F01.png>>
% 

% 获取上海证券交易所和深圳证券交易所相关指数代码和名称列表
% 函数名称：GetIndexList_Web
% 函数作用：获取上海证券交易所和深圳证券交易所相关指数代码和名称列表
% 函数句柄：[IndexList] = GetIndexList_Web
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：
% [IndexList] = GetIndexList_Web;
% save('IndexList','IndexList'); 
% 运行结果：IndexList如下
%%
% 
% <<F02.png>>
% 
%% 分类数据-沪深两市指数成分股及权重

% 封装了一个获取沪深两市指数成分股及权重的类
% 类名：fGetIndex();
% 属性：Code:待获取成分股的指数代码（默认为'000300'）; isSave:获取成分股后是否保存至本地Excel文件（1-保存，0-不保存）（默认为1）
% 方法：[OutputData,dStr] = GetCons()
%  输出OutputData为指数的成分股及权重（cell型数据），dStr为数据源更新的最后时间（char型数据）

% 测试样例：
% 获取沪深300指数成分股
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '000300';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;

% 运行结果：OutputData如下
%%
% 
% <<1gc.jpg>>
% 

% 获取创业板指成分股
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399006';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;

% 运行结果：OutputData如下
%%
% 
% <<2gc.jpg>>
% 

% 获取大数据i100指数指成分股
tic;
GetIndex = fGetIndex();

GetIndex.isSave = 1;
GetIndex.Code = '399415';

[OutputData,dStr] = GetIndex.GetCons();
dStr

tic;

% 运行结果：OutputData如下
%%
% 
% <<3gc.jpg>>
% 

% 默认会保存获取的数据至IndexCons文件夹内
%%
% 
% <<4gc.jpg>>
% 

%% 历史数据-股票每日交易明细数据

% 取单只股票某日交易明细数据
% 函数名称：GetStockTick_Web.m
% 函数作用：获取单只股票某日交易明细数据
% 函数句柄：[StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate,SaveFlag)函数说明：从
% http://vip.stock.finance.sina.com.cn/quotes_service/view/vMS_tradehistory.php?symbol=sz000562&date=2014-12-05
% 抓取单只股票某日交易明细数据，返回的StockTick为股票交易明细数据，每列的含义为：
% 成交时间 成交价 价格变动 成交量(手) 成交额(元) 性质（买盘：1，卖盘：-1，中性盘：0）
% 测试样例：
% StockCode = '000562';
% BeginDate = '20141205';
% [StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate);
% 运行结果：StockTick如下
%%
% 
% <<F03.png>>
% 

% 批量获取股票每日交易明细数据并存贮至本地.mat数据
% 函数名称：SaveStockTick.m
% 函数作用：批量获取股票每日交易明细数据并存贮至本地.mat数据
% 函数句柄：[SaveLog,ProbList,NewList] = SaveStockTick(StockList,DateList,PList,CheckFlag)
% 函数说明：基于GetStockTick_Web函数，批量获取StockList和DateList指定的代码列表、日期列表的交易明细数据并存贮至工具箱下的DataBase\Stock\Tick_mat文件夹内，
% 首次获取全市场所有的股票数据会非常费时，若已经有历史数据，运行SaveStockTick会进行本地数据的更新至最新交易日数据。
% 测试样例：
% %% 获取股票代码列表测试
% [StockList,StockListFull] = GetStockList_Web;
% StockCodeDouble = cell2mat( StockList(:,3) );
% save('StockList','StockList');
% %% 获取交易明细数据Tick-无并行操作
% [SaveLog,ProbList,NewList] = SaveStockTick(StockList);
% 运行结果：
% 首次运行后就会在本地DataBase\Stock\Tick_mat保存全部A股市场的交易明细数据，每个股票一个文件夹。
%%
% 
% <<F04.png>>
% 
%% 历史数据-股票日线除权数据以及复权因子

% 获取单只股票的日线数据
% 函数名称：GetStockTSDay_Web.m
% 函数作用：获取单只股票的日线数据除权数据以及复权因子（包含已退市股票）
% 函数句柄：[StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate)
% 函数说明：从
% http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/000562.phtml?year=2014&jidu=4
% 抓取相应股票的后复权数据和复权因子，然后反推算出最新的除权价格。
% 返回的StockDataDouble为股票除权后的日线数据，其每列的含义为：
% 日期 开 高 低 收 量(股) 额(元) 复权因子
% 测试样例：
% StockCode = '600318';
% BeginDate = '20150101';
% EndDate = datestr(today,'yyyymmdd');
% [StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);
% 运行结果：StockDataDouble如下
%%
% 
% <<F05.png>>
% 

% 批量获取股票除权日线数据并存贮至本地.mat数据
% 函数名称：SaveStockTSDay.m
% 函数作用：批量获取股票除权日线数据并存贮至本地.mat数据（包含已退市股票）
% 函数句柄：[SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag)
% 函数说明：基于GetStockTSDay_Web函数，批量获取StockList指定的代码列表的日线数据并存贮至工具箱下的DataBase\Stock\Day_ExDividend_mat文件夹内，首次获取全市场所有的股票数据会比较费时，若已经有历史数据，运行SaveStockTSDay会进行本地数据的更新至最新交易日数据。
% 测试样例：
% %% 获取股票代码列表测试
% [StockList,StockListFull] = GetStockList_Web;
% StockCodeDouble = cell2mat( StockList(:,3) );
% save('StockList','StockList');
% %% 股票数据更新-除权除息数据-无并行操作
% AdjFlag = 0;% AdjFlag 0:除权时序数据 1:前复权时序数据 2:后复权时序数据
% XRDFlag = 0;
% [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag);
% 运行结果：
% 首次运行后就会在本地DataBase\Stock\Day_ExDividend_mat保存全部A股市场的除权数据：
%%
% 
% <<F06.png>>
% 
%% 历史数据-股票前后复权数据生成（复权函数）
% CalculateStockXRD.m由除权数据生成前后复权数据
% 
% 这里要说明的是一般股票的回测，之所以要计算和生成前复权数据，是因为在股票的回测中，我们一般会使用前复权的数据进行回测，而非除权后的数据，
% 
% 因为除权后的数据由于分红配股的影响数据有缺口不够连续，会影响相应指标的计算。
% 
% 测试样例：

% % % 获取股票日线（除权除息）数据测试
% StockCode = '600690';
% BeginDate = '20100101';
% EndDate = '20130101';
% 
% [StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);
% % % 进行前复权数据生成
% StockData = StockDataDouble(:,1:end);
% XRD_Data = [];
% AdjFlag = 1;
% [StockDataXRD, factor] = CalculateStockXRD(StockData, XRD_Data, AdjFlag);
% % % 复权价格plot
% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
% 
% AX1 = subplot(211);
% OHLC = StockDataDouble(:,2:5);
% KplotNew(OHLC);
% Dates = StockDataDouble(:,1);
% LabelSet(gca, Dates, [], [], 1);
% str = [StockCode,'除权价格'];
% title(str,'FontWeight','Bold');
% 
% AX2 = subplot(212);
% OHLC = StockDataXRD(:,2:5);
% KplotNew(OHLC);
% Dates = StockDataDouble(:,1);
% LabelSet(gca, Dates, [], [], 1);
% ind = find( StockCodeDouble == str2double(StockCode) );
% str = [StockCode,'前复权价格'];
% title(str,'FontWeight','Bold');
% 
% linkaxes([AX1, AX2], 'x');

% 运行结果：
%%
% 
% <<F07.png>>
% 

%% 历史数据-数据频率转换[重采样]通用函数
%%
% <http://mp.weixin.qq.com/s?__biz=MzA5NzEzNDk4Mw==&mid=208012334&idx=1&sn=b350f584891b99c60093265422211fa5&3rd=MzA3MDU4NTYzMw==&scene=6#rd 更加详细内容请点击这里>

% 行情数据频率转换[重采样]通用函数
% 类:DataResampleClass
% 这个通用函数我封装成了一个类（DataResampleClass），其属性为函数的参数设置，可以灵活进行相关参数的设置，具体如下：
% classdef DataResampleClass < handle
%   %% DataResampleClass
%    %by LiYang_faruto
%    %Email:farutoliyang@foxmail.com
%    %2015/6/1
%   %% properties
%   properties
%       % % 降采样还是升采样选择参数
%       % 'DownSampling' 'UpSampling'
%       DownUpSampling = 'DownSampling';
%       % % 采用频率设置参数
%       % 'Nmin' 'Nhour' 'Nday' 'Nsecond' 'Nmillisecond'
%       % 'Nweek' 'Nmonth' 'Nquarter' 'Nyear' ...
%       Fre = '1min';
%       % % 数据市场代码设置参数（不同市场交易时间不同）
%       % 'SHSZ' 'CFFEX' ...
%       Market = 'SHSZ';
%       % % 用于产生采样值的方法
%       % 'OHLC2OHLC' 'OHLCVA2OHLCVA'
%       % 'OHLCVA' 'OHLC'
%       % 'first' 'last' 'median' 'max' 'min' 'sum' 'prod'
%       HowMethod = 'OHLCVA';
%       % % 数据缺失时的插值方法以及升采样时的插值方法选择
%       % 'ffill' 'bfill' 'nan'
%       FillMethod = 'ffill';
%       % % 在降采样中，各时间段的哪一端是闭合（即包含）的
%       % 'right' 'left'
%       Closed = 'right';
%       % % 在降采样中，如何设置采样后的标签，
%       % 比如 9:30到9:35之间的这5分钟会被标记为9:30('left')或9:35('right')
%       % 'right' 'left'
%       Label = 'right';
%       % % 输入数据的时间轴的数据格式
%       % Datenum: MATALB的datenum格式，
%       % DateNumber = datenum(2015,5,13,9,30,33)
%       % datestr(DateNumber) = '13-May-2015 09:30:33'
%       % PureDouble: 比如201505130930.33
%       % 'Datenum' 'PureDouble'
%       DateFormatInput = 'PureDouble';
%       % % 输入数据的时间轴的数据格式选择
%       % 'Datenum' 'PureDouble'
%       DateFormatOutput = 'PureDouble';
%      
%       % 1 0 Resample后是否作图
%       isPlot = 0;
%       % For LabelSet函数
%       LabelSetStyle = 0;
%       XTRot = 55;
%   end
%   %% properties(Access = protected)
%   properties(SetAccess = private, GetAccess = public)
%      
%       DownUpSampling_ParaList = {'DownSampling';'UpSampling';};
%       Fre_ParaList = {'Nmin(s)';'Nhour(s)';'Nday(s)';'Nweek(s)';...
%           'Nmonth(s);Nquarter(s);Nyear(s);[括号中字符输入不输入都行]'};
%       Market_ParaList = {'SHSZ'};
%       HowMethod_ParaList = {'OHLC2OHLC';'OHLCVA2OHLCVA'; ...
%           'OHLCVA';'OHLC'; ...
%           'first';'last';'median';'max';'min';'sum';'prod'};
%      
%       FillMethod_ParaList = {'ffill';'bfill';'nan'};
%       Closed_ParaList = {'right';'left'};
%       Label_ParaList = {'right';'left'};
%       DateFormat_ParaList = {'Datenum';'PureDouble'};
%      
% End
% 
% … …
% … …
% 
% end


% 这个行情数据频率转换[重采样]通用函数可以实现的功能如下：
% 支持证券交易所（上证所、深证所）、期货交易所（中金所、上期所、大商所、郑商所）行情数据频率转换；
% 支持降采样（downsampling），i.e高频率数据转换为低频率数据：tick数据转换为秒级别数据（任意时间切片）、tick数据转换为分钟级别数据（任意时间切片）、
% tick数据转换为其他任意更低级别的数据，分钟数据转换为其他任意更低级别的数据（N小时线、N日线等等），日线数据转换为其他任意更低级别的数据（N周线、N月线、N季线、N年线等等）;
% 支持升采样（upsampling），i.e低频率数据通过插值转换高频率数据。
% 测试样例：
% % Get Tick Data Using FQuantToolBox
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
% % DataResampleClass 初始化
DResample = DataResampleClass();
% % 参数设置
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
% % OneDay tick2min
DResample.Fre = '1min';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
% % OneDay 1minTo5min
DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA2OHLCVA';

OutputData3 = DResample.Resample(OutputData1);

% % OneDay tick2min

DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
% % OneDay tick2day
DResample.Fre = '1day';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D1(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);

% % MultiDay tick2min

DResample.Fre = '1min';
DResample.HowMethod = 'OHLCVA';  

InputData2 = D(:,[1 2 4 5]);

OutputData2 = DResample.Resample(InputData2);
% % MultiDay 1minTo5min
DResample.Fre = '5min';
DResample.HowMethod = 'OHLCVA2OHLCVA';
OutputData4 = DResample.Resample(OutputData2);
% % MultiDay tick2day
DResample.Fre = '1day';
DResample.HowMethod = 'OHLCVA';  

InputData1 = D(:,[1 2 4 5]);

OutputData1 = DResample.Resample(InputData1);
% % Get Index Data Using FQuantToolBox

StockCode = '000001';
% StockCode = '000300';

BeginDate = '20100101';

EndDate = datestr(today,'yyyy-mm-dd');

[Data] = GetIndexTSDay_Web(StockCode,BeginDate,EndDate);

DateTemp = Data(:,1)*1e4+1500*ones(length(Data),1);
InputData =[DateTemp,Data(:,2:end)]; 

% % dayToday

DResample.Fre = '3day';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);

% % dayToweek

DResample.Fre = '1week';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);
% % dayTomonth

DResample.Fre = '1month';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);
% % dayToquarter

DResample.Fre = '1quarter';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);
% % dayToyear

DResample.Fre = '1year';
DResample.HowMethod = 'OHLCVA2OHLCVA';  

OutputData1 = DResample.Resample(InputData);
%% 历史数据-交易所相关指数日线数据

% 函数名称：GetIndexTSDay_Web
% 函数作用：获取上海证券交易所和深圳证券交易所相关指数日线数据
% 函数句柄：[Data] = GetIndexTSDay_Web(StockCode,BeginDate,EndDate )
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：
% %% 获取指数数据
% StockCode = '000001';
% StockCode = '000300';
% BeginDate = '20140101';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% [Data] = GetIndexTSDay_Web(StockCode,BeginDate,EndDate);

% 运行结果：
% 运行后返回的Data为StockCode指定的指数的日线数据（抬头为日期、开、高、低、收、量、额）如下：
%%
% 
% <<sF01.png>>
% 

% 相应的批量数据获取和保存函数为
% [SaveLog,ProbList,NewList] = SaveIndexTSDay(IndexList)
% 首次运行后就会在本地DataBase\Stock\Index_Day_mat保存全部上海证券交易所和深圳证券交易所相关指数日线数据，如下：
%%
% 
% <<sF02.png>>
% 
%% 历史数据-获取基金数据（历史净值、基金概况、申购赎回、十大持有人）

% 类名：fGetFund
% 属性：
% Code 数据代码，默认为'510050'
% StartDate 起始日期(比如'20150101')，如果输入为'All'，则获取全部数据
% EndDatae 终止日期(比如'20150501')，如果输入为'All'，则获取全部数据
% isSave 是否保存获取的数据至本地

% 方法：
% GetNetValue 获取单位净值和累计净值
% GetFundShareChg 获取申购赎回数据
% GetFundProfile 获取基金概况
% GetFundHolder 获取基金十大持有人数据

% 测试样例：
%% 历史数据-获取基金数据-历史净值

GetFund = fGetFund();

GetFund.Code = '510050';
GetFund.StartDate = '20150101';
GetFund.EndDate = datestr(today,'yyyymmdd');
GetFund.isSave = 1;

tic;
[OutputData,Headers] = GetFund.GetNetValue();
toc;

format longG
Headers
OutputData(1:5,:)
disp('... ...');
OutputData(end-5:end,:)

%% 历史数据-获取基金数据-基金概况

GetFund = fGetFund();

GetFund.Code = '510050';
GetFund.StartDate = '20150101';
GetFund.EndDate = datestr(today,'yyyymmdd');
GetFund.isSave = 1;

tic;
[OutputData] = GetFund.GetFundProfile();
toc;

OutputData

%% 历史数据-获取基金数据-申购赎回

GetFund = fGetFund();

GetFund.Code = '510050';
GetFund.StartDate = 'All';
GetFund.EndDate = datestr(today,'yyyymmdd');
GetFund.isSave = 1;

tic;
[OutputData,Headers] = GetFund.GetFundShareChg();
toc;

format longG
Headers
OutputData(1:5,:)
disp('... ...');
OutputData(end-5:end,:)

%% 历史数据-获取基金数据-十大持有人

GetFund = fGetFund();

GetFund.Code = '510050';
GetFund.StartDate = 'All';
GetFund.EndDate = datestr(today,'yyyymmdd');
GetFund.isSave = 1;

tic;
[OutputData,Headers] = GetFund.GetFundHolder();
toc;

OutputData

OutputData{2,1}
tData = OutputData{2,2};
for i = 1:length(tData)
   str = [tData{i,1},' ',num2str(tData{i,2}),' ',num2str(tData{i,3})];
   disp(str);
end

%% 历史数据-期货合约日线数据

% 函数名称：GetFutureDay_Web
% 函数作用：获取某日期货合约日线数据
% 函数句柄：
% [DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode)
% 函数说明：从各期货交易所，比如中金所
% http://www.cffex.com.cn/fzjy/mrhq/
% 获取某日所期货合约日线数据。
% DateStr为输入的日期，比如DateStr = '20141215';
% MarketCode为交易所代码，比如MarketCode = 'CFFEX';（SHFE、DCE、CZCE）
% FuturesCode为期货品种代码，比如FuturesCode = 'IF';
% 
% DataCell为返回的数据
% 测试样例：
% %% 获取期货某交易所某日数据-中金所-IF
% DateStr = '20141216';
% MarketCode = 'CFFEX';
% FuturesCode = 'IF';
% [DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);
% 运行结果：
% DataCell返回当日的IF的所有合约的日数据，如下
%%
% 
% <<F08.png>>
% 

% 相应的批量数据获取和保存函数为
% [SaveLog,ProbList,NewList] = SaveFuturesDay(MarketCode,FutureCode,DateList)首次运行后就会在本地DataBase\Futures下的相应合约代码下的文件夹，
% 比如DataBase\Futures\IF\Day_mat 存贮一个IF_Day.mat文件，保存IF从上市日至今所有合约的日线数据，如下：
%%
% 
% <<F09.png>>
% 

% 相应的单独一个合约的日线数据，做一下提取再处理即可，然后可以再进行主力连续合约、次主力连续合约的生成等一系列的期货连续数据的生成和清洗。
%% 历史数据-期货合约每日结算会员成交持仓排名数据

% 函数名称：GetFutureVolOIRanking_Web.m
% 函数作用：获取期货合约每日结算会员成交持仓排名数据
% 函数句柄：[DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, FutureCode)
% 函数说明：从各期货交易所，比如中金所
% http://www.cffex.com.cn/fzjy/ccpm/
% 获取期货合约每日结算会员成交持仓排名数据。
% 测试样例：
% %% 获取期货结算会员成交持仓排名数据-IF
% tic
% DateStr = '20141216';
% Futurecode = 'if';
% [DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, Futurecode);
% toc
% 运行结果：
% 运行后DataCell返回当日相关品种各个合约的结算会员成交持仓排名，如下：
%%
% 
% <<F10.png>>
% 
%%
% 
% <<F11.png>>
% 

% 相应的批量数据获取和保存函数为
% [SaveLog,DateListOut,ProbList,NewList] 
% = SaveFuturesVolOIRankingData(FutureCode,DateList,UpdateFlag)
% 首次运行后就会在本地DataBase\Futures下的相应合约代码下的文件夹，比如DataBase\Futures\IF\VolOIRanking 
% 存贮一个IF从上市日至今所有合约的结算会员的每日成交持仓排名数据，如下：
%%
% 
% <<F13.png>>
% 

% 对于策略开发，或对这部分数据（期货合约每日结算会员成交持仓排名数据）这里多说一点，基于这部分数据可做的事情还是挺多的，比较有想象空间。使用这部分数据，
% 可以构造某种意义上的投资者情绪指标，一则可以构造开发CTA类策略（IF策略），二则可以用来开发对于HS300的择时策略。
% 基于这部分数据开发的IF策略，会与普通的使用价量开发的策略有异构性，方便提升CTA大组合策略的异构性，平滑整体资金流，
% 下图是我以前做过的基于这部分数据构建的IF策略的一个Demo:
%%
% 
% <<F14.png>>
% 

% 基于这部分数据开发HS300择时策略的前提假设是，期货合约每日结算会员成交持仓排名数据带有某些机构对于未来IF走势的某些预判信息，进而某种程度上影响HS300，
% 也是有一定文章可做的。在此不做过多展开。
%% 实时数据-获取实时分笔数据-针对数据：股票、指数、基金（ETF、分级基金等）、期货
% 可以获取沪深两市所有股票、所有指数、所有基金（包括ETF、分级基金等）、期货（四大期货交易所）所有品种的实时数据
%
% 支持多Ticker同时获取
%
% 类名：fGetRTQuotes();
%
% 属性：Code:待获取实时数据的代码
%
% 方法：DataCell_Output = GetRTQuotes()

% % % 测试样例：
%% 实时数据-单品种-股票实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = '600036'
DataRT = GetRTQuotes.GetRTQuotes()

%% 实时数据-单品种-指数实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = 'SH000300'
DataRT = GetRTQuotes.GetRTQuotes()

GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = 'sz399415'
DataRT = GetRTQuotes.GetRTQuotes()

%% 实时数据-单品种-ETF实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = '510050'
DataRT = GetRTQuotes.GetRTQuotes()

%% 实时数据-单品种-分级基金实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = '150197'
DataRT = GetRTQuotes.GetRTQuotes()

%% 实时数据-单品种-期货品种实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = 'M0'
DataRT = GetRTQuotes.GetRTQuotes()

GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = 'RB1510'
DataRT = GetRTQuotes.GetRTQuotes()

GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = 'IF1506'
DataRT = GetRTQuotes.GetRTQuotes()

%% 实时数据-多品种-实时数据
GetRTQuotes = fGetRTQuotes();
GetRTQuotes.Code = {'600036';'M0';'IF1506';'150197';'TA0';'RB0';'510050'}
DataRT = GetRTQuotes.GetRTQuotes()


%% 基本面数据-股票个股公司基本信息、证监会分类、所属概念分类

% 函数名称：GetStockInfo_Web
% 函数作用：获取A股市场的全部股票个股公司基本信息、证监会分类、所属概念分类（包含已退市股票）
% 函数句柄：[StockInfo] = GetStockInfo_Web(StockCode)
% 函数说明：从
% 公司简介：http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpInfo/stockid/600588.phtml
% 板块信息：
% http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/600588/menu_num/2.phtml
% 抓取个股公司基本信息、证监会分类、所属概念分类，返回的StockInfo为一个结构体，存储相关信息。
% 测试样例：
% %% GetStockInfo_Web
% % 获取股票基本信息以及所属行业板块（证监会行业分类）和所属概念板块（新浪财经定义）
% StockCode = '600588';
% [StockInfo] = GetStockInfo_Web(StockCode);
% 运行结果：
% 运行后返回的StockInfo为一个结构体，存贮信息如下：
%%
% 
% <<F15.png>>
% 

% 其中StockInfo.CompanyIntro中存在公司的基本介绍，如下：
%%
% 
% <<F16.png>>
% 

% StockInfo.IPOdate、StockInfo.IPOprice是提取出来的上市日期和发行价格信息，您也可以按照自己的需要从StockInfo.CompanyIntro进行提取。
% StockInfo.IndustrySector、StockInfo.ConceptSector_Sina存贮的是证监会的行业分类和个股所属的概念分类。
% 如下：
% >> StockInfo.IPOdate
% ans =
%     20010518
% >> StockInfo.IPOprice
% ans =
%    36.6800
% >> StockInfo.IndustrySector
% ans =
% 计算机应用服务业
% >> StockInfo.ConceptSector_Sina
% ans = 
%     '保险重仓'
%     '融资融券'
%     'QFII重仓'
%     '股权激励'
%     '云计算'
%     '国产软件'

% 相应的批量数据获取和保存函数为
% [SaveLog,ProbList,NewList] = SaveStockInfo(StockList)
% 首次运行后就会在本地DataBase\Stock\StockInfo_mat保存全部A股的公司信息、证监会分类、概念分类，如下：
%%
% 
% <<F17.png>>
% 

%% 基本面数据-股票分红配股信息数据

% 函数名称：GetStockXRD_Web.m
% 函数作用：获取股票分红配股信息数据
% 函数句柄：
% [ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = GetStockXRD_Web(StockCode)
% 函数说明：从
% http://vip.stock.finance.sina.com.cn/corp/go.php/vISSUE_ShareBonus/stockid/000562.phtml
% 抓取最新的股票名称和代码列表，返回的Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2为股票的分红配股信息数据。
% 此函数是在Chandeman（MATALB技术论坛ID: fosu_cdm）曾经编写过的一个函数基础修改而成。
% 测试样例：

% %% 参数设置
% StockCode_G = '000562'
% 
% str = ['全局参数设置完毕！'];
% disp(str);
% %% 获取股票除权除息数据
% StockCodeInput = StockCode_G;
% 
% [ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = GetStockXRD_Web(StockCodeInput);
% Web_XRD_Cell_1;
% Web_XRD_Cell_2;

% 运行结果：
%%
% 
% <<F18.png>>
% 
%%
% 
% <<F19.png>>
% 

% 相应的批量数据获取和保存函数为
% [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag)
% 此时需令XRDFlag = 1即可批量获取获取除权除息信息。
% 首次运行后就会在本地DataBase\Stock\XRDdata_mat保存全部A股的除权除息信息数据：
%%
% 
% <<F20.png>>
% 

%% 基本面数据-财务数据和三张表数据获取

% GetStockFinIndicators_Web.m函数和GetStock3Sheet_Web.m函数可以获取单只股票的财务数据和三张表数据
% [FIndCell,YearList] = GetStockFinIndicators_Web(StockCode,Year)
% [BalanceSheet,ProfitSheet,CashFlowSheet,YearList] = GetStock3Sheet_Web(StockCode,Year)
% 数据获取后用cell矩阵承装
%%
% 
% <<F21.png>>
% 
%%
% 
% <<F22.png>>
% 

% 相应的批量数据获取函数为
% [SaveLog,ProbList,NewList] = SaveStockFD(StockList,Opt)
% % Opt 0:获取财务指标 1:获取3张表
% 财务数据存贮位置：
% FQuantToolBox\DataBase\Stock\FinancialIndicators_mat
%%
% 
% <<F23.png>>
% 

% 三张表数据存贮位置：
% FQuantToolBox\DataBase\Stock\Sheet3_mat
%%
% 
% <<F24.png>>
% 
%% 舆情文本数据-上市公司公告文件数据

% 函数名称：GetStockNotice_Web
% 函数作用：获取上市公司公告文件列表
% 函数句柄：[NoticeDataCell] = GetStockNotice_Web(StockCode,BeginDate,EndDate)
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：

% StockCode = '600588';
% BeginDate = '20141001';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% [NoticeDataCell] = GetStockNotice_Web(StockCode,BeginDate,EndDate);

% 运行结果：
% 运行后返回的NoticeDataCell为StockCode指定的股票的公司公告文件列表如下：
% 保存的内容抬头为股票代码、日期时间、文件名字、公告类型、文件URL、文件大小
%%
% 
% <<F25.png>>
%

% 相应的批量数据获取和保存函数为
% [FileListCell,SaveLog,ProbList,NewList] = SaveStockNotice(StockList)
% 首次运行后就会在本地DataBase\Stock\StockNotice_file\文件夹内保存全部A股的公司公告文件，每个股票单独一个文件夹，如下：
%%
% 
% <<F26.png>>
%
%%
% 
% <<F27.png>>
%

% 这里多说一点，基于上市公司公告数据，可做的东西还是蛮多的，主要用来开发事件驱动类策略，大体从两个方面：一方面根据公告的粗略分类和发布日期，
% 进行简单的事件驱动类策略开发（某只股票发布某种定义下的“重要公告”后就持有N天，每T天进行组合调整）；另一方面，如果想要做得更细致，
% 由于已经保存了上市公司公告的全文，则可以进行上市公司公告全文的文本挖掘，进行将公告的分类进行细致划分，并对公告进行分词处理，
% 进而开发精细化的基于上市公司公告的事件驱动类策略。
%% 舆情文本数据-上市公司投资者关系信息（Investor Relations Info）数据

% 函数名称：GetStockInvestRInfo_Web
% 函数作用：获取上市公司投资者关系信息（Investor Relations Info）列表
% 函数句柄：[IRDataCell] = GetStockInvestRInfo_Web(StockCode,BeginDate,EndDate)
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：

% StockCode = '000001';
% BeginDate = '20101001';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% [IRDataCell] = GetStockInvestRInfo_Web(StockCode,BeginDate,EndDate);

% 运行结果：
% 运行后返回的IRDataCell为StockCode指定的股票的公司投资者关系信息（Investor Relations Info）列表如下：
% 保存的内容抬头为股票代码、日期时间、文件名字、公告类型、文件URL、文件大小
%%
% 
% <<F28.png>>
%

% 相应的批量数据获取和保存函数为
% [IRInfoFileListCell,SaveLog,ProbList,NewList] = SaveStockInvestorRelationsInfo(StockList)
% 首次运行后就会在本地DataBase\Stock\ StockInvestorRelationsInfo_file\文件夹内保存上市公司投资者关系信息（Investor Relations Info）文件，
% 每个股票单独一个文件夹，如下：
%%
% 
% <<F29.png>>
%
%%
% 
% <<F30.png>>
%

% 同样的，基于上市公司投资者关系信息（Investor Relations Info）数据，与上市公司公告数据一样，可以用来研发事件驱动类策略，可做粗、可做细。

%% 舆情文本数据-百度高级搜索相关数据

% 函数名称：BaiduSearchAdvancedNews
% 函数作用：获取百度高级搜索相关内容，可以任意指定个股相关关键词，获取搜索之后的相关词条的时间、来源、URL链接等内容，且可以指定搜索时间段。
% 函数句柄：
% [NewsDataCell] 
% = BaiduSearchAdvancedNews(StringIncludeAll,StringIncludeAny,BeginDate,EndDate)
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：

% StockCode = '600588';
% BeginDate = '20141226';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% StringIncludeAny = [];
% [NewsDataCell] = BaiduSearchAdvancedNews(StockCode,StringIncludeAny,BeginDate,EndDate);

% 运行结果：
% 运行后返回的NewsDataCell为StockCode指定的股票的百度全文搜索词条，内容如下：
% 保存的内容抬头为日期时间、Title、来源、URL 
%%
% 
% <<F31.png>>
%

% 基于这部分数据，就可以开发舆情类策略，可以从两方面入手：
% 一方面，可以基于某一时间段的搜索量的总量和增量的统计，找到相应的热门和冷门股，进行相应策略的构建；
% 另一方面，如果想做得细致一些，由于保存了词条的URL，可以通过词条的URL获取搜索内容的全文内容，然后进行分词处理，给出正负面的打分，构建更加精细化的舆情策略。
% 
% 事实上BaiduSearchAdvancedNews函数可以输入任意的关键词进行搜索，而不一定是股票代码，比如，搜索“习大大”相关的内容：
% 测试样例：
% %% BaiduSearchAdvancedNews Word Test
% StringIncludeAll = '习近平';
% BeginDate = '20141226';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% StringIncludeAny = [];
% [NewsDataCell] = BaiduSearchAdvancedNews(StringIncludeAll,StringIncludeAny,BeginDate,EndDate); 

% 运行结果：
%%
% 
% <<F32.png>>
%
%% 舆情文本数据-新浪高级搜索相关数据

% 函数名称：SinaSearchAdvanced
% 函数作用：获取新浪高级搜索相关内容，可以任意指定个股相关关键词，获取搜索之后的相关词条的时间、来源、URL链接等内容，且可以指定搜索时间段。
% 函数句柄：
% [NewsDataCell] 
% = SinaSearchAdvanced(StringIncludeAll,BeginDate,EndDate)
% 函数说明：从相关网络上抓取相关数据。
% 测试样例：

% StringIncludeAll = '600588';
% BeginDate = '20141201';
% EndDate = datestr(today,'yyyy-mm-dd');
% 
% [NewsDataCell] = SinaSearchAdvanced(StringIncludeAll,BeginDate,EndDate); 

% 运行结果：
% 运行后返回的NewsDataCell为StockCode指定的股票的百度全文搜索词条，内容如下：
% 保存的内容抬头为日期时间、Title、来源、URL 
%%
% 
% <<F33.png>>
%
%% 舆情文本数据-股票研报列表、摘要数据
% 获取股票研报相关数据

% 测试样例：
% StockCode = '600588';
% BeginDate = '20141001';
% EndDate = datestr(today,'yyyymmdd');
% 
% [ReportList] = GetStockReport_Web(StockCode, 'BeginDate',BeginDate,'EndDate',EndDate);
% 运行结果：
%%
% 
% <<F34.png>>
%
%% 辅助函数和工具-MATLAB数据保存成其他格式文件(.csv .xlsx .txt等)通用函数
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell,varargin)
%%
% <http://mp.weixin.qq.com/s?__biz=MzA5NzEzNDk4Mw==&mid=205637598&idx=2&sn=2ef11f011c250f8bd864d36d70df12ea&3rd=MzA3MDU4NTYzMw==&scene=6#rd 更加详细内容请点击这里>

% FQuantToolBox发布后有些网友反应能否将获取的股票等相关数据保存成其他文件格式，当下FQuantToolBox默认的保存格式是.mat文件，
% 可能有的朋友需要存成其他格式(.csv .xlsx .txt等)的文件进行调用，故编写了SaveData2File.m函数，一方面可以结合FQuantToolBox使用，
% 将提取的股票、期货数据保存成您需要的格式，另一方面该函数也可以单独使用，可以将任何MATLAB数据（double型 cell型）
% 快速的保存成其他格式文件（现支持保存成{'.txt','.dat','.csv','.xls','.xlsb','.xlsx','.xlsm'}等扩展名的文件）。

% % % 获取股票代码列表测试
% [StockList,StockListFull] = GetStockList_Web;
% StockCodeDouble = cell2mat( StockList(:,3) );
% save('StockList','StockList');
% 
% % % StockList SaveData2File
% tic;
% Data = StockList;
% 
% FileName = 'StockList.csv';
% ColNamesCell = {'股票名称','股票代码','股票代码（纯数字）'};
% 
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
% 
% Data = StockList;
% 
% FileName = 'StockList.txt';
% ColNamesCell = {'股票名称','股票代码','股票代码（纯数字）'};
% 
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
% toc;
% % % 获取指数代码列表
% 
% [IndexList] = GetIndexList_Web;
% 
% save('IndexList','IndexList');
% 
% % % IndexList SaveData2File
% tic;
% Data = IndexList;
% 
% FileName = 'IndexList.csv';
% ColNamesCell = {'名称','代码','代码（纯数字）'};
% 
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
% toc;
% % % 获取股票日线（除权除息）数据测试
% 
% StockCode = 'sh600030';
% 
% BeginDate = '20130101';
% EndDate = '20150101';
% 
% [StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);
% 
% % % StockDataDouble SaveData2File
% tic;
% Data = StockDataDouble;
% FileName = 'StockDataTest.csv';
% % FileName = [];
% 
% ColNamesCell = {'日期','开','高','低','收','量','额','复权因子'};
% % ColNamesCell = [];
% 
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
% toc;
% 
% % % 获取股票财务指标测试
% 
% StockCodeInput = '600588';
% StockCodeInput = StockCode_G;
% 
% Year = '2014';
% [FIndCell,YearList] = GetStockFinIndicators_Web(StockCodeInput,Year);
% FIndCell
% % % FIndCell SaveData2File
% tic;
% Data = FIndCell;
% 
% FileName = '财务指标Test.csv';
% ColNamesCell = [];
% 
% [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
% toc;

% 运行结果
% 保存后的其他格式的文件
%%
% 
% <<F35.png>>
%

%% 辅助函数和工具-MATLAB发送邮件通用函数
% MatlabSendMailGeneral(subject, content, TargetAddress, Attachments,SourceAddress,password)

%%
% <http://mp.weixin.qq.com/s?__biz=MzA5NzEzNDk4Mw==&mid=205637598&idx=1&sn=a8ff13498211d3268621ab7dbfb33c62&3rd=MzA3MDU4NTYzMw==&scene=6#rd 更加详细内容请点击这里>

% 有时候我们会让MATLAB自动定时运行(查看公众号历史消息：定时运行MATLAB程序任务的解决方案), 让后自动发送邮件，发送程序运行的情况，包括是否运行成功，运行耗时等等。
% 
% 下面是一个MATLAB发送邮件通用函数，可以使用其来用MATLAB发送邮件。支持指定发送邮箱和接收邮箱，稍微再写个脚本，还可以支持群发邮件。

% 可以使用下面的脚本来测试：

% SourceAddress = '输入自己的邮箱地址'; %自己的邮箱地址
% password = '输入自己邮箱的密码'; %输入自己邮箱的密码
% 
% subject = '中文英文123Test';
% content = subject;
% 
% TargetAddress = SourceAddress;
% 
% MatlabSendMailGeneral(subject, content, TargetAddress, [],SourceAddress,password);

%% 辅助函数和工具-绘制K线函数、横轴时间轴设定函数

% 绘制K线函数：KplotNew(OHLC) 
% 输入OHLC：开高低收 输出K线图形

% 横轴时间轴设定函数：LabelSet(Ghandle, Dates, TickStep, TickNum, Style,XTRot)
% 输入
% Ghandle：待绘制横轴的图形句柄，一般设置为gca即可
% Dates：横轴时间标签，double型数据，即输入日期格式为double型的，比如20150525
% TickStep：横轴标签间隔设置，设置为空即可，会有进行默认调整
% TickNum：横轴标签数据，设置为空即可，会有进行默认调整
% Style：展示风格选项，
    % 0 默认形式
    % 1 日线数据-月标签
    % 2 日线数据-年标签
    % 3 分钟线数据-日标签
    % 4 分钟线数据-月标签
    % 5 分钟线数据-年标签
    % 
    % 8 自适应调整
% XTRot：横轴标签旋转度数调整，设置为或不输入即可，会有进行默认调整

% % 测试样例：
% 获取数据
StockCode = '000869';
BeginDate = '20150101';
EndDate = datestr(today,'yyyymmdd');

[StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);
% 绘制K线
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);

OHLC = StockDataDouble(:,2:5);
KplotNew(OHLC);
% 横轴时间轴设定
Dates = StockDataDouble(:,1);
Style = 0;
XTRot = [];
LabelSet(gca, Dates, [], [], Style,XTRot);
str = [StockCode,'-K线图'];
title(str,'FontWeight','Bold');


%% 如何构建基于MATLAB的回测系统
% FQuantToolBox中的“如何构建基于MATLAB的回测系统”文件夹里，提供了一个“如何构建基于MATLAB的回测系统”的demo样例，提供了一个均线回测样例和一个回测模板，
% 此部分内容来自《量化投资：以MATLAB为工具》的相关章节。具体可参看《量化投资：以MATLAB为工具》相关章节。

%% 其他说明
% FQuantToolBox工具箱的更新周期，现在暂无明确时间表。未来更新的大致方向就是增添更多金融标的的免费数据获取方式，增添更多的回测辅助函数和样例。

% FQuantToolBox工具箱里面共有四个MATLAB脚本文件（什么是脚本文件？不懂MATLAB脚本文件和函数文件的区别？那您需要先做些功课，百度搜索“N分钟学会MATLAB”）：
% Main_GetStockDataTest.m
% Main_GetFuturesDataTest.m
% Main_SaveStockData2LocalTest.m
% Main_SaveFuturesData2Local.m
% 其中，
% Main_GetStockDataTest.m是用来测试FQuantToolBox工具箱里面所有以Get开头的和股票相关的函数，每个测试在Main_GetStockDataTest.m在一个cell里面，
% 方便您来查看相关函数的输入输出。比如：
%%
% 
% <<S01.png>>
% 

% Main_GetFuturesDataTest.m是用来测试FQuantToolBox工具箱里面所有以Get开头的和期货相关的函数，每个测试在Main_GetFuturesDataTest.m在一个cell里面，
% 方便您来查看相关函数的输入输出。比如：
%%
% 
% <<S02.png>>
% 

% Main_SaveStockData2LocalTest.m是用来测试FQuantToolBox工具箱里面所有以Save开头的和股票相关的函数，用来把网络上相关的数据存贮到本地，
% 每个测试在Main_SaveStockData2LocalTest.m在一个cell里面，方便您来查看相关函数的输入输出，由于全部运行会很耗时，所以每个cell设置了一个run变量，
% 您只需把run设置为1，该cell模块就行运行，run=0时，相应cell模块不会运行。
%%
% 
% <<S03.png>>
% 

% 您或许在Main_SaveStockData2LocalTest.m内会看到一些spmd并行操作模块，如果您对MATLAB并行有了解，那么可以并行批量下载相关数据，否则的话，您忽略该部分代码即可。
% 
% Main_SaveFuturesData2Local.m与Main_SaveStockData2LocalTest.m作用类似，只不过Main_SaveFuturesData2Local.m
% 是用来测试FQuantToolBox工具箱里面所有以Save开头的和期货相关的函数，用来把网络上相关的数据存贮到本地。

%% 基于FQuantToolBox的测试样例:一种简化的截面动量组合测试
% 运行函数SimpleMomentumPortfolioTest.m进行测试

%%
% <http://mp.weixin.qq.com/s?__biz=MzA5NzEzNDk4Mw==&mid=204989303&idx=1&sn=8438eb4cd073159db4be7814878c320d&3rd=MzA3MDU4NTYzMw==&scene=6#rd 更加详细内容请点击这里：一种简化的截面动量组合测试>

% 策略简介：
% 策略比较简单，使用N只股票构建投资组合，计算每只股票的过去LookBack（参数）日的动量，并作标准化处理作为股票权重，持有Holding（参数）日，
% 其中权重允许为负数，即允许做空股票。简要说来就是做过过去表现强势的股票，做空过去表现弱势的股票。
% 
% 虽然策略比较简单，但整体的测试流程和框架很明了清晰，对类似策略的回测实现具有参考意义，整体的流程框架为：
% 
% 数据获取（基于付费或者免费的数据源）——》
% 数据的时间轴对齐以及缺失数据填充——》
% 子函数编写：特定回顾期的动量计算并作标准化——》
% 子函数编写：给定回顾期和持有期，组合的夏普比例计算——》
% 计算不同回顾期和持有期下组合的夏普比例值——》
% 进行策略参数分布图形展示

% 运行函数SimpleMomentumPortfolioTest.m
%%
% 
% <<D1-01.png>>
% 
%%
% 
% <<D1-02.png>>
% 

%% 基于FQuantToolBox的测试样例:一类简单的群体行为择时模型框架及实现测试
% 
%%
% <http://mp.weixin.qq.com/s?__biz=MzA5NzEzNDk4Mw==&mid=208480402&idx=1&sn=46a21a3a454cb5d639750b845aed33b1&3rd=MzA3MDU4NTYzMw==&scene=6#rd 更加详细内容请点击这里>

% 策略简介：
% 指数的择时模型可以通过对其成分股的行为描述（打分），最后通过某种方式整合到一起（综合打分）来构建。
% 以简单的均线为例，虽然均线很简单，但简单的东西往往最具有生命力，最能有效的描述市场。我们知道均线的模型都具有滞后性，
% 我们可以使用常见的20日均线作用在指数上进行择时，我想效果不会差，但会有一定的滞后性，这没有办法，因为不存在圣杯，
% 但本篇要讨论的是一个基于上面的群体行为择时框架的均线类择时模型。
% 回到上面的模型框架：
% TM(Index) = sf(sTM(Stock_1,Stock_2,…,Stock_N))
% 构建择时模型TM_demo，对于单只个股定义
% sTM(Stock_i)={个股与均线1的相对位置量化描述，个股与均线2的相对位置量化描述}，sf为某种加权平均（线性或非线性），

% 以下测试基于MATLAB，数据来源为FQuantToolBox和Wind，测试标的为沪深300指数（000300.SH）,使用T日之前（T-1日、T-2日，… …）的数据来生成信号指导T日交易，
% 按照择时模型TM_demo生成的择时信号如下：
%%
% 
% <<1.jpg>>
% 
% 可以看到正如我们料想的那样，群体行为择时模型TM_demo在某些时点可以提前发生买入和卖出信号，但也不是在任何时候都百分之百准确，因为不存在圣杯。
% 在来放到看下2015年近期的信号：
%%
% 
% <<4.jpg>>
% 
% 可以看到模型的“运气”还比较不错。
%  
% 基于上面的择时信号，下面再来系统回测一下，使用T日之前（T-1日、T-2日，… …）的数据来生成信号指导T日交易，若有最多信号，则T日开盘买入测试标的，
% 若有做空信号则空仓观望（后面会有做空的测试），测试结果如下：
%%
% 
% <<2.jpg>>
% 
%%
% 
% <<3.jpg>>
% 
% 若允许做空，测试结果如下：
%%
% 
% <<5.jpg>>
% 
%%
% 
% <<6.jpg>>
% 

%% 《量化投资：以MATLAB为工具》书籍介绍
% 《量化投资：以MATLAB为工具》分为基础篇和高级篇两大部分。基础篇部分通过Q&A的方式介绍了MATLAB的主要功能、基本命令、数据处理等内容，使读者对MATLAB有基本的了解。
% 高级篇部分分为14章，包括MATLAB处理优化问题和数据交互、绘制交易图形、构建行情软件和交易模型等内容，通过丰富实例和图形帮助读者理解和运用MATLAB作为量化投资的工具。
% 《量化投资：以MATLAB为工具》的特色在于不仅仅满足理论学习的需要，更帮助读者边学边练，将理论和实践并重。
% 
% 《量化投资：以MATLAB为工具》适合金融机构的研究人员和从业人员、进行量化投资的交易员、具有统计背景的科研工作者、高等院校相关专业的教师和学生以及对量化投资和
% MATLAB感兴趣的人士阅读。 

%% 其他信息
% <html>
% <table border="0" width="600px" id="table1">	
% <tr><td><b><font size="2">这里为一些在线测试demo和在线帮助文档，全部有MATLAB自动publish生成</font></b></td></tr>	
% <tr><td><span class="tip"><font size="2">FQuantToolBox最新版下载地址：<a target="_blank" href="http://pan.baidu.com/s/1gdIiccN"><font color="#0000FF">百度网盘</font></a></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">FQuantToolBox使用交流讨论论坛：<a target="_blank" href="http://www.matlabsky.com/forum-112-1.html"><font color="#0000FF">MATLAB技术论坛</font></a></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">FQuantToolBox使用交流讨论QQ群：QuantGroup1群[MATLAB] 279908629</font></span></td></tr> 	
% <tr><td><span class="tip"><font size="2">作者faruto的联系方式：邮箱-farutoliyang@foxmail.com <a target="_blank" href="http://weibo.com/faruto"><font color="#0000FF">微博-faruto</font></a>  微信公众号-FQuantStudio(欢迎扫码关注)</font></span></td></tr>
% <tr><td><span class="tip"><font size="2"><img src="./FQuantStudioWeChat.jpg" width="90" height="90"></font></span></td></tr>
% <tr><td><span class="tip"><font size="2">书籍推荐：</font></span></td></tr>
% </table>
% <img src="./QuMBook.jpg" width="300" height="400">
% <img src="./ANN.jpg" width="300" height="400">
% <br><script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1255207519'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1255207519' type='text/javascript'%3E%3C/script%3E"));</script>
% </html>
% 
