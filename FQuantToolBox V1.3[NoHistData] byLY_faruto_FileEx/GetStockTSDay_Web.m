function [StockDataDouble,adjfactor] = GetStockTSDay_Web(StockCode,BeginDate,EndDate)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% Input:
% StockCode:字符阵列型，表示证券代码，如sh600000
% BeginDate:字符阵列型，表示希望获取股票数据所在时段的开始日期，如20140101
% EndDate:字符阵列型，表示希望获取股票数据所在时段的结束日期，如20150101
% Output:
% StockDataDouble: 日期 开 高 低 收 量(股) 额(元) 复权因子（后复权因子）
% 前复权因子 等于 后复权因子 的倒序排列
% 涨跌幅复权方式
% 后复权价格 = 交易价*后复权因子
% 前复权价格 = 交易价/前复权因子

% 获取数据所使用的URL
% http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000562.phtml?year=1994&jidu=1
% http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/000562.phtml?year=1995&jidu=4
% http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?symbol=sz000562&end_date=20150101&begin_date=19940101
%% URL选择设定

URLflag = 2;

% 1 使用如下URL获取数据，但最多只能获取到20000101之后的数据，且无法获取成交额和复权因子，且数据有缺失
% http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?symbol=sz000562&end_date=20150101&begin_date=19940101
% 2 使用如下URL获取数据，可以获取自上市日开始的左右数据和复权因子 19900101 部分数据也有缺失 
% http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/000562.phtml?year=1995&jidu=4
% 类似的所有来自新浪的数据源都会有部分数据缺失
%% 输入输出预处理
if nargin < 3 || isempty(EndDate)
    EndDate = '20150101';
end
if nargin < 2 || isempty(BeginDate)
    BeginDate = '20100101';
end
if nargin < 1 || isempty(StockCode)
    StockCode = 'sh600588';
end

% 股票代码预处理，目标代码demo 'sh600588'
if 1 == URLflag
    if StockCode(1,1) == '6'
        StockCode = ['sh',StockCode];
    end
    if StockCode(1,1) == '0'|| StockCode(1,1) == '3'
        StockCode = ['sz',StockCode];
    end
end

% 股票代码预处理，目标代码demo '600588'
if 2 == URLflag
    if strcmpi(StockCode(1),'s')
        StockCode = StockCode(3:end);
    end
    if strcmpi(StockCode(end),'h') ||  strcmpi(StockCode(end),'z')
        StockCode = StockCode(1:end-2);
    end
end

% 输入日期预处理
if ~ischar( BeginDate )
    BeginDate = num2str(BeginDate);
end
BeginDate(BeginDate == '-') = [];
if ~ischar( EndDate )
    EndDate = num2str(EndDate);
end
EndDate(EndDate == '-') = [];

StockDataDouble = [];
adjfactor = [];

%% URLflag = 2
if 2 == URLflag
    % % http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/000562.phtml?year=1995&jidu=4
    
    sYear = str2double(BeginDate(1:4));
    eYear = str2double(EndDate(1:4));
    sM = str2double(BeginDate(5:6));
    eM = str2double(EndDate(5:6));
    for i = 1:4
        if sM>=3*i-2 && sM<=3*i
            sJiDu = i;
        end
        if eM>=3*i-2 && eM<=3*i
            eJiDu = i;
        end
    end

    Len = (eYear-sYear)*240+250;
    DTemp = cell(Len,8);
    rLen = 1;
    for i = sYear:eYear
        for j = 1:4
%             YearDemo = i
%             JiDuDemo = j
            if i == sYear && j < sJiDu
                continue;
            end
            if i == eYear && j > eJiDu
                continue;
            end           
%             YearDemo = i
%             JiDuDemo = j            
            
            URL = ...
                ['http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/' ...
                StockCode '.phtml?year=' num2str(i) '&jidu=' num2str(j)];

            [~,TableCell] = GetTableFromWeb(URL);
            
            if iscell( TableCell ) && ~isempty(TableCell)
                TableInd = 20;
                FIndCell = TableCell{TableInd};
            else
                FIndCell = [];
            end

            % 日期 开 高 收 低 量 额 复权因子
            FIndCell = FIndCell(3:end,:);
            FIndCell = FIndCell(end:(-1):1,:);
            
            if ~isempty(FIndCell)
                LenTemp = size(FIndCell,1);
                
                DTemp(rLen:(rLen+LenTemp-1),:) = FIndCell;
                rLen = rLen+LenTemp;
            end
        end
    end
    DTemp(rLen:end,:) = [];
    % 由于新股刚上市或网络等原因，DTemp为空
    if isempty(DTemp)
        return;
    end
    % 日期 开 高 收 低 量 额 复权因子
    % 调整成
    % 日期 开 高 低 收 量 额 复权因子
    Low = DTemp(:,5);
    Close = DTemp(:,4);
    DTemp = [ DTemp(:,1:3),Low,Close,DTemp(:,6:end) ];
    
    sTemp = cell2mat(DTemp(:,1));
    sTemp = datestr( datenum(sTemp,'yyyy-mm-dd'),'yyyymmdd' );
    Date = str2num( sTemp );
    
    Temp = DTemp(:,2:end);
    Data = cellfun(@str2double,Temp);
    
    % 由后复权数据反向生成 除权除息数据
    for i = 1:4
        Data(:,i) = Data(:,i)./Data(:,7);
    end
    Data(:,1:4) = round( Data(:,1:4)*100 )/100;
    
    DTemp = [Date, Data];
    
    % BeginDate,EndDate
    sDate = str2double(BeginDate);
    eDate = str2double(EndDate);
    
    [~,sInd] = min( abs(DTemp(:,1)-sDate) );
    [~,eInd] = min( abs(DTemp(:,1)-eDate) );
    
    StockDataDouble = DTemp(sInd:eInd,:);
    adjfactor = StockDataDouble(:,end);
end
%% URLflag = 1
if 1 == URLflag
    URL=['http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?symbol=' StockCode '&end_date=' EndDate '&begin_date=' BeginDate];
    
    [URLchar, status] = urlread(URL,'TimeOut', 60);
    if status == 0
        str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
        disp(str);
        return;
    end
    URLString = java.lang.String(URLchar);
    
    expr = ['<content d=','.*?',...
        'bl="" />'];
    [matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = regexpi(URLchar, expr);
    Len = numel(matchstring);
    StockDataDouble = zeros(Len,6);
    
    for i = 1:Len
        strtemp = matchstring{i};
        
        [sind, eind] = regexpi(strtemp, 'd=.*? o');
        temp = strtemp(sind+3:eind-3);
        temp = temp([1:4,6:7,9:10]);
        StockDataDouble(i,1) = str2num(temp);
        
        [sind, eind] = regexpi(strtemp, 'o=.*? h');
        temp = strtemp(sind+3:eind-3);
        StockDataDouble(i,2) = str2num(temp);
        
        [sind, eind] = regexpi(strtemp, 'h=.*? c');
        temp = strtemp(sind+3:eind-3);
        StockDataDouble(i,3) = str2num(temp);
        
        [sind, eind] = regexpi(strtemp, 'l=.*? v');
        temp = strtemp(sind+3:eind-3);
        StockDataDouble(i,4) = str2num(temp);
        
        [sind, eind] = regexpi(strtemp, 'c=.*? l');
        temp = strtemp(sind+3:eind-3);
        StockDataDouble(i,5) = str2num(temp);
        
        [sind, eind] = regexpi(strtemp, 'v=.*? b');
        temp = strtemp(sind+3:eind-3);
        StockDataDouble(i,6) = str2num(temp);
    end
end