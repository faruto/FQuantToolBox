function [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% AdjFlag 0:除权时序数据 1:前复权时序数据 2:后复权时序数据
% XRDFlag 0:不获取除权除息信息 1:获取除权除息信息
%% 输入输出预处理
if nargin < 3 || isempty(XRDFlag)
    XRDFlag = 0;
end
if nargin < 2 || isempty(AdjFlag)
    AdjFlag = 0;
end
if nargin < 1 || isempty(StockList)
    load StockList.mat;
end

SaveLog = [];
ProbList = [];
NewList = [];

Len = size(StockList, 1);
StockCode = StockList(:,2);
StockName = StockList(:,1);

if 1 == XRDFlag
    AdjFlag = 888;
end
Date_G = '19900101';
%% 除权时序数据
if 0 == AdjFlag
    FolderStr = ['./DataBase/Stock/Day_ExDividend_mat'];
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
        
        % % DebugMode
        DebugMode_OnOff = 0;
        if 1 == DebugMode_OnOff
            if strcmpi(Scode,'sh603011')~=1
                continue;
            end
            
        end
        
        FileString = [FolderStr,'/',StockCode{i},'_D_ExDiv.mat'];
        FileExist = 0;
        if exist(FileString, 'file') == 2
            FileExist = 1;
        end
        
        % % 本地数据存在，进行尾部更新添加
        if 1 == FileExist
            try
                
                MatObj = matfile(FileString,'Writable',true);
                [nrows, ncols]=size(MatObj,'StockData');
                
                OffSet = 4;
                
                if nrows-OffSet>1
                    
                    len = nrows;
                    Temp = MatObj.StockData(len-OffSet,1);
                    DateTemp = datestr( datenum(num2str(Temp),'yyyymmdd'),'yyyymmdd' );
                    
                    StockCodeInput = Scode;
                    BeginDate = DateTemp;
                    EndDate = datestr(today, 'yyyymmdd');
                    
                    StockDataDouble = GetStockTSDay_Web(StockCodeInput,BeginDate,EndDate);
                    if isempty(StockDataDouble)
                        str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败，请检查！' ];
                        disp(str);
                        LenTemp = size( ProbList,1 )+1;
                        ProbList{LenTemp,1} = Sname;
                        ProbList{LenTemp,2} = Scode;
                        continue;
                    end
                    
                    MatObj.StockData = ...
                        [MatObj.StockData(1:nrows-OffSet-1,:);StockDataDouble];
                    
                else % % 本地数据存在，但为空
                    LenTemp = size( NewList,1 )+1;
                    NewList{LenTemp,1} = Sname;
                    NewList{LenTemp,2} = Scode;
                    
                    % % 获取上市日期
                    StockCodeInput = Scode;
                    IPOdate = GetBasicInfo_Mat(StockCodeInput,[],[],'Stock','IPOdate');
                    if ~isempty(IPOdate)
                        DateTemp = IPOdate;
                    else
                        DateTemp = Date_G;
                    end
                    DateTemp = num2str(DateTemp);
                    
                    StockCodeInput = Scode;
                    BeginDate = DateTemp;
                    EndDate = datestr(today, 'yyyymmdd');
                    
                    StockDataDouble = GetStockTSDay_Web(StockCodeInput,BeginDate,EndDate);
                    if isempty(StockDataDouble)
                        str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败，请检查！' ];
                        disp(str);
                        LenTemp = size( ProbList,1 )+1;
                        ProbList{LenTemp,1} = Sname;
                        ProbList{LenTemp,2} = Scode;
                        continue;
                    end
                    
                    %                     StockData = StockDataDouble;
                    %
                    %                     save(FileString,'StockData', '-v7.3');
                    MatObj.StockData = StockDataDouble;
                    
                end
            catch
                str = [ StockCode{i},'-',StockName{i}, ' 数据载入失败或其他原因数据更新失败，将重新下载数据！' ];
                disp(str);
                FileExist = 0;
            end
        end
        
        % % 本地数据不存在
        if 0 == FileExist
            LenTemp = size( NewList,1 )+1;
            NewList{LenTemp,1} = Sname;
            NewList{LenTemp,2} = Scode;
            
            % % 获取上市日期
            StockCodeInput = Scode;
            IPOdate = GetBasicInfo_Mat(StockCodeInput,[],[],'Stock','IPOdate');
            if ~isempty(IPOdate)
                DateTemp = IPOdate;
            else
                DateTemp = Date_G;
            end
            DateTemp = num2str(DateTemp);
            
            StockCodeInput = Scode;
            BeginDate = DateTemp;
            EndDate = datestr(today, 'yyyymmdd');
            
            StockDataDouble = GetStockTSDay_Web(StockCodeInput,BeginDate,EndDate);
            if isempty(StockDataDouble)
                str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败，请检查！' ];
                disp(str);
                LenTemp = size( ProbList,1 )+1;
                ProbList{LenTemp,1} = Sname;
                ProbList{LenTemp,2} = Scode;
                continue;
            end
            
            StockData = StockDataDouble;
            
            save(FileString,'StockData', '-v7.3');
            
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
    
end
%% 前复权时序数据
if 1 == AdjFlag
    FolderStrD_Ex = ['./DataBase/Stock/Day_ExDividend_mat'];
    FolderStr = ['./DataBase/Stock/Day_ForwardAdj_mat'];
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
        
        FileStringD_Ex = [FolderStrD_Ex,'/',StockCode{i},'_D_ExDiv.mat'];
        FileString = [FolderStr,'/',StockCode{i},'_D_ForwardAdj.mat'];
        
        FileExist = 0;
        if exist(FileStringD_Ex, 'file') == 2
            FileExist = 1;
        end
        
        % % 本地数据存在，进行尾部更新添加
        if 1 == FileExist
            try
                str = ['load ',FileStringD_Ex];
                eval(str);
                
                if ~isempty(StockData)
                    
                    XRD_Data = [];
                    
                    [StockDataXRD, factor] = CalculateStockXRD(StockData, XRD_Data, AdjFlag);
                    StockData = StockDataXRD;
                    save(FileString,'StockData', '-v7.3');
                end
            catch
                str = [ StockCode{i},'-',StockName{i}, ' 数据载入失败或其他原因数据更新失败' ];
                disp(str);
                FileExist = 0;
            end
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
end
%% 后复权时序数据
if 2 == AdjFlag
    FolderStrD_Ex = ['./DataBase/Stock/Day_ExDividend_mat'];
    FolderStr = ['./DataBase/Stock/Day_BackwardAdj_mat'];
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
        
        FileStringD_Ex = [FolderStrD_Ex,'/',StockCode{i},'_D_ExDiv.mat'];
        FileString = [FolderStr,'/',StockCode{i},'_D_BackwardAdj.mat'];
        
        FileExist = 0;
        if exist(FileStringD_Ex, 'file') == 2
            FileExist = 1;
        end
        
        % % 本地数据存在，进行尾部更新添加
        if 1 == FileExist
            try
                str = ['load ',FileStringD_Ex];
                eval(str);
                
                if ~isempty(StockData)
                    
                    XRD_Data = [];
                    
                    [StockDataXRD, factor] = CalculateStockXRD(StockData, XRD_Data, AdjFlag);
                    StockData = StockDataXRD;
                    save(FileString,'StockData', '-v7.3');
                end
            catch
                str = [ StockCode{i},'-',StockName{i}, ' 数据载入失败或其他原因数据更新失败' ];
                disp(str);
                FileExist = 0;
            end
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
end
%% 获取除权除息信息
if 1 == XRDFlag
    FolderStr = ['./DataBase/Stock/XRDdata_mat'];
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
        
        FileString = [FolderStr,'/',StockCode{i},'_XRD.mat'];
        
        StockCodeInput = Scode;
        [ Web_XRD_Data , Web_XRD_Cell_1 , Web_XRD_Cell_2 ] = GetStockXRD_Web(StockCodeInput);
        
        if isempty(Web_XRD_Data)
            str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或该股票无除权除息信息，请检查！' ];
            disp(str);
            LenTemp = size( ProbList,1 )+1;
            ProbList{LenTemp,1} = Sname;
            ProbList{LenTemp,2} = Scode;
        else
            save(FileString,'Web_XRD_Data','Web_XRD_Cell_1','Web_XRD_Cell_2', '-v7.3');
        end
        
        NewListLen = size(NewList,1)
        ProbListLen = size(ProbList,1)
        
        elapsedTimeTemp = toc(ticID);
        str = [ '循环已经累计耗时', num2str(elapsedTimeTemp), ' seconds(',num2str(elapsedTimeTemp/60), ' minutes)',...
            '(',num2str(elapsedTimeTemp/60/60), ' hours)',];
        disp(str);
    end
end
%% 发送邮件通知

% str = datestr(now,'yyyy-mm-dd HH:MM:SS');
% if AdjFlag == 1
%     subject = [str,' 股票日线数据（前复权）更新完毕'];
% else
%     subject = [str,' 股票日线数据（不复权）更新完毕'];
% end
%
% content = [];
% content{1,1} = [str,' 股票日线数据更新完毕'];
%
% Temp = StockD.DataCell;
% Temp = Temp(end,1);
% if iscell(Temp)
%     Temp = Temp{1};
% end
% str = [ '股票日线数据已更新至', num2str(Temp) ];
% content{length(content)+1,1} = str;
% if ~isempty(IndNew)
%     content{length(content)+1,1} = '新增加个股：';
%     for i = 1: length(IndNew);
%         content{length(content)+1,1} = cell2mat( StockList(IndNew(i),:) );
%     end
% end
% str = [ '共耗时', num2str(elapsedTime), ' seconds(',num2str(elapsedTime/60), ' minutes)', ...
%        '(',num2str(elapsedTime/60/60), ' hours)'];
% content{length(content)+1,1} = str;
% str = [ '个股数量为', num2str(length(StockList)) ];
% content{length(content)+1,1} = str;
%
% TargetAddress = 'faruto@foxmail.com'; %目标邮箱地址
% MatlabSentMail(subject, content, TargetAddress);
