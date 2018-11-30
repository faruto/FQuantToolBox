function [DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode)
% 获取期货品种成交量和持仓量排名
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 2 || isempty(FuturesCode)
    FuturesCode = 'IF';
end
if nargin < 2 || isempty(MarketCode)
    MarketCode = 'CFFEX';
end
if nargin < 1 || isempty(DateStr)
    DateStr = '20141215';
end

if strcmpi(MarketCode,'ZJ') || strcmpi(MarketCode,'ZJS')
    MarketCode = 'CFFEX';
end
if strcmpi(MarketCode,'SH') || strcmpi(MarketCode,'SQS')
    MarketCode = 'SHFE';
end
if strcmpi(MarketCode,'DL') || strcmpi(MarketCode,'DSS')
    MarketCode = 'DCE';
end
if strcmpi(MarketCode,'ZZ') || strcmpi(MarketCode,'ZSS')
    MarketCode = 'CZCE';
end
FuturesCode = upper(FuturesCode);

StatusOut = 1;
DataCell = [];
%% 中金所
% 获取数据网址http://www.cffex.com.cn/fzjy/mrhq/
% http://www.cffex.com.cn/fzjy/mrhq/201412/01/index.xml
% http://www.cffex.com.cn/fzjy/ccpm/201412/15/IF.xml
% http://www.cffex.com.cn/fzjy/ccpm/201412/15/TF.xml
% % 字段名字 举例
%{
<dailydata>
<instrumentid>IF1412</instrumentid>
<tradingday>20141201</tradingday>
<openprice>2820.0</openprice>
<highestprice>2843.2</highestprice>
<lowestprice>2797.0</lowestprice>
<closeprice>2809.2</closeprice>
<openinterest>166358.0</openinterest>
<settlementprice>2807.4</settlementprice>
<presettlementprice>2796.4</presettlementprice>
<volume>1141574</volume>
<turnover>9.6594369276E11</turnover>
<productid>IF</productid>
<delta/>
<segma/>
</dailydata>
%}
if strcmpi(MarketCode, 'CFFEX')
    Mcode = upper(MarketCode);
    
    % % 获取网页内容
    
    datetemp = DateStr;
    dstring = [datetemp(1:6), '/', datetemp(7:end)];
    
    url2Read = ['http://www.cffex.com.cn/fzjy/mrhq/', dstring, '/index.xml'];
    
    if verLessThan('matlab', '8.3')
        [URLchar,status] = urlread_General(url2Read, 'Charset', 'GBK', 'TimeOut', 10);
    else
        [URLchar,status] = urlread(url2Read, 'Charset', 'GBK', 'TimeOut', 10);
    end
    URLString = java.lang.String(URLchar);
    
    if status == 0
        StatusOut = 0;
        DataCell = [];
        return;
    end
    
    Field2Get = {'productid','instrumentid','tradingday','openprice','highestprice','lowestprice' ...
        ,'closeprice','openinterest','settlementprice','presettlementprice','volume','turnover'};
    DTemp = FieldGet(URLchar, Field2Get{1});
    if isempty(DTemp)
        StatusOut = 0;
        DataCell = [];
        return;
    end
    RowNum = length(DTemp);
    ColNum = length(Field2Get);
    tData = cell(RowNum,ColNum);
    for i = 1:ColNum
        DTemp = FieldGet(URLchar, Field2Get{i});
        
        tData(:,i) = DTemp;
    end
    
    ind = cellfun(@(x)strcmpi(x,FuturesCode),tData(:,1));
    if sum(ind) == 0
        StatusOut = 0;
        DataCell = [];
        return;        
    end
    DataCell = [Field2Get;tData(ind,:)];
end
%% 上期所
if strcmpi(MarketCode, 'SHFE')
    Mcode = upper(MarketCode);
    
end

%% 大交所
if strcmpi(MarketCode, 'DCE')
    Mcode = upper(MarketCode);
    
end

%% 郑交所
if strcmpi(MarketCode, 'CZCE')
    Mcode = upper(MarketCode);
    
end

%% End of GetFutureDay_Web
end




%%  FieldGet-sub function
function DataCell = FieldGet(String, FieldString)
% FieldGet
% by LiYang
% Email:farutoliyang@gmail.com
% 2014/01/10
expr = ['<',FieldString,'>.*?</',FieldString,'>'];
[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = regexpi(String, expr);

Len = length(matchstring);
DataCell = cell(Len, 1);

for i = 1:Len
    strtemp = matchstring{1,i};
    [sind, eind] = regexpi(strtemp, '>.*?<');
    
    temp = strtemp(sind+1:eind-1);
    ind = find(temp == ' ');
    if ~isempty(ind)
        temp = temp(1:ind-1);
    end
    DataCell{i,1} = temp;
end
end