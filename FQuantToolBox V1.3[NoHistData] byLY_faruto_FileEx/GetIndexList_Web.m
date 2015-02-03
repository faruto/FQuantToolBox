function [IndexList] = GetIndexList_Web
% 获取沪深指数名称和代码
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% 输入输出预处理

%{
上海指数
http://hqdigi2.eastmoney.com/EM_Quote2010NumericApplication/index.aspx?
type=s&sortType=A&sortRule=1&pageSize=1000&page=1
&jsName=quote_123&style=15
&token=44c9d251add88e27b65ed86506f6e5da&_g=0.8707584564359134

深圳指数
http://hqdigi2.eastmoney.com/EM_Quote2010NumericApplication/index.aspx?
type=s&sortType=A&sortRule=1&pageSize=1000&page=1&
jsName=quote_123&style=25
&token=44c9d251add88e27b65ed86506f6e5da&_g=0.2184837315930359
%}

IndexList = [];

charset = 'utf-8';
%% 获取数据-上海指数

URL = ['http://hqdigi2.eastmoney.com/EM_Quote2010NumericApplication/index.aspx?' ...
    'type=s&sortType=A&sortRule=1&pageSize=1000&page=1' ...
    '&jsName=quote_123&style=15' ...
    '&token=44c9d251add88e27b65ed86506f6e5da&_g=0.8707584564359134'];

if verLessThan('matlab', '8.3')
    [URLchar, status] = urlread_General(URL, 'Charset', charset, 'TimeOut', 60);
else
    [URLchar, status] = urlread(URL, 'Charset', charset, 'TimeOut', 60);
end
if status == 0
    str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
    disp(str);
    return;
end

URLString = java.lang.String(URLchar);

expr = ['"','.*?', ...
        '"'];
Content = regexpi(URLchar, expr,'match');
if ~isempty( Content )
    Len = numel(Content);
    
    shIndexList = cell(Len,3);
    
    for i = 1:Len
        tC = Content{i};
        ind = find(tC == ',');
        shIndexList{i,1} = tC(ind(2)+1:ind(3)-1);
        shIndexList{i,2} = ['sh',tC(ind(1)+1:ind(2)-1)];
    end
    
    temp = shIndexList(:,2);
    temp = cell2mat(temp);
    temp = temp(:,3:end);
    CodeDouble = str2num(temp);
    CodeCell = num2cell(CodeDouble);
    shIndexList(:,3) = CodeCell;
end
%% 获取数据-深圳指数

URL = ['http://hqdigi2.eastmoney.com/EM_Quote2010NumericApplication/index.aspx?' ...
    'type=s&sortType=A&sortRule=1&pageSize=1000&page=1' ...
    '&jsName=quote_123&style=25' ...
    '&token=44c9d251add88e27b65ed86506f6e5da&_g=0.8707584564359134'];

if verLessThan('matlab', '8.3')
    [URLchar, status] = urlread_General(URL, 'Charset', charset, 'TimeOut', 60);
else
    [URLchar, status] = urlread(URL, 'Charset', charset, 'TimeOut', 60);
end
if status == 0
    str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
    disp(str);
    return;
end

URLString = java.lang.String(URLchar);

expr = ['"','.*?', ...
        '"'];
Content = regexpi(URLchar, expr,'match');
if ~isempty( Content )
    Len = numel(Content);
    
    szIndexList = cell(Len,3);
    
    for i = 1:Len
        tC = Content{i};
        ind = find(tC == ',');
        szIndexList{i,1} = tC(ind(2)+1:ind(3)-1);
        szIndexList{i,2} = ['sz',tC(ind(1)+1:ind(2)-1)];
    end
    
    temp = szIndexList(:,2);
    temp = cell2mat(temp);
    temp = temp(:,3:end);
    CodeDouble = str2num(temp);
    CodeCell = num2cell(CodeDouble);
    szIndexList(:,3) = CodeCell;
end

%% IndexList
IndexList = [shIndexList;szIndexList];