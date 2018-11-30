classdef fGetUSstock < handle
    %% fGetUSstock
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        Exchange = 'NASDAQ';
        Code = 'AAPL';
        
        StartDate = 'All';
        EndDate = datestr(today,'yyyymmdd');
        
        isSave = 0;
        isPlot = 0;
        isTicToc = 0;
        
        % sina ifeng
        ListSource = 'sina';
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
        %% fGetUSstock()
        function obj = fGetUSstock( varargin )
            
        end
        
        %% GetList()
        function OutputData = GetList(obj)
            OutputData = [];
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            if strcmpi(obj.ListSource, 'sina')
                URL = 'http://vip.stock.finance.sina.com.cn/usstock/ustotal.php';
                URLchar = urlread(URL,'Charset','gb2312');
                
                URLString = java.lang.String(URLchar);
                
                expr = ['<a href="http://stock.finance.sina.com.cn/usstock/quotes/','.*?',...
                    'rel="suggest" title="','.*?>','(.*?)','</a>'];
                
                tData = regexpi(URLchar, expr,'tokens');
                Len = length(tData);
                OutputData = cell(Len,2);
                for i = 1:Len
                    tD = tData{1,i};
                    while iscell(tD)
                        tD = tD{1,1};
                    end
                    
                    ind = find( tD == '(' );
                    tName = tD(1:ind-1);
                    tCode = tD(ind+1:end-1);
                    OutputData(i,:) = [{tCode},{tName}];
                end
                
            end
            
            
            if strcmpi(obj.ListSource, 'ifeng')
                URL_Pattern = 'http://app.finance.ifeng.com/list/usstock.php?first=all&page=%s';
                Page = 1;
                tURL = sprintf(URL_Pattern, num2str(Page));
                
                [TableTotalNum,TableCell] = GetTableFromWeb(tURL, 'utf-8');
                if iscell(TableCell)
                    TableCell = TableCell{1,1};
                end
                Len = size(TableCell,1);
                while Page <= 500
                    
                    if ~isempty(TableCell) && Len>1
                        
                        temp = TableCell(2:end,[2,1]);
                        
                        OutputData = [OutputData;temp];
                        
                    end
                    
                    Page = Page+1;
                    tURL = sprintf(URL_Pattern, num2str(Page));
                    
                    
                    if mod(Page,5) == 0
                        % % 频繁访问的话，会获取数据失败，设置N秒暂停
                        pause(5);
                    end
                    
                    [TableTotalNum,TableCell] = GetTableFromWeb(tURL, 'utf-8');
                    if iscell(TableCell)
                        TableCell = TableCell{1,1};
                    end
                    Len = size(TableCell,1);
                    
                    if isempty(TableCell)
                        Page = Page - 1;
                        pause(30);
                    end
                    
                end
            end
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                tOutputData = OutputData;
                %                 for i = 1:Len
                %
                %                     tCode = OutputData{i,1};
                %                     tCode = ['''',tCode];
                %                     tOutputData{i,1} = tCode;
                %                 end
                
                FolderStr = ['./DataBaseTemp/USstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = ['USstockList_',obj.ListSource];
                FileString = [FolderStr,'/',FileName,'.xlsx'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.xlsx'];
                end
                
                Headers = {'代码','名称'};
                FileName = FileString;
                ColNamesCell = Headers;
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = ['USstockList数据已保存至',FileString];
                disp(str);
            end
            
        end
        
        %% GetHistQuote()
        function [OutputData,Headers] = GetHistQuote(obj)
            % % 新浪的数据有的最低价为0 需要注意！
            OutputData = [];
            Headers = {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'};
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            if obj.isTicToc == 1
                tic;
            end
            
            if strcmpi(obj.StartDate, 'all') 
                
                obj.StartDate = '20000101';
            end
            if strcmpi(obj.EndDate, 'all') 
                
                obj.StartDate = datestr(today,'yyyymmdd');
            end            
            
            tickers = obj.Code;
            dateFormat = 'dd/mm/yyyy';
            startDate = datestr( datenum(obj.StartDate,'yyyymmdd'),dateFormat );
            endDate = datestr( datenum(obj.EndDate,'yyyymmdd'),dateFormat );
            
            YHdata = obj.getYahooDailyData(tickers, startDate, endDate, dateFormat);

            OutputData = table2array(YHdata);
            
            % % %数据处理，将为0的数据替换为NaN
            OutputData(OutputData==0) = NaN;
            
            if obj.isTicToc == 1
                str = ['数据获取完毕！共耗时：'];
                disp(str);
                toc;
            end
            
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                if obj.isTicToc == 1
                    tic;
                end
                
                tOutputData = OutputData;
                
                FolderStr = ['./DataBaseTemp/USstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                if strcmpi(obj.StartDate, 'all') || strcmpi(obj.EndDate, 'all')
                    FileName = [obj.Code,'.US_All'];
                else
                    tdatefrom = obj.StartDate;
                    tdateto = obj.EndDate;
                    FileName = [obj.Code,'.US_',tdatefrom,'-',tdateto];
                end
                FileString = [FolderStr,'/',FileName,'.csv'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.csv'];
                end
                
                FileName = FileString;
                ColNamesCell = Headers;
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.US数据已保存至',FileString];
                disp(str);
                
                if obj.isTicToc == 1
                    str = ['数据保存完毕！共耗时：'];
                    disp(str);
                    toc;
                end
            end
            
            % % % Plot
            if 1 == obj.isPlot && ~isempty(OutputData)
                if obj.isTicToc == 1
                    tic;
                end

                scrsz = get(0,'ScreenSize');
                figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
                
                subplot(3,1,1:2);
                
                FAdjFactor = OutputData(:,5)./OutputData(:,7);
                tOutputData = OutputData;
                for i = 2:5
                    tOutputData(:,i) = tOutputData(:,i)./FAdjFactor;
                end
                
                OHLC = tOutputData(:,2:5);
                KplotNew(OHLC);
                % 横轴时间轴设定
                Dates = OutputData(:,1);
                Style = 0;
                XTRot = [];
                LabelSet(gca, Dates, [], [], Style,XTRot);
                str = [obj.Code,'.US(前复权)  K线图'];
                title(str,'FontWeight','Bold');
                
                subplot(3,1,3);
                Vol = OutputData(:,6);
                bar(Vol);
                str = ['成交量'];
                ylabel(str,'FontWeight','Bold');
                Dates = OutputData(:,1);
                Style = 0;
                XTRot = [];
                LabelSet(gca, Dates, [], [], Style,XTRot);
                xlim([0,1+length(Dates)]);
                
                if obj.isTicToc == 1
                    str = ['数据展示完毕！共耗时：'];
                    disp(str);
                    toc;
                end
            end
            
        end
        
        %% getYahooDailyData()
        function data = getYahooDailyData(obj,tickers, startDate, endDate, dateFormat)
            % GETYAHOODAILYDATA scrapes the Yahoo! Finance website for one or more
            % ticker symbols and returns OHLC, volume, and adjusted close information
            % for the date range specified.
            %
            % Inputs:
            % tickers: Either a character string or cell array of strings listing one
            %   or more (Yahoo!-formatted) ticker symbols
            % startDate, endDate: Either MATLAB datenums or character strings listing
            %   the date range desired (inclusive)
            % dateFormat (optional): If startDate and endDate are strings, then this
            %   indicates their format.  (See the 'formatIn' argument of DAMENUM.)
            %
            % Outputs:
            % data: A structure containing fields for each ticker requested.  The
            %   fields are named by genvarname(ticker).  Each field is an N-by-7 table
            %   listing the dates, open, high, low, close, volume, and adjusted close
            %   for all N of the trading days between startDate and endDate and in
            %   increasing order of date.  NOTE: If the version of MATLAB is less than
            %   8.2 (R2013b), then data returns a structure of dataset arrays
            %   (Statistics Toolbox required).
            %
            % EXAMPLE:
            % data = getYahooDailyData({'MSFT', 'ML.PA'}, ...
            %   '01/01/2010', '01/01/2013', 'dd/mm/yyyy');
            
            %% 1. Input parsing
            % Check to see if a single ticker was provided as a string; if so, make it
            % a cell array to better fit the later logic.
            if ischar(tickers)
                tickers = {tickers};
            end
            
            % If dateFormat is provided, use it.  Otherwise, assume datenums were
            % given.
            if nargin == 5
                startDate = datenum(startDate, dateFormat);
                endDate   = datenum(  endDate, dateFormat);
            end
            
            url1 = 'http://ichart.finance.yahoo.com/table.csv?s=';
            
            [sY, sM, sD] = datevec(startDate);
            [eY, eM, eD] = datevec(endDate);
            
            url2 = ['&a=' num2str(sM-1, '%02u') ...
                '&b=' num2str(sD) ...
                '&c=' num2str(sY) ...
                '&d=' num2str(eM-1, '%02u') ...
                '&e=' num2str(eD) ...
                '&f=' num2str(eY) '&g=d&ignore=.csv'];
            
            % Determine if we're using tables or datasets:
            isBeforeR2013b = verLessThan('matlab', '8.2');
            
            %% 2. Load Data in a loop
            
            for iTicker = 1:length(tickers)
                try
                    str = urlread([url1 tickers{iTicker} url2]);
                catch
                    % Special behaviour if str cannot be found: this means that no
                    % price info was returned.  Error and say which asset is invalid:
                    error('getYahooDailyData:invalidTicker', ...
                        ['No data returned for ticker ''' tickers{iTicker} ...
                        '''. Is this a valid symbol? Do you have an internet connection?'])
                end
                c = textscan(str, '%s%f%f%f%f%f%f', 'HeaderLines', 1, 'Delimiter', ',');
                if isBeforeR2013b
                    ds = dataset(c{1}, c{2}, c{3}, c{4}, c{5}, c{6}, c{7}, 'VarNames', ...
                        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'});
                else
                    ds = table(c{1}, c{2}, c{3}, c{4}, c{5}, c{6}, c{7}, 'VariableNames', ...
                        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'});
                end
                
                % ds.Date = datenum(ds.Date, 'yyyy-mm-dd');
                temp = datenum(ds.Date, 'yyyy-mm-dd');
                temp = str2num(datestr(temp,'yyyymmdd'));
                ds.Date = temp;
                ds = flipud(ds);
                % data.(genvarname(tickers{iTicker})) = ds;
                data = ds;
            end

        end
        
        %% GetProfile()
        function [OutputData] = GetProfile(obj)
            OutputData = [];
            
            
            URL_Pattern = ['http://stock.finance.sina.com.cn/hkstock/info/%s.html'];
            tSymbol = obj.Code;
            tURL = sprintf(URL_Pattern, tSymbol);
            %             Content = urlread(tURL);
            
            [TableTotalNum,TableCell] = GetTableFromWeb(tURL,'gbk');
            
            if TableTotalNum>=1
                OutputData = TableCell{1,1};
            else
                disp('获取数据失败，请检查输入参数！');
                return;
            end
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                tOutputData = OutputData;
                
                FolderStr = ['./DataBaseTemp/HKstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = [obj.Code,'.HK_Profile'];
                
                FileString = [FolderStr,'/',FileName,'.xlsx'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.xlsx'];
                end
                
                FileName = FileString;
                ColNamesCell = [];
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.HK公司资料数据已保存至',FileString];
                disp(str);
            end
            
        end
        
        %% GetDividends()
        function [OutputData,Headers] = GetDividends(obj)
            OutputData = [];
            
            Headers = {'Ex/Eff Date(除息日)','Type(类型)','Cash Amount(现金金额)','Declaration Date(宣布日)','Record Date(登记日)','Payment Date(支付日)'};
            
            URL_Pattern = ['http://www.nasdaq.com/symbol/%s/dividend-history'];
            tSymbol = obj.Code;
            tURL = sprintf(URL_Pattern, tSymbol);
            
            [TableTotalNum,TableCell] = GetTableFromWeb(tURL,'utf-8');
            
            if TableTotalNum>=5 && size(TableCell{5,1},2)>1
                Ind = 5;
                OutputData = TableCell{Ind,1};
            else
                disp('获取数据失败或数据不存在，请检查输入参数！');
                return;
            end
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                tOutputData = OutputData;
                
                FolderStr = ['./DataBaseTemp/USstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = [obj.Code,'.US_Dividends'];
                
                FileString = [FolderStr,'/',FileName,'.csv'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.csv'];
                end
                
                FileName = FileString;
                ColNamesCell = [];
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.US分红派息数据已保存至',FileString];
                disp(str);
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
