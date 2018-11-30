function [DataOutput, Status] = GetBasicInfo_Mat(Code,BeginDate,EndDate,Type,Field)
% 获取基本信息 比如IPOdate
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/03/01
% % Input:
%
% Type
% Stock：获取股票数据 Future:获取期货数据
% StockIndex：获取股票相关指数数据
% FutureIndex：获取期货相关指数数据
% Field
% IPOdate
% Name
%% 输入输出预处理
DataOutput = [];
Status = [];
Status = 0;

if nargin < 5 || isempty(Field)
    Field = 'IPOdate';
end
if nargin < 4|| isempty(Type)
    Type = 'Stock';
end
if nargin < 3 || isempty(EndDate)
    EndDate = '20150101';
end
if nargin < 2 || isempty(BeginDate)
    BeginDate = '20140101';
end
if nargin < 1 || isempty(Code)
    Code = 'sh600588';
end

if strcmpi(Type,'Stock') || strcmpi(Type,'gp') ...
        || strcmpi(Type,'gupiao') || strcmpi(Type,'s')
    % 代码预处理，目标代码demo 'sh600588'
    if Code(1,1) == '6'
        Code = ['sh',Code];
    end
    if Code(1,1) == '0'|| Code(1,1) == '3'
        Code = ['sz',Code];
    end
    
end

% 日期时间预处理，目标形式 '20140101'
BeginDate(BeginDate == '-') = [];
EndDate(EndDate == '-') = [];

BeginDate = str2double(BeginDate);
EndDate = str2double(EndDate);
if BeginDate>EndDate
    str = ['开始日期需要小于等于结束日期，请检查输入参数！'];
    disp(str);
    return;
end
%% 获取股票数据
if strcmpi(Type,'Stock') || strcmpi(Type,'gp') ...
        || strcmpi(Type,'gupiao') || strcmpi(Type,'s')
    
    CodeInput = Code;
    
    % % 获取上市日期
    if strcmpi(Field, 'IPOdate')
        
        IPOdate = [];
        FolderStr_StockInfo = ['./DataBase/Stock/StockInfo_mat'];
        FileString_StockInfo = [FolderStr_StockInfo,'/',CodeInput,'_StockInfo.mat'];
        if exist(FileString_StockInfo, 'file') == 2
            str = ['load ',FileString_StockInfo];
            eval(str);
            
            IPOdate = StockInfo.IPOdate;
            
        end
        
        DataOutput = IPOdate;
    end
    
    % % 获取股票名称
    if strcmpi(Field, 'Name')
        FileString = 'StockList.mat';
        MatObj = matfile(FileString,'Writable',true);
        [nrows, ncols]=size(MatObj,'StockList');
        
        if nrows>1
            CodeDouble = str2num( CodeInput(3:end) );
            
            SearchIndex = MatObj.StockList(:,3);
            
            SearchIndex = cell2mat(SearchIndex);
            
            ind = find( SearchIndex==CodeDouble,1 );
            if ~isempty(ind)
                
                DataOutput = MatObj.StockList(ind,1);
                
            end
            
        end
        
    end
    
end

