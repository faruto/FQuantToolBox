function [ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = GetStockXRD_Web(StockCode)
% Modified by LiYang_faruto
% based on Chandeman
%% 调用格式：
%       [ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = F_Stock_XRD_DataImport(StockCode,Stock_Name)
% 输入： StockCode → 股票代码 StockCode = '600001';
%        Stock_Name → 股票名称
% 输出:  Web_XRD_Data → 除权除夕数值型数据
%        Web_XRD_Cell_1 → 分红送股文本型数据
%        Web_XRD_Cell_2 → 配股文本型数据
% http://vip.stock.finance.sina.com.cn/corp/go.php/vISSUE_ShareBonus/stockid/600083.phtml
% http://stockdata.stock.hexun.com/2009_fhzzgb_600588.shtml
% 
%% 输入输出预处理
if nargin < 1 || isempty(StockCode)
    StockCode = '600588';
end

% 股票代码预处理，目标代码demo '600588'
if strcmpi(StockCode(1),'s') 
    StockCode = StockCode(3:end);
end
if strcmpi(StockCode(end),'h') ||  strcmpi(StockCode(end),'z')
    StockCode = StockCode(1:end-2);
end

Web_XRD_Data = [];
Web_XRD_Cell_1 = [];
Web_XRD_Cell_2 = [];
%% 网页读取
URL = ['http://vip.stock.finance.sina.com.cn/corp/'...
    'go.php/vISSUE_ShareBonus/stockid/'...
     StockCode ,'.phtml'];
if verLessThan('matlab', '8.3')
    [Web_Url_Countent, status] = urlread_General(URL, 'TimeOut', 60,'Charset', 'gb2312');
else
    [Web_Url_Countent, status] = urlread(URL, 'TimeOut', 60,'Charset', 'gb2312');
end
if status == 0
    str = ['urlread error:网页读取失败！请检查输入的网址或网络连接情况！'];
    disp(str);
    return;
end

Web_Url_Expression = '<tbody>.*</a></td>';
[~,Web_Url_Matches] = ...
regexp(Web_Url_Countent,Web_Url_Expression,'tokens','match');

%% 数据提取

Web_Ori_Countent = char(Web_Url_Matches);
Web_Ori_Expression = '>';
[~,Web_Ori_Matches] = regexp(Web_Ori_Countent,Web_Ori_Expression,'match','split');

%% 数据整理

Web_Ori_Matches_length = length(Web_Ori_Matches);
Intermediate_variable_k = Web_Ori_Matches_length;
Intermediate_variable_Matches = char(Web_Ori_Matches);
if isempty(Intermediate_variable_Matches)
    fprintf([StockCode,'→暂无除权除息数据\n'])
    Web_XRD_Data = [];
    Web_XRD_Cell_1 = [];
    Web_XRD_Cell_2 = [];
    return;
end

% 找出分红增股&配股临界位置

for Intermediate_variable_i = 1 : length(Intermediate_variable_Matches(:,1))
    if strcmp(Intermediate_variable_Matches(Web_Ori_Matches_length + 1 - Intermediate_variable_i,1:7) , '<strong')
        Intermediate_variable_k = Web_Ori_Matches_length + 1 - Intermediate_variable_i;
        break
    end
end
 
% 分红

Intermediate_variable_j = 1;
Intermediate_variable_q1 = repmat(1:7,1,ceil(Web_Ori_Matches_length/7))';
for Intermediate_variable_i = 1 : Intermediate_variable_k
    if ~isempty(str2num(Intermediate_variable_Matches(Intermediate_variable_i,1))) || Intermediate_variable_Matches(Intermediate_variable_i,1) == '-'
        Web_XRD_Cell_1{ceil(Intermediate_variable_j/7),Intermediate_variable_q1(Intermediate_variable_j)} =  ...
            Intermediate_variable_Matches(Intermediate_variable_i,1:find(Intermediate_variable_Matches(Intermediate_variable_i,:)=='<')-1);
        Intermediate_variable_j = Intermediate_variable_j + 1;
    end
end

Web_XRD_Cell_1 = [{'公告日期','送股（股）','转增（股）','派息（税前）（元）',...
    '除权除息日', '股权登记日','红股上市日'};Web_XRD_Cell_1];

% 找出无效数据

[Web_XRD_Cell_1_Row_1,Web_XRD_Cell_1_Column_1] = size(Web_XRD_Cell_1);
Intermediate_variable_j = 0;
Intermediate_variable_l = ones(Web_XRD_Cell_1_Row_1,1);
for Intermediate_variable_i = 1 : Web_XRD_Cell_1_Row_1
    if strcmp(Web_XRD_Cell_1(Intermediate_variable_i,5),'--') || ...
            strcmp(Web_XRD_Cell_1(Intermediate_variable_i,5),'除权除息日')
        Intermediate_variable_l(Intermediate_variable_i,1) = 0;
        Intermediate_variable_j = Intermediate_variable_j + 1;
    end
end

% 将分红增股文本数据转成数值型数据

temp = Web_XRD_Cell_1(Intermediate_variable_l==1,5);
if isempty( temp )
    fprintf([StockCode,'→暂无除权除息数据\n'])
    Web_XRD_Data = [];
    Web_XRD_Cell_1 = [];
    Web_XRD_Cell_2 = [];
    return;    
end

Web_XRD_Data = zeros(Web_XRD_Cell_1_Row_1 - Intermediate_variable_j ,6);
Web_XRD_Data(:,1)  = datenum(Web_XRD_Cell_1(Intermediate_variable_l==1,5));          % 除权除息日

Web_XRD_Data(:,2)  = cellfun(@str2num,Web_XRD_Cell_1(Intermediate_variable_l==1,2)); % 送股
Web_XRD_Data(:,3)  = cellfun(@str2num,Web_XRD_Cell_1(Intermediate_variable_l==1,3)); % 转增
Web_XRD_Data(:,4)  = cellfun(@str2num,Web_XRD_Cell_1(Intermediate_variable_l==1,4)); % 派息

%% 配股数据处理

% 配股
[TableTotalNum,TableCell] = GetTableFromWeb(URL);

TableInd = 20;
TempCell = TableCell{TableInd};
TempCell = TempCell(3,:);

if size(TempCell,2) == 1 || strcmpi(TempCell{1,1},'暂时没有数据！')
    Web_XRD_Cell_2 = [];
else
    TempCell = TempCell(:,1:9);

    Web_XRD_Cell_2 = [{'公告日期','配股方案（每10股配股股数）','配股价格（元）',...
        '基准股本（万股）','除权除息日','股权登记日','缴款起始日','缴款终止日',...
        '配股上市日'};TempCell];

    % 合并分红增股与配股数据

    [Web_XRD_Cell_2_Row,Web_XRD_Cell_2_Column_2] = size(Web_XRD_Cell_2);
    Intermediate_variable_XRDCell2 = zeros(Web_XRD_Cell_2_Row-1,3);
    Intermediate_variable_XRDCell2(:,1) = datenum(Web_XRD_Cell_2(2:end,5));
    Intermediate_variable_XRDCell2(:,2) = cellfun(@str2num,Web_XRD_Cell_2(2:end,2));
    Intermediate_variable_XRDCell2(:,3) = cellfun(@str2num,Web_XRD_Cell_2(2:end,3));

    for Intermediate_variable_i = 1 : Web_XRD_Cell_2_Row-1
        Intermediate_variable_location = ...
            find(Web_XRD_Data(:,1)==Intermediate_variable_XRDCell2(Intermediate_variable_i,1));
        if ~isempty(Intermediate_variable_location)
            Web_XRD_Data(Intermediate_variable_location,5:6) = ...
                Intermediate_variable_XRDCell2(Intermediate_variable_i,2:3);
        else
            Web_XRD_Data(end+1,:) = ...
                [Intermediate_variable_XRDCell2(Intermediate_variable_i,1),0,0,0,...
                Intermediate_variable_XRDCell2(Intermediate_variable_i,2:3)];
        end
    end    
end

% if Intermediate_variable_k ~= Web_Ori_Matches_length
%     
%     Intermediate_variable_j = 1;
%     Intermediate_variable_q2 = repmat(1:9,1,ceil(Web_Ori_Matches_length/9))';
%     for Intermediate_variable_i = Intermediate_variable_k : Web_Ori_Matches_length
%         if ~isempty(str2num(Intermediate_variable_Matches(Intermediate_variable_i,1))) || Intermediate_variable_Matches(Intermediate_variable_i,1) == '-'
%             Web_XRD_Cell_2{ceil(Intermediate_variable_j/9),Intermediate_variable_q2(Intermediate_variable_j)} =  ...
%                 Intermediate_variable_Matches(Intermediate_variable_i,1:find(Intermediate_variable_Matches(Intermediate_variable_i,:)=='<')-1);
%             Intermediate_variable_j = Intermediate_variable_j + 1;
%         end
%     end
% 
%     Web_XRD_Cell_2 = [{'公告日期','配股方案（每10股配股股数）','配股价格（元）',...
%         '基准股本（万股）','除权除息日','股权登记日','缴款起始日','缴款终止日',...
%         '配股上市日'};Web_XRD_Cell_2];
% 
%     % 合并分红增股与配股数据
% 
%     [Web_XRD_Cell_2_Row,Web_XRD_Cell_2_Column_2] = size(Web_XRD_Cell_2);
%     Intermediate_variable_XRDCell2 = zeros(Web_XRD_Cell_2_Row-1,3);
%     Intermediate_variable_XRDCell2(:,1) = datenum(Web_XRD_Cell_2(2:end,5));
%     Intermediate_variable_XRDCell2(:,2) = cellfun(@str2num,Web_XRD_Cell_2(2:end,2));
%     Intermediate_variable_XRDCell2(:,3) = cellfun(@str2num,Web_XRD_Cell_2(2:end,3));
% 
%     for Intermediate_variable_i = 1 : Web_XRD_Cell_2_Row-1
%         Intermediate_variable_location = ...
%             find(Web_XRD_Data(:,1)==Intermediate_variable_XRDCell2(Intermediate_variable_i,1));
%         if ~isempty(Intermediate_variable_location)
%             Web_XRD_Data(Intermediate_variable_location,5:6) = ...
%                 Intermediate_variable_XRDCell2(Intermediate_variable_i,2:3);
%         else
%             Web_XRD_Data(end+1,:) = ...
%                 [Intermediate_variable_XRDCell2(Intermediate_variable_i,1),0,0,0,...
%                 Intermediate_variable_XRDCell2(Intermediate_variable_i,2:3)];
%         end
%     end
% else
%     Web_XRD_Cell_2 = [];
% end

Web_XRD_Data(:,1)  = str2num( datestr(Web_XRD_Data(:,1),'yyyymmdd') ); 

Web_XRD_Data = sortrows(Web_XRD_Data,1);