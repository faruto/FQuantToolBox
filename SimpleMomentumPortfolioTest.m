function SimpleMomentumPortfolioTest
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% A Little Clean Work
format compact;
%% LoadData

%% GetDataFromWeb
tic;
StockCodeCell = {'600588sh','sh600030','600446','300024sz','sz000001','600570sh'};
StockNameCell = {'用友网络','中信证券','金证股份','机器人','平安银行','恒生电子'};

BeginDate = '20100101';
EndDate = '20150101';
Len = length(StockCodeCell);
% StockDataCell = cell(length(StockCodeCell),1);
% for i = 1:length(StockCodeCell)
%     StockCode = StockCodeCell{i};
%     [StockDataCell{i}] = GetStockTSDay_Web(StockCode,BeginDate,EndDate);
% end

toc;

% save StockDataCellTestRaw
%% Load Raw Data

load StockDataCellTestRaw.mat;
%% 前复权数据生成
StockDataCellXRD = StockDataCell;
for i = 1:Len
    StockData = StockDataCell{i};
    AdjFlag = 1;
    [StockDataCell{i}] = CalculateStockXRD(StockData, [], AdjFlag);
end
%% 交易日 时间轴对齐 填充
tic;
sdate = datenum(BeginDate,'yyyymmdd');
edate = datenum(EndDate,'yyyymmdd');
bdates = busdays(sdate, edate, 'Daily');
Bdates = str2num( datestr(bdates,'yyyymmdd') );

StockDataCell_pre = StockDataCell;
for i = 1:Len
    tMat = zeros(length(Bdates),8);
    tMat(:,1) = Bdates;
    
    tMat_pre = StockDataCell{i};
    for j = 1:length(Bdates)
        tD = Bdates(j);
        ind = find(tMat_pre(:,1)<=tD, 1,'last');
        tMat(j,2:end) = tMat_pre(ind,2:end);
    end
    
    StockDataCell{i} = tMat;
end
toc;
%% K线图展示

% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
% H = [];
% for i = 1:Len
%     
%     OHLC = StockDataCell{i}(:,2:5);
%     KplotNew(OHLC);
%     Dates = StockDataCell{i}(:,1);
%     LabelSet(gca, Dates, [], [], 1);
%     hold on;
%     
%     Close = StockDataCell{i}(:,5);
%     S = 5;
%     L = 20;
%     [SMA, LMA] = movavg(Close, S, L);
%     SMA(1:S-1) = NaN;
%     LMA(1:L-1) = NaN;
%     tH = plot(LMA,'LineWidth',1.5,'Color',[i/Len,0,1]);
%     H = [H,tH];
%     
% end
% M = StockNameCell;
% legend(H, M);
%% 每只股票累计收益
StockMat = zeros(length(Bdates), Len+1);
StockMat(:,1) = Bdates;
for i = 1:Len
    StockMat(:,i+1) = StockDataCell{i}(:,5);
end

Ret = tick2ret(StockMat(:,2:end));
CumRet = cumprod((1+Ret))-1;

scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
plot(CumRet,'LineWidth',1.5);
xlim([0,length(Bdates)+1]);
Dates = StockMat(2:end,1);
LabelSet(gca, Dates, [], [], 1);

M = StockNameCell;
H = legend(M);
H.Orientation = 'horizontal';
H.FontWeight = 'Bold';
H.FontSize = 12;
H.Location = 'northoutside';

str = '股票累计收益';
H = title(str);
H.FontWeight = 'Bold';
H.FontSize = 15;
%% Test
lookback = 5;
weight = calc_mom(StockMat,lookback);

lb = 90;
hold = 90;
SR = strat_sr(StockMat, lb, hold)
%% calc
tic;
lookbacks = 20:5:90;
holdings = 20:5:100;

DD = zeros(length(lookbacks), length(holdings));

for i = 1:length(lookbacks)
    for j = 1:length(holdings)
        lb = lookbacks(i);
        hold = holdings(j);
        DD(i,j) = strat_sr(StockMat, lb, hold);
    end
end
toc;
%% HeatPlot
temp = num2cell(lookbacks);
temp = cellfun(@num2str,temp,'UniformOutput',false);
YVarNames = temp;

temp = num2cell(holdings);
temp = cellfun(@num2str,temp,'UniformOutput',false);
XVarNames = temp;

XLabelString = 'Holding Period';
YLabelString = 'Lookack Period';
Fmatrixplot(DD,'ColorBar','On','XVarNames',XVarNames,'YVarNames',YVarNames,...
    'XLabelString',XLabelString,'YLabelString',YLabelString);

%% End

OverFlag = 1;

end



%% sub fun strat_sr
% ---------------------------------------------------
%  strat_sr
% ---------------------------------------------------
function SR = strat_sr(prices, lb, hold)
    SR = 0;
    [m,n] = size(prices);
    % 计算权重
    port = calc_mom(prices,lb);
    port(isnan(port)) = 0;
    
    % 计算组合收益
    PortResample = [];
    Returns = [];
    Ind = 1;
    for i = hold:hold:m
        PortResample(Ind,:) = port(i-hold+1,:);
        Returns(Ind,:) = prices(i,:);
        Returns(Ind,2:end) = (prices(i,2:end)-prices(i-hold+1,2:end))./prices(i-hold+1,2:end);

        Ind = Ind + 1;
    end
    port_rets = PortResample(:,2:end).*Returns(:,2:end);
    port_rets = sum(port_rets,2);
    % 计算年化Sharpe Ratio
    SR = mean(port_rets)/std(port_rets)*sqrt( 252/hold );

end


%% sub fun calc_mom 
% ---------------------------------------------------
%  calc_mom
% ---------------------------------------------------
function weight = calc_mom(price,lookback)
    weight = zeros(size(price));
    weight(:,1) = price(:,1);
    [m,n] = size(price);
    % weight(1:lookback,2:end) = nan;
    weight(1:lookback,2:end) = 0;
    for j = lookback+1:m 
        for i = 2:n
            tData = price(:,i);
            weight(j,i) =  (tData(j-1)-tData(j-lookback))/tData(j-lookback);
        end
        
        temp = weight(j,2:end);
        weight(j,2:end) = (temp-mean(temp))./std(temp);
    end
    
    weight(isnan(weight)) = 0;
end    