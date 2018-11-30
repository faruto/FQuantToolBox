function [SaveLog,ProbList,NewList] = SaveFuturesDay(MarketCode,FutureCode,DateList)
% 获取期货日线数据
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% Head = {'productid','instrumentid','tradingday','openprice','highestprice','lowestprice' ...
%       ,'closeprice','openinterest','settlementprice','presettlementprice','volume','turnover'};
%% 输入输出预处理
if nargin < 3 || isempty(DateList)
    DtempStart = datenum('20100101', 'yyyymmdd');
    if strcmpi(FutureCode,'IF')
        DtempStart = datenum('20100416', 'yyyymmdd');
    end
    if strcmpi(FutureCode,'TF')
        DtempStart = datenum('20130906', 'yyyymmdd');
    end    
    DtempEnd = datenum(datestr(date,'yyyymmdd'),'yyyymmdd');
    Dtemp = (DtempStart:DtempEnd)';
    DateList = str2num( datestr(Dtemp,'yyyymmdd') );
end
if nargin < 2 || isempty(FutureCode)
    FutureCode = 'IF';
end
FutureCode = upper(FutureCode);
if nargin < 1 || isempty(MarketCode)
    MarketCode = 'CFFEX';
end

SaveLog = [];
ProbList = [];
NewList = [];

Fcode = upper(FutureCode);
%% 获取数据
FolderStr = ['./DataBase/Futures/',Fcode,'/Day_mat'];
if ~isdir( FolderStr )
    mkdir( FolderStr );
end

FileString = [FolderStr,'/',Fcode,'_Day.mat'];
FileExist = 0;
if exist(FileString, 'file') == 2
    FileExist = 1;
end

% % 更新模式
if 1 == FileExist
    
    str = ['load ',FileString];
    eval(str);
    
    Data_Old = DataCell;
    tDate = Data_Old{end,3};
    
    DtempEnd = datenum(datestr(date,'yyyymmdd'),'yyyymmdd');
    DtempStart = datenum(tDate, 'yyyymmdd');
    Dtemp = (DtempStart:DtempEnd)';
    DateList = str2num( datestr(Dtemp,'yyyymmdd') );
    
end

ticID = tic;

DLen = size( DateList,1 );
for i = 1:DLen
    if 0 == FileExist
        if exist(FileString, 'file') == 2
            FileExist = 1;
        end
    end
    DateTemp = DateList(i,1);
    
    % % % debug block
    Debug_OnOff = 0;
    if 1 == Debug_OnOff
        if DateTemp<20100416
            continue;
        end
    end
    
    disp('======')
    RunIndex = i
    Scode = Fcode
    str = ['日期：',num2str( DateTemp )];
    disp(str);
    disp('============')
    
    % % 本地数据存在，进行尾部更新添加
    if 1 == FileExist
        try
            str = ['load ',FileString];
            eval(str);
            
            if ~isempty(DataCell)
                str = [ Scode, ...
                    ' 日期：',num2str( DateTemp ),' 本地数据存在进行尾部更新添加' ];
                disp(str);
                
                Data_Old = DataCell;
                tDate = Data_Old{end,3};
                if DateTemp == str2double(tDate)
                    continue;
                end
                DateStr = num2str(DateTemp);
                FuturesCode = Fcode;
                [DataCell_New,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);
                if isempty(DataCell_New)
                    str = [ Scode, ...
                        ' 日期：',num2str( DateTemp ),' 数据获取失败，请检查！' ];
                    disp(str);
                    
                    ProbList = [ProbList;DateTemp];
                    continue;
                end     
                DataCell_New = DataCell_New(2:end,:);
                DataCell = [Data_Old;DataCell_New];
                save(FileString,'DataCell','-v7.3');
                
            else % % 本地数据存在，但为空
                
                NewList = [NewList;DateTemp];
                
                DateStr = num2str(DateTemp);
                FuturesCode = Fcode;
                [DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);
                if isempty(DataCell)
                    str = [ Scode, ...
                        ' 日期：',num2str( DateTemp ),' 数据获取失败，请检查！' ];
                    disp(str);
                    
                    ProbList = [ProbList;DateTemp];
                    continue;
                end

                save(FileString,'DataCell','-v7.3');
            end
        catch
            str = [ Scode, ...
                ' 日期：',num2str( DateTemp ),' 数据载入失败，将重新下载数据！' ];
            disp(str);
            FileExist = 0;
        end
    end
    
    % % 本地数据不存在
    if 0 == FileExist
        NewList = [NewList;DateTemp];
        
        DateStr = num2str(DateTemp);
        FuturesCode = Fcode;
        [DataCell,StatusOut] = GetFutureDay_Web(DateStr, MarketCode,FuturesCode);
        if isempty(DataCell)
            str = [ Scode, ...
                ' 日期：',num2str( DateTemp ),' 数据获取失败，请检查！' ];
            disp(str);
            
            ProbList = [ProbList;DateTemp];
            continue;
        end
        
        save(FileString,'DataCell','-v7.3');
    end
    
    NewListLen = size(NewList)
    ProbListLen = size(ProbList)
    
    elapsedTimeTemp = toc(ticID);
    str = [ '循环已经累计耗时', num2str(elapsedTimeTemp), ' seconds(',num2str(elapsedTimeTemp/60), ' minutes)',...
        '(',num2str(elapsedTimeTemp/60/60), ' hours)',];
    disp(str);
    
end