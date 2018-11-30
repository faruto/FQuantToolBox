function [NewsDataCell] = SinaSearchAdvanced(StringIncludeAll,BeginDate,EndDate,ChannelFlag)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%{
http://search.sina.com.cn/?c=news
&q=600588&range=all
&time=custom&stime=2014-12-23&etime=2014-12-31
&num=20&col=1_7
%}
%% 输入输出预处理
Charset = 'gb2312';
if nargin < 4 || isempty(ChannelFlag)
    % 新浪搜索频道选择 1-财经频道 2-新闻频道
    ChannelFlag = 1;
end
if nargin < 3 || isempty(EndDate)
    EndDate = '2014-12-26';
end
if nargin < 2 || isempty(BeginDate)
    BeginDate = '2014-12-26';
end
if nargin < 1 || isempty(StringIncludeAll)
    StringIncludeAll = '600588';
end

% 股票代码预处理，目标代码demo '600588'
if strcmpi(StringIncludeAll(1),'s')
    StringIncludeAll = StringIncludeAll(3:end);
end
if strcmpi(StringIncludeAll(end),'h') ||  strcmpi(StringIncludeAll(end),'z')
    StringIncludeAll = StringIncludeAll(1:end-2);
end

% 日期预处理，目标形式2014-12-29
ind = find( BeginDate == '-',1 );
if isempty(ind)
    BeginDate = [BeginDate(1:4),'-',BeginDate(5:6),'-',BeginDate(7:end)];
end
ind = find( EndDate == '-',1 );
if isempty(ind)
    EndDate = [EndDate(1:4),'-',EndDate(5:6),'-',EndDate(7:end)];
end

NewsDataCell = [];
%% URL生成

%{
http://search.sina.com.cn/?c=news
&q=600588&range=all
&time=custom&stime=2014-12-23&etime=2014-12-31
&num=20&col=1_7
%}

% "包含以下全部的关键词"对应的输入字符，中文字符需要转换成GB2312编码
temp = Unicode2URLHexCode_Ch(StringIncludeAll);
q = temp;

% 开始日期
stime = BeginDate;
% 结束日期
etime = EndDate;

% 搜索结果显示条数(选择搜索结果显示的条数)
num = '20';
% 新浪搜索频道选择
if ChannelFlag == 1
    col = '1_7';
end
if ChannelFlag == 2
    col = '1_3';
end

%{
http://search.sina.com.cn/?c=news
&q=600588&range=all
&time=custom&stime=2014-12-23&etime=2014-12-31
&num=20&col=1_7
%}

URL = ['http://search.sina.com.cn/?c=news', ...
    '&q=',q,'&range=all&time=custom&stime=',stime,...
    '&etime=',etime,'&num=',num,'&col=',col];


%% 数据获取

if verLessThan('matlab', '8.3')
    [URLchar, status] = urlread_General(URL, 'Charset', Charset, 'TimeOut', 60);
else
    [URLchar, status] = urlread(URL, 'Charset', Charset, 'TimeOut', 60);
end
if status == 0
    str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
    disp(str);
    return;
end

URLString = java.lang.String(URLchar);
%% 正则处理

DataCell = SinaURLcharParse(URLchar);

%% 获取其他页码的搜索结果

DCell = [];

expr = ['<!-- 分页 begin -->','.*?', ...
    '<!-- 分页 end -->'];
PageStr = regexpi(URLchar, expr,'match');
PageStr = PageStr{1};

expr = ['<a href=','.*?', ...
        '</a>'];

MatchStr = regexpi(PageStr, expr,'match');
Len = numel(MatchStr);

if Len > 0

    for i = 1:Len-1
        temp = MatchStr{i};
        expr = ['"'];
        out = regexpi(temp, expr,'split');
        out = out{2};  
        
        tURL = ['http://search.sina.com.cn/',out];
        tURL = regexprep(tURL,'&amp;','&');
        
        if verLessThan('matlab', '8.3')
            [URLchar, status] = urlread_General(tURL, 'Charset', Charset, 'TimeOut', 60);
        else
            [URLchar, status] = urlread(tURL, 'Charset', Charset, 'TimeOut', 60);
        end
        
        if status == 0
            str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
            disp(str);
            URLchar = [];
        end
        
        tData = SinaURLcharParse(URLchar);
        DCell = [DCell;tData(2:end,:)];
    end
    
end

%% 输出

NewsDataCell = [DataCell;DCell];

temp1 = NewsDataCell(1,:);
temp2 = NewsDataCell(end:(-1):2,:);

NewsDataCell = [temp1;temp2];
end

% [EOF_Main]

%% Sub Function
function DataCell = SinaURLcharParse(URLchar)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% 输入输出预处理
if isempty( URLchar )
    DataCell = [];
    return;
end
DataCell = [];
%%

% &rsv_page=2
expr = ['<!-- 文字新闻.*?begin -->','.*?',...
    '<!-- 文字新闻.*?end --> '];
[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = ...
    regexpi(URLchar, expr);
Len = numel(matchstring);
if Len>1
    ColNum = 4;
    DataCell = cell(Len, ColNum);
    % Head = {'DateTime','Title','Source','URL'};
    for i = 1:Len
        StringTemp = matchstring{i};
        
        expr = ['<a href=','.*?',...
            '</a>'];
        TitleURL = regexpi(StringTemp, expr,'match');
        TitleURL = TitleURL{1};
        
        expr = ['>','.*?',...
            '</a>'];
        out = regexpi(TitleURL, expr,'match');
        out = out{1};
        temp = out(2:end-4);
        % % % 简易预处理清洗，剔除<em> </em>
        expr = ['<.*?em>'];
        replace = '';
        temp = regexprep(temp,expr,replace);
        % Title
        DataCell{i,2} = temp;
        
        expr = ['"'];
        out = regexpi(TitleURL, expr,'split');
        out = out{2};
        temp = out;
        % URL
        DataCell{i,4} = temp;
        
        
        expr = ['<span class="fgray_time">','.*?',...
            '</span>'];
        AuthorDate = regexpi(StringTemp, expr,'match');
        AuthorDate = AuthorDate{1};
        expr = ['>','.*?',...
            '</span>'];
        out = regexpi(AuthorDate, expr,'match');
        out = out{1};
        temp = out(2:end-7);
        
        expr = [' '];
        out = regexpi(temp, expr,'split');
        if numel(out) == 3
            %　Author Source
            DataCell{i,3} = out{1};
            % DateTime
            DataCell{i,1} = [out{2},' ',out{3}];
        else
            % 有的可能没有Author i.e. 网站名称（作者名称）没有
            %　Author Source
            DataCell{i,3} = [];
            % DateTime
            DataCell{i,1} = [out{1},' ',out{2}];
        end
    end
    Head = {'DateTime','Title','Source','URL'};
    DataCell = [Head;DataCell];
    
    
end

end