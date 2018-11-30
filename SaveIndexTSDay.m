function [SaveLog,ProbList,NewList] = SaveIndexTSDay(IndexList)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/1
%% 输入输出预处理
if nargin < 1 || isempty(IndexList)
    load IndexList.mat;
end

SaveLog = [];
ProbList = [];
NewList = [];

Len = size(IndexList, 1);
StockCode = IndexList(:,2);
StockName = IndexList(:,1);

Date_G = '19900101';
%% Get Data
FolderStr = ['./DataBase/Stock/Index_Day_mat'];
if ~isdir( FolderStr )
    mkdir( FolderStr );
end

ticID = tic;
for i = 1:Len
    disp('======')
    RunIndex = i
    Scode = StockCode{i}
    Sname = StockName{i}
    disp('============')
    
    FileString = [FolderStr,'/',StockCode{i},'_D.mat'];
    FileExist = 0;
    if exist(FileString, 'file') == 2
        FileExist = 1;
    end
    
    % % 本地数据存在，进行尾部更新添加
    if 1 == FileExist
        try
            MatObj = matfile(FileString,'Writable',true);
            [nrows, ncols]=size(MatObj,'IndexData');
            
            OffSet = 4;
            
            if nrows-OffSet>1
                len = nrows;
                Temp = MatObj.IndexData(len-OffSet,1);
                DateTemp = datestr( datenum(num2str(Temp),'yyyymmdd'),'yyyymmdd' );
                
                StockCodeInput = Scode;
                BeginDate = DateTemp;
                EndDate = datestr(today, 'yyyymmdd');
                
                [newIndexData] = GetIndexTSDay_Web(StockCodeInput,BeginDate,EndDate);
                if isempty(newIndexData)
                    str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或无更新数据，请检查！' ];
                    disp(str);
                    LenTemp = size( ProbList,1 )+1;
                    ProbList{LenTemp,1} = Sname;
                    ProbList{LenTemp,2} = Scode;
                    continue;
                end
                
                MatObj.IndexData = ...
                    [MatObj.IndexData(1:nrows-OffSet-1,:);newIndexData];
                
            else % % 本地数据存在，但为空
                % % 获取上市日期
                StockCodeInput = Scode;
                BeginDate = '20140101';
                EndDate = datestr(today, 'yyyymmdd');
                [~,InitialDate] = GetIndexTSDay_Web(StockCodeInput,BeginDate,EndDate,1);
                DateTemp = InitialDate;
                
                LenTemp = size( NewList,1 )+1;
                NewList{LenTemp,1} = Sname;
                NewList{LenTemp,2} = Scode;
                
                StockCodeInput = Scode;
                BeginDate = DateTemp;
                EndDate = datestr(today, 'yyyymmdd');
                
                [newIndexData] = GetIndexTSDay_Web(StockCodeInput,BeginDate,EndDate);
                if isempty(newIndexData)
                    str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或无更新数据，请检查！' ];
                    disp(str);
                    LenTemp = size( ProbList,1 )+1;
                    ProbList{LenTemp,1} = Sname;
                    ProbList{LenTemp,2} = Scode;
                    continue;
                end
                
                MatObj.IndexData = newIndexData;
                
            end
        catch
            str = [ StockCode{i},'-',StockName{i}, ' 数据载入失败或其他原因数据更新失败，将重新下载数据！' ];
            disp(str);
            FileExist = 0;
        end
    end
    
    % % 本地数据不存在
    if 0 == FileExist
        % % 获取上市日期
        StockCodeInput = Scode;
        BeginDate = '20140101';
        EndDate = datestr(today, 'yyyymmdd');
        [~,InitialDate] = GetIndexTSDay_Web(StockCodeInput,BeginDate,EndDate,1);
        DateTemp = InitialDate;
        
        LenTemp = size( NewList,1 )+1;
        NewList{LenTemp,1} = Sname;
        NewList{LenTemp,2} = Scode;
        
        StockCodeInput = Scode;
        BeginDate = DateTemp;
        EndDate = datestr(today, 'yyyymmdd');
        
        [newIndexData] = GetIndexTSDay_Web(StockCodeInput,BeginDate,EndDate);
        if isempty(newIndexData)
            str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或无更新数据，请检查！' ];
            disp(str);
            LenTemp = size( ProbList,1 )+1;
            ProbList{LenTemp,1} = Sname;
            ProbList{LenTemp,2} = Scode;
            continue;
        end
        
        IndexData = newIndexData;
        save(FileString,'IndexData', '-v7.3');
        
    end
    
    NewListLen = size(NewList,1)
    ProbListLen = size(ProbList,1)
    
    elapsedTimeTemp = toc(ticID);
    str = [ '循环已经累计耗时', num2str(elapsedTimeTemp), ' seconds(',num2str(elapsedTimeTemp/60), ' minutes)',...
        '(',num2str(elapsedTimeTemp/60/60), ' hours)',];
    disp(str);
    str = ['Now Time:',datestr(now,'yyyy-mm-dd HH:MM:SS')];
    disp(str);
end
