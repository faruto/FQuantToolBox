classdef fGetHKstock < handle
    %% fGetHKstock
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        Code = '00700';
        
        StartDate = 'All';
        EndDate = datestr(today,'yyyymmdd');
        
        isSave = 0;
        isPlot = 0;
        
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
        %% fGetHKstock()
        function obj = fGetHKstock( varargin )
            
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
            
            URL = 'http://quote.eastmoney.com/hk/HStock_list.html';
            URLchar = urlread(URL,'Charset','gb2312');
            
            URLString = java.lang.String(URLchar);
            
            expr = ['<li><a href="http://quote.eastmoney.com/hk/','.*?',...
                'target="_blank">(','(.*?)','</a></li>'];
            
            tData = regexpi(URLchar, expr,'tokens');
            Len = length(tData);
            OutputData = cell(Len,2);
            for i = 1:Len
                tD = tData{1,i};
                while iscell(tD)
                    tD = tD{1,1};
                end
                
                ind = find( tD == ')' );
                tCode = tD(1:ind-1);
                tName = tD(ind+1:end);
                OutputData(i,:) = [{tCode},{tName}];
            end
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                tOutputData = OutputData;
                for i = 1:Len
                    
                    tCode = OutputData{i,1};
                    tCode = ['''',tCode];
                    tOutputData{i,1} = tCode;
                end
                
                FolderStr = ['./DataBaseTemp/HKstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = ['HKstockList',];
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
                
                str = ['HKstockList数据已保存至',FileString];
                disp(str);
            end
            
        end
        
        %% GetPrice()
        function [OutputData,Headers] = GetPrice(obj)
            % % 新浪的数据有的最低价为0 需要注意！
            OutputData = [];
            Headers = {'日期','开','高','低','收','量','额','涨跌额','涨跌幅','振幅'};
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            tSymbol = obj.Code;
            
            URL_Pattern = ['http://stock.finance.sina.com.cn/hkstock/api/jsonp.php/' ...
                'Var=/HistoryTradeService.getHistoryRange?symbol=%s'];
            
            tURL = sprintf(URL_Pattern, tSymbol);
            Content = urlread(tURL);
            
            ind = find(Content == '"');
            Temp = Content(ind(1)+1:ind(2)-1);
            YearMax = str2double(Temp(1:4));
            SeasonMax = str2double(Temp(6:end));
            Temp = Content(ind(3)+1:ind(4)-1);
            YearMin = str2double(Temp(1:4));
            SeasonMin = str2double(Temp(6:end));            
            
            if strcmpi(obj.StartDate, 'all') || strcmpi(obj.EndDate, 'all')
                
                sYear = YearMin;
                eYear = YearMax;
                
                sJiDu = SeasonMin;
                eJiDu = SeasonMax;
            else
                sYear = str2double(obj.StartDate(1:4));
                eYear = str2double(obj.EndDate(1:4));
                sM = str2double(obj.StartDate(5:6));
                eM = str2double(obj.EndDate(5:6));
                
                for i = 1:4
                    if sM>=3*i-2 && sM<=3*i
                        sJiDu = i;
                    end
                    if eM>=3*i-2 && eM<=3*i
                        eJiDu = i;
                    end
                end
                
            end
            
            Len = (eYear-sYear)*240+250;
            DTemp = cell(Len,10);
            rLen = 1;
            for i = sYear:eYear
                for j = 1:4
                    if i == sYear && j < sJiDu
                        continue;
                    end
                    if i == eYear && j > eJiDu
                        continue;
                    end
                    
                    URL = 'http://stock.finance.sina.com.cn/hkstock/history/00700.html';
                    tPost = {'year',num2str(i),'season',num2str(j)};

                    [~,TableCell] = GetTableFromWeb(URL,'gb2312','Post',tPost);
                    
                    if iscell( TableCell ) && ~isempty(TableCell)
                        TableInd = 1;
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
            
            % {'日期','收盘价','涨跌额','涨跌幅','成交量','成交额','开盘价','最高价','最低价','振幅'}
            % 调整成
            % {'日期','开','高','低','收','量','额','涨跌额','涨跌幅','振幅'};
            Dates = DTemp(:,1);
            Close = DTemp(:,2);
            ChgA = DTemp(:,3);
            ChgP = DTemp(:,4);
            Vol = DTemp(:,5);
            Amt = DTemp(:,6);
            Open = DTemp(:,7);
            High = DTemp(:,8);
            Low = DTemp(:,9);
            Swing = DTemp(:,10);
            
            DTemp = [ Dates,Open,High,Low,Close,Vol,Amt,ChgA,ChgP,Swing ];
            DTemp = cellfun(@str2double,DTemp);   
            
            % BeginDate,EndDate
            sDate = str2double(obj.StartDate);
            eDate = str2double(obj.EndDate);
            
%             [~,sInd] = min( abs(DTemp(:,1)-sDate) );
%             [~,eInd] = min( abs(DTemp(:,1)-eDate) );
            sInd = find(DTemp(:,1)>=sDate,1,'first');
            eInd = find(DTemp(:,1)<=eDate,1,'last');
            
            OutputData = DTemp(sInd:eInd,:);
            
            % % %数据处理，将为0的数据替换为NaN
            OutputData(OutputData==0) = NaN;
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                tOutputData = OutputData;
                
                FolderStr = ['./DataBaseTemp/HKstock'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                if strcmpi(obj.StartDate, 'all') || strcmpi(obj.EndDate, 'all')
                    FileName = [obj.Code,'.HK_All'];
                else
                    tdatefrom = obj.StartDate;
                    tdateto = obj.EndDate;
                    FileName = [obj.Code,'.HK_',tdatefrom,'-',tdateto];
                end
                FileString = [FolderStr,'/',FileName,'.xlsx'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.xlsx'];
                end

                FileName = FileString;
                ColNamesCell = Headers;
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.HK数据已保存至',FileString];
                disp(str);
            end
            
            % % % Plot
            if 1 == obj.isPlot && ~isempty(OutputData)
                % % 新浪的数据有的最低价为0 需要注意！
                % % 进行数据检查，为0的数据做些处理
                
                
                scrsz = get(0,'ScreenSize');
                figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
                
                subplot(3,1,1:2);
                
                OHLC = OutputData(:,2:5);
                KplotNew(OHLC);
                % 横轴时间轴设定
                Dates = OutputData(:,1);
                Style = 0;
                XTRot = [];
                LabelSet(gca, Dates, [], [], Style,XTRot);
                str = [obj.Code,'.HK  K线图'];
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
        function [OutputData] = GetDividends(obj)
            OutputData = [];
            
                        
            URL_Pattern = ['http://stock.finance.sina.com.cn/hkstock/dividends/%s.html'];
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
                
                FileName = [obj.Code,'.HK_Dividends'];

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
                
                str = [obj.Code,'.HK分红派息数据已保存至',FileString];
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
