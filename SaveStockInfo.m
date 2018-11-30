function [SaveLog,ProbList,NewList] = SaveStockInfo(StockList)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 1 || isempty(StockList)
    load StockList.mat;
end

SaveLog = [];
ProbList = [];
NewList = [];

Len = size(StockList, 1);
StockCode = StockList(:,2);
StockName = StockList(:,1);

%% 获取数据
FolderStr = ['./DataBase/Stock/StockInfo_mat'];
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
    
    FileString = [FolderStr,'/',StockCode{i},'_StockInfo.mat'];
    FileExist = 0;
    if exist(FileString, 'file') == 2
        FileExist = 1;
    end
    
    % % 本地数据存在，进行尾部更新添加
    if 1 == FileExist
        try
            str = ['load ',FileString];
            eval(str);
            
            if ~isempty(StockInfo)
                
                str = [ StockCode{i},'-',StockName{i}, ' 本地数据已存在' ];
                disp(str);
                
                % % 数据检查
                if isempty( StockInfo.IPOdate )
                    str = [ StockCode{i},'-',StockName{i}, ' 股票上市日期为空，将重新下载数据！' ];
                    disp(str);
                    FileExist = 0;
                end
                
            else % % 本地数据存在，但为空
                LenTemp = size( NewList,1 )+1;
                NewList{LenTemp,1} = Sname;
                NewList{LenTemp,2} = Scode;
                
                StockCodeInput = Scode;
                [StockInfo] = GetStockInfo_Web(StockCodeInput);
                if isempty(StockInfo)
                    str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败，请检查！' ];
                    disp(str);
                    LenTemp = size( ProbList,1 )+1;
                    ProbList{LenTemp,1} = Sname;
                    ProbList{LenTemp,2} = Scode;
                    continue;
                end
                
                save(FileString,'StockInfo', '-v7.3');
                
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
        
        StockCodeInput = Scode;
        [StockInfo] = GetStockInfo_Web(StockCodeInput);
        if isempty(StockInfo)
            str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败，请检查！' ];
            disp(str);
            LenTemp = size( ProbList,1 )+1;
            ProbList{LenTemp,1} = Sname;
            ProbList{LenTemp,2} = Scode;
            continue;
        end
        
        save(FileString,'StockInfo', '-v7.3');
        
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
