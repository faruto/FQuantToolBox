classdef fGetFund < handle
    %% fGetFund
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        Code = '510050';
        
        StartDate = 'All';
        EndDate = datestr(today,'yyyymmdd');
        
        isSave = 1;
        
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
        %% fGetFund()
        function obj = fGetFund( varargin )
            
            
        end
        
        %% GetNetValue()
        function [OutputData,Headers] = GetNetValue(obj)
            OutputData = [];
            Headers = [];
            Headers = {'日期','单位净值(元)','累计净值(元)'};
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            
            URL_Pattern = ['http://stock.finance.sina.com.cn/fundInfo/api/openapi.php/CaihuiFundInfoService.getNav?', ...
                'symbol=%s&datefrom=%s&dateto=%s&page=%s'];
            
            
            tSymbol = obj.Code;
            tpage = [];
            if strcmpi(obj.StartDate, 'all') || strcmpi(obj.EndDate, 'all')
                
                tdatefrom = [];
                tdateto = [];
                
            else
                tdatefrom = obj.StartDate;
                tdateto = obj.EndDate;              
            end
            
            tURL = sprintf(URL_Pattern, tSymbol,tdatefrom,tdateto,tpage);
            Content = urlread(tURL);
            
            dataInfo = JSON.parse( Content );
            tData = dataInfo.result.data.data;
            
            total_num = dataInfo.result.data.total_num;
            total_num = str2num(total_num);
            if isempty(total_num)
                disp('获取数据失败，请检查输入参数！');
                return;
            end
            
            OutputData = zeros(total_num, 3);
            IndRun = 1;
            PageRun = 2;
            
            while ~isempty( tData )
                
                tLen = length(tData);
                for i = 1:tLen
                    DataTemp = tData{1,i};
                    FBRQ = DataTemp.fbrq;
                    FBRQ = str2num( datestr( datenum(FBRQ,'yyyy-mm-dd'),'yyyymmdd' ) );
                    JJJZ = str2num(DataTemp.jjjz);
                    LJJZ = str2num(DataTemp.ljjz);
                    
                    if isempty( find(OutputData(:,1)==FBRQ,1) )
                        
                        OutputData(IndRun,:) = [FBRQ,JJJZ,LJJZ];
                        IndRun = IndRun + 1;
                    end
                end
                
                tpage = num2str(PageRun);
                
                tURL = sprintf(URL_Pattern, tSymbol,tdatefrom,tdateto,tpage);
                Content = urlread(tURL);
                
                dataInfo = JSON.parse( Content );
                tData = dataInfo.result.data.data;
                
                
                PageRun = PageRun + 1;
            end
            
            if ~isempty(OutputData)
                
                OutputData = OutputData(end:-1:1,:);
                
            end
            
            if 1 == obj.isSave && ~isempty(OutputData)
                
                FolderStr = ['./DataBaseTemp/Fund'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = [obj.Code,'.OF','_',tdatefrom,'-',tdateto];
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
                Data = OutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.OF数据已保存至',FileString];
                disp(str);
            end
            
        end
        
        %% GetFundShareChg()
        function [OutputData,Headers] = GetFundShareChg(obj)
            OutputData = [];
            Headers = [];
            Headers = {'报告期','期初总份额(份)','期末总份额(份)', ...
                       '期间总申购份额(份)','期间总赎回份额(份)'};
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            
            URL_Pattern = ['http://stock.finance.sina.com.cn/fundInfo/api/openapi.php/CaihuiFundInfoService.getFundshareChg?', ...
                'symbol=%s&datefrom=%s&dateto=%s'];
            
            
            tSymbol = obj.Code;
            if strcmpi(obj.StartDate, 'all') || strcmpi(obj.EndDate, 'all')
                
                tdatefrom = [];
                tdateto = [];
                
            else
                tdatefrom = obj.StartDate;
                tdateto = obj.EndDate;              
            end
            
            tURL = sprintf(URL_Pattern, tSymbol,tdatefrom,tdateto);
            Content = urlread(tURL);
            
            dataInfo = JSON.parse( Content );
            tData = dataInfo.result.data;
            
            if isempty(tData)
                disp('获取数据失败，请检查输入参数！');
                return;
            end
            
            Len = length(tData);
            OutputData = zeros(Len, length(Headers));
            
            tLen = length(tData);
            for i = 1:tLen
                DataTemp = tData{1,i};
                bgq = DataTemp.bgq;
                bgq = str2num( datestr( datenum(bgq,'yyyy-mm-dd'),'yyyymmdd' ) );
                qcfe = str2num(DataTemp.qcfe);
                qmfe = str2num(DataTemp.qmfe);
                sgfe = str2num(DataTemp.sgfe);
                shfe = str2num(DataTemp.shfe);
                
                
                OutputData(i,:) = [bgq,qcfe,qmfe,sgfe,shfe];
                
            end
            
            
            if ~isempty(OutputData)
                
                OutputData = OutputData(end:-1:1,:);
                
            end
            
            if 1 == obj.isSave && ~isempty(OutputData)
                
                FolderStr = ['./DataBaseTemp/Fund'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                
                FileName = [obj.Code,'.OF_','FundshareChg_',tdatefrom,'-',tdateto];
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
                Data = OutputData;
                [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                
                str = [obj.Code,'.OF_FundshareChg数据已保存至',FileString];
                disp(str);
            end
            
        end        
        
        %% GetFundProfile()
        function [OutputData] = GetFundProfile(obj)
            OutputData = [];
            
                        
            URL_Pattern = ['http://stock.finance.sina.com.cn/fundInfo/view/FundInfo_JJGK.php?symbol=%s'];
            tSymbol = obj.Code;
            tURL = sprintf(URL_Pattern, tSymbol);
%             Content = urlread(tURL);     
            
            [TableTotalNum,TableCell] = GetTableFromWeb(tURL);
            
            if TableTotalNum>9
                OutputData = TableCell{9,1};
            else
                disp('获取数据失败，请检查输入参数！');
                return;
            end
            
        end 
        
        %% GetFundHolder()
        function [OutputData,Headers] = GetFundHolder(obj)
            OutputData = [];
            Headers = [];
            Headers = {'持有人名称','持有份额(份)','占总份额比(%)'};
            
            H = {'报告期', '十大持有人'};
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            URL = ['http://stock.finance.sina.com.cn/fundInfo/view/FundInfo_JJCYR.php?symbol=%s'];
            URL_Pattern = ['http://stock.finance.sina.com.cn/fundInfo/api/openapi.php/CaihuiFundInfoService.getFundHolder?' ...
                'symbol=%s&date=%s'];
            tSymbol = obj.Code;
            tURL = sprintf(URL, tSymbol);
            % % Get Date
            Content = urlread(tURL);
            expr = ['<option value=.*?>(.*?)</option>'];
            tStr = regexpi(Content, expr,'tokens');
            if isempty(tStr)
                disp('获取数据失败，请检查输入参数！');
                return;
            end
            Len = length(tStr);
            OutputData = cell(Len,2);
            tStr = tStr(end:-1:1);
            
            % % 下面的Unicode转换需要JDK native2ascii.exe
            % % 需要实现安装JDK C:\Program Files\Java\jdk1.8.0_45\bin
            
            % % 目录调整
            currentFolder = pwd;
            JDKfolder = ['C:\Program Files\Java\jdk1.8.0_45\bin'];
            cd(JDKfolder);
            for i = 1:Len
                tD = tStr{1,i};
                while iscell(tD)
                    tD = tD{1,1};
                end
                
                OutputData{i,1} = tD;
                
                tURL = sprintf(URL_Pattern, tSymbol,tD);
                Content = urlread(tURL);
                dataInfo = JSON.parse( Content );
                tData = dataInfo.result.data;
                
                if isempty(tData)
                    continue;
                    OutputData{i,2} = [];
                end
                
                tL = length(tData);
                tCell = cell(tL,3);
                
                
                for j = 1:tL
                    DataTemp = tData{1,j};
                    cyrmc = DataTemp.cyrmc;
                    cyfe = str2num(DataTemp.cyfe);
                    zfeb = str2num(DataTemp.zfeb);

                    ColNamesCell = [];
                    Data = {cyrmc};
                    FileName = 'test.txt';
                    [Status, Message] = SaveData2File(Data, FileName, ColNamesCell);
                    
                    command = ['native2ascii -reverse test.txt'];
                    [status,cmdout] = dos(command);
                    tName = cmdout;
                    
                    tCell(j,:) = [{tName}, cyfe, zfeb];
                end

                tCell = [Headers;tCell];
                OutputData{i,2} = tCell;
            end
            
            % % 目录调整回去
            cd(currentFolder);
            
            OutputData = [H;OutputData];
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
