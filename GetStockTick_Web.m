function [StockTick,Header,StatusStr] = GetStockTick_Web(StockCode,BeginDate,SaveFlag)
% 获取某只股票某日交易明细数据
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% StockCode:字符阵列型，表示证券代码，如'sh600000'
% BeginDate:字符阵列型，表示希望获取股票数据所在时段的开始日期，如'2014-12-05'
% http://vip.stock.finance.sina.com.cn/quotes_service/view/vMS_tradehistory.php?symbol=sh600000&date=2006-03-05
% http://market.finance.sina.com.cn/downxls.php?date=2014-12-05&symbol=sh600000
%% 输入输出预处理
if nargin < 3 || isempty(SaveFlag)
    SaveFlag = 1;
end
if nargin < 2 || isempty(BeginDate)
    BeginDate = '2014-12-05';
end
if nargin < 1 || isempty(StockCode)
    StockCode = 'sh600588';
end

% 股票代码预处理，目标代码demo 'sh600588'
if StockCode(1,1) == '6'
    StockCode = ['sh',StockCode];
end
if StockCode(1,1) == '0'|| StockCode(1,1) == '3'
    StockCode = ['sz',StockCode];
end

ind = find(BeginDate == '-',1);
if isempty(ind)
    temp = [BeginDate(1:4),'-',BeginDate(5:6),'-',BeginDate(7:end)];
    BeginDate = temp;
end
StatusStr = [];
StockTick = [];
Header = {'成交时间','成交价','价格变动','成交量-手','成交额-元',...
    '性质-','（买盘：1，卖盘：-1，中性盘：0）'};
%% 先检查本地是否已经存在该数据
FolderStr = ['./DataBase/Stock/Tick_mat/',StockCode,'_Tick'];
FileString = [FolderStr,'/',StockCode,'_Tick_',BeginDate,'.mat'];
FileExist = 0;
if isdir( FolderStr )
    if exist(FileString, 'file') == 2
        FileExist = 1;
    end
    
    if 1 == FileExist
        str = ['load ',FileString];
        eval(str);
        return;
    end
end
%% urlread
URL=['http://market.finance.sina.com.cn/downxls.php?date=',BeginDate,'&symbol=',StockCode];

if verLessThan('matlab', '8.3')
    [URLchar, status] = urlread_General(URL,'TimeOut', 60,'Charset', 'gb2312');
else
    [URLchar, status] = urlread(URL,'TimeOut', 60,'Charset', 'gb2312');
end

if status == 0
    str = ['urlread error:数据获取失败！请检查网络连接情况或输入的参数！'];
    disp(str);
    StatusStr = str;
    return;
end

expr = ['当天没有数据'];
[matchstart,matchend,tokenindices,matchstring] = regexpi(URLchar, expr);

if ~isempty(matchstring)
    str = ['当天没有数据！请检查输入的参数！'];
    disp(str);
    StatusStr = str;
    return;
end

URLString = java.lang.String(URLchar);
%% 数据处理
delimiter = URLchar(6);

% Result = textscan(URLchar, '%s %s %s %s %s %s', 'delimiter', '	','BufSize',4095*3);
Result = textscan(URLchar, '%s %s %s %s %s %s', 'delimiter', '	');

temp = Result{1,1};
if size(temp, 1) == 1
    str = ['数据获取失败！可能数据为空或检查输入的参数！'];
    disp(str);
    StatusStr = str;
    return;    
end

temp = Result{1,1};
temp = temp(2:end);
DtimeStr = temp;
temp = Result{1,2};
temp = temp(2:end);
Price = temp;
temp = Result{1,3};
temp = temp(2:end);
PriceChg = temp;
temp = Result{1,4};
temp = temp(2:end);
Vol = temp;
temp = Result{1,5};
temp = temp(2:end);
Amt = temp;
temp = Result{1,6};
temp = temp(2:end);
SellBuyFlag = temp;

Len = size( DtimeStr,1 );
StockTick = zeros(Len,6);

DtimeStr = DtimeStr(end:(-1):1,:);
Price = Price(end:(-1):1,:);
PriceChg = PriceChg(end:(-1):1,:);
Vol = Vol(end:(-1):1,:);
Amt = Amt(end:(-1):1,:);
SellBuyFlag = SellBuyFlag(end:(-1):1,:);

for i = 1:Len

    tempT = DtimeStr{i};
    % control characters检查char(0:20)
    category = 'cntrl';
    tf = isstrprop(tempT, category);
    ind = find( tf==1 )';
    tempT(ind) = [];    
    temp = [BeginDate,' ',tempT];
    
    ind = find(tempT == ':');
    if ~isempty(ind) && length(ind) == 2
        temp = datenum( temp, 'yyyy-mm-dd HH:MM:SS');
    elseif ~isempty(ind) && length(ind) == 1
        temp = datenum( temp, 'yyyy-mm-dd HH:MM'); 
    end
    
    temp = datestr(temp,'yyyymmddHHMM.SS');
    temp = str2double(temp);
    ind = 1;
    if ~isempty(temp)
        StockTick(i,ind) = temp;
    else
        if i>1
            StockTick(i,ind) = StockTick(i-1,ind);
        end
    end
    
    temp = Price{i};
    % control characters检查char(0:20)
    category = 'cntrl';
    tf = isstrprop(temp, category);
    ind = find( tf==1 )';
    temp(ind) = [];
    temp = str2double(temp);
	ind = 2;
    if ~isempty(temp)
        StockTick(i,ind) = temp;
    else
        if i>1
            StockTick(i,ind) = StockTick(i-1,ind);
        end
    end
    
    temp = PriceChg{i};
    % control characters检查char(0:20)
    category = 'cntrl';
    tf = isstrprop(temp, category);
    ind = find( tf==1 )';
    temp(ind) = [];    
    temp = str2double(temp);
    ind = 3;
    if ~isempty(temp)
        StockTick(i,ind) = temp;
    else
        if i>1
            StockTick(i,ind) = StockTick(i-1,ind);
        end
    end
    
    temp = Vol{i};
    % control characters检查char(0:20)
    category = 'cntrl';
    tf = isstrprop(temp, category);
    ind = find( tf==1 )';
    temp(ind) = [];    
    temp = str2double(temp);
    ind = 4;
    if ~isempty(temp)
        StockTick(i,ind) = temp;
    else
        if i>1
            StockTick(i,ind) = StockTick(i-1,ind);
        end
    end
    
    temp = Amt{i};
    % control characters检查char(0:20)
    category = 'cntrl';
    tf = isstrprop(temp, category);
    ind = find( tf==1 )';
    temp(ind) = [];    
    temp = str2double(temp);
    ind = 5;
    if ~isempty(temp)
        StockTick(i,ind) = temp;
    else
        if i>1
            StockTick(i,ind) = StockTick(i-1,ind);
        end
    end
    
    temp = SellBuyFlag{i};
    ind = 6;
    if strcmpi(temp,'买盘')
        StockTick(i,ind) = 1;
    end
    if strcmpi(temp,'卖盘')
        StockTick(i,ind) = -1;
    end
    if strcmpi(temp,'中性盘')
        StockTick(i,ind) = 0;
    end
end
% StockTick = StockTick(end:(-1):1,:);
%% 存储数据
if 1 == SaveFlag && ~isempty( StockTick )
    try
        if ~isdir( FolderStr )
            mkdir( FolderStr );
        end
        save(FileString,'StockTick','Header','-v7.3');
    catch err
        str = ['日期时间：',datestr(now),' 数据保存失败：',err.message];
        fprintf('%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf('%s\n',str);
        end
    end
end