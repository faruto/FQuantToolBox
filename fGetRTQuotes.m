classdef fGetRTQuotes < handle
    %% fGetRTQuotes
    % 获取实时分笔数据
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        
        Code = '600036';
        
    end
    %% properties(SetAccess = private, GetAccess = public)
    properties(SetAccess = private, GetAccess = public)
        
        
    end
    
    %% properties(Access = protected)
    properties(Access = protected)
        
    end
    
    %% properties(Access = private)
    properties(Access = private)
        
    end
    
    %% methods
    
    methods
        %% fGetIndex()
        function obj = fGetIndex( varargin )
            
            
        end
        
        %% GetRTQuotes()
        function DataCell_Output = GetRTQuotes(obj)
            % % 获取实时分笔数据
            % % 股票、期货实时分笔数据
            % % 允许单次请求多个代码的实时数据
            
            StockNameList =  { ...
                '名称';'今开盘';'昨收盘';'当前价';'今最高';'今最低';...
                '竞买价，即“买一”报价';'竞卖价，即“卖一”报价'; ...
                '成交量，单位“股”';'成交额，单位“元”';...
                '买一量';'买一价';'买二量';'买二价';'买三量';'买三价';...
                '买四量';'买四价';'买五量';'买五价'; ...
                '卖一量';'卖一价';'卖二量';'卖二价';'卖三量';'卖三价';...
                '卖四量';'卖四价';'买五量';'卖五价'; ...
                '日期';'时间'};
            
            FutureNameList = { ...
                '名称';'Unknown';'开盘价';'最高价';'最低价';'昨日收盘价 ';...
                '竞买价，即“买一”报价';'竞卖价，即“卖一”报价'; ...
                '最新价，即收盘价';'结算价';...
                '昨结算';'买量';'卖量';'持仓量';'成交量';'商品交易所简称';...
                '品种名简称';'日期';};

            FutureCFFNameList = { ...
                '开盘价';'最高价';'最低价';'昨日收盘价 ';...
                '成交量';'Unknown'; ...
                '持仓量';'最新价';...
                };
            
            
            % % % Code调整
            if ~iscell(obj.Code)
                temp{1,1} = obj.Code;
                obj.Code = temp;
            end
            Len = length(obj.Code);
            DataCell_Output = cell(Len,1);
            MarketType = cell(Len,1);
            URL = ['http://hq.sinajs.cn/list='];
            for i = 1:Len
                tCode = obj.Code{i};
                Ft = tCode(1);
                Ft = str2num(Ft);
                if ~isempty(Ft) && isnumeric(Ft)
                    MarketType{i,1} = 'Stock';
                    ListTemp = {'6','5'};
                    if ismember(tCode(1),ListTemp)
                        
                        tCode = ['sh',tCode];
                    end
                    ListTemp = {'0','3','1'};
                    if ismember(tCode(1),ListTemp)
                        
                        tCode = ['sz',tCode];
                    end
                else
                    ListTemp = {'SH','SZ'};
                    if ismember(lower(tCode(1:2)),lower(ListTemp))
                        
                        MarketType{i,1} = 'Stock';
                        
                    else
                        
                        MarketType{i,1} = 'Futures';
                        ListTemp = {'IF','TF','IC','IH'};
                        if ismember(lower(tCode(1:2)),lower(ListTemp))
                            tCode = ['CFF_RE_',tCode];
                            
                            MarketType{i,1} = 'Futures_CFF';
                        end
                    end
                    
                end
                
                if strcmpi(MarketType{i,1}, 'Stock')
                    tCode = lower(tCode);
                end
                
                if i == 1
                    URL = [URL,tCode];
                else
                    URL = [URL,',',tCode];
                end
                
            end
            
            URLChar = urlread(URL);
            R = textscan(URLChar,'%s','delimiter', ';');
            R = R{1,1};
            for i = 1:Len
                DataCell_Output{i,1} = [];
                
                tR = R{i,1};
                tData = textscan(tR,'%s','delimiter', ',');
                tData = tData{1,1};
                
                if strcmpi(MarketType{i,1}, 'Stock')

                    DataCell = tData;
                    Data = cellfun(@str2double, DataCell(2:30));
                    
                    temp = cell2mat(DataCell(1));
                    ind = find(temp=='"');
                    temp = temp(ind+1:end);
                    DataCell{1,1} = temp;
                    
                    tDate = cell2mat( DataCell(31) );
                    tTime = cell2mat( DataCell(32) );

                    DataCell(2:30) = mat2cell( Data, ones(length(Data), 1) );
                    DataCell{31, 1} = tDate;
                    DataCell{32, 1} = tTime;
                    
                    DataCell(end) = [];
                    
                    DataCell_Output{i,1} = [DataCell,StockNameList];
                end
                
                
                if strcmpi(MarketType{i,1}, 'Futures')
                    
                    DataCell = tData;
                    Data = cellfun(@str2double, DataCell(2:15));
                    
                    temp = cell2mat(DataCell(1));
                    ind = find(temp=='"');
                    temp = temp(ind+1:end);
                    DataCell{1,1} = temp;
                    
                    t1 = cell2mat( DataCell(16) );
                    t2 = cell2mat( DataCell(17) );
                    t3 = cell2mat( DataCell(18) );                    
                    
                    DataCell(2:15) = mat2cell( Data, ones(length(Data), 1) );
                    DataCell{16, 1} = t1;
                    DataCell{17, 1} = t2;
                    DataCell{18, 1} = t3;
                    
                    DataCell(19:end) = [];
                    
                    DataCell_Output{i,1} = [DataCell,FutureNameList];                    
                    
                end
                
                if strcmpi(MarketType{i,1}, 'Futures_CFF')
                    DataCell = tData;
                    
                    temp = cell2mat(DataCell(1));
                    ind = find(temp=='"');
                    temp = temp(ind+1:end);
                    DataCell{1,1} = temp;
                    
%                     Data = cellfun(@str2double, DataCell(2:16));
%                     t1 = cell2mat( DataCell(31) );
%                     t2 = cell2mat( DataCell(32) );
%                     
%                     DataCell(2:16) = mat2cell( Data, ones(length(Data), 1) );
%                     DataCell{17, 1} = t1;
%                     DataCell{18, 1} = t2;
%                     
%                     DataCell(end) = [];

                    tCell = cell(length(DataCell(1:38)),2);
                    tCell(:,1) = DataCell(1:38);
                    tCell(1:length(FutureCFFNameList),2) = FutureCFFNameList;
                    
                    tCell(end-1,2) = {'日期'};
                    tCell(end,2) = {'时间'};                    
                    
                    DataCell_Output{i,1} = tCell;                     
                    

                end                
                
            end
            
            if Len == 1
                
                DataCell_Output = DataCell_Output{1,1};
            end
        end
        
        
        %% 输入参数检查函数
        function Flag = ParaCheck(obj, varargin )
            Flag = 1;
            
            % %===输入参数检查 开始===
            
            %             checkflag = ismember( lower(obj.DownUpSampling),lower(obj.DownUpSampling_ParaList) );
            %             if checkflag ~= 1
            %                 str = ['DownUpSampling参数输入错误请检查！可选的参数列表为（大小写都行）：'];
            %                 disp(str);
            %                 ParaList = obj.DownUpSampling_ParaList
            %                 Flag = 0;
            %                 return;
            %             end
            
            % %===输入参数检查 完毕===
        end
        
        
        
        
        
    end
    
end
