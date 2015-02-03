function [StockList,StockListFull] = GetStockList_Web(URL)
% 获取A股市场全部股票名称和代码
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 1 || isempty(URL)
    URL = ['http://quote.eastmoney.com/stocklist.html'];
end

StockList = [];
StockListFull = [];
%% 获取数据
if verLessThan('matlab', '8.3')
    [URLchar, status] = urlread_General(URL, 'Charset', 'GBK', 'TimeOut', 60);
else
    [URLchar, status] = urlread(URL, 'Charset', 'GBK', 'TimeOut', 60);
end
if status == 0
    str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
    disp(str);
    return;
end

URLString = java.lang.String(URLchar);

expr = ['<li><a target="_blank" href="http://quote.eastmoney.com/','.*?',...
        '</a></li>'];
[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = regexpi(URLchar, expr);
Len = numel(matchstring);
StockList = cell(Len,2);
for i = 1:Len
    strtemp = matchstring{i};
    [sind, eind] = regexpi(strtemp, '/s.*?.html');
    
    temp = strtemp(sind+1:eind-5);
    StockList{i,2} = temp;
    
    [sind, eind] = regexpi(strtemp, '">.*?<');
    temp = strtemp(sind+2:eind-9);
    StockList{i,1} = temp;
end
StockListFull = StockList;
StockList = [];

temp = StockListFull(:,2);
temp = cell2mat(temp);
temp = temp(:,3:end);
CodeDouble = str2num(temp);

% 60
t1 = (CodeDouble>=600000);
t2 = (CodeDouble<=609999);
t = logical(t1.*t2);
StockList = [StockList;StockListFull(t,:)];

% 00
t1 = (CodeDouble>=1);
t2 = (CodeDouble<=3000);
t = logical(t1.*t2);
StockList = [StockList;StockListFull(t,:)];

% 30
t1 = (CodeDouble>=300001);
t2 = (CodeDouble<=309999);
t = logical(t1.*t2);
StockList = [StockList;StockListFull(t,:)];

temp = StockList(:,2);
temp = cell2mat(temp);
temp = temp(:,3:end);
CodeDouble = str2num(temp);
CodeCell = num2cell(CodeDouble);
StockList = [StockList,CodeCell];