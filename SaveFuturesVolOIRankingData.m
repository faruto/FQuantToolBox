function [SaveLog,DateListOut,ProbList,NewList] = SaveFuturesVolOIRankingData(FutureCode,DateList,UpdateFlag)
% 获取期货品种成交量持仓量排名数据
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 3 || isempty(UpdateFlag)
    UpdateFlag = 0;
end
if nargin < 2 || isempty(DateList)
    DtempEnd = datenum(datestr(date,'yyyymmdd'),'yyyymmdd');
    DtempStart = datenum('20100101', 'yyyymmdd');
    Dtemp = (DtempStart:DtempEnd)';
    DateList = str2num( datestr(Dtemp,'yyyymmdd') );
end
if nargin < 1 || isempty(FutureCode)
    FutureCode = 'IF';
end

DateListOut = [];

SaveLog = [];
ProbList = [];
NewList = [];

Fcode = upper(FutureCode);
%% 获取数据
FolderStr = ['./DataBase/Futures/',Fcode,'/VolOIRanking'];

% % UpdateFlag = 1 更新模式
if 1 == UpdateFlag
    
    listing = dir(FolderStr);
    temp = struct2cell(listing);
    temp = temp';
    if length(temp)>3
        temp = temp(3:end,1);
        for i = 1:length(temp)
            Td = temp{i};
            ind = find(Td == '_');
            Sind = ind(end)+1;
            ind = find( Td =='.' );
            Eind = ind(1)-1;
            temp{i} = str2num(Td(Sind:Eind));
        end
        Dtemp = cell2mat(temp);
        Dm = max(Dtemp);
        
        DtempEnd = datenum(datestr(date,'yyyymmdd'),'yyyymmdd');
        DtempStart = datenum(num2str(Dm), 'yyyymmdd');
        Dtemp = (DtempStart:DtempEnd)';
        DateList = str2num( datestr(Dtemp,'yyyymmdd') );
    end
    
end

ticID = tic;

DLen = size( DateList,1 );
for i = 1:DLen
    DateTemp = DateList(i,1);
    
    % % % debug block
    Debug_OnOff = 0;
    if 1 == Debug_OnOff
        if DateTemp<20140909
            continue;
        end
    end
    
    disp('======')
    RunIndex = i
    Scode = Fcode
    str = ['日期：',num2str( DateTemp )];
    disp(str);
    disp('============')

    if ~isdir( FolderStr )
        mkdir( FolderStr );
    end
    BeginDate = num2str( DateTemp );
    FileString = [FolderStr,'/',Fcode,'_VolOIRanking_',BeginDate,'.mat'];
    FileExist = 0;
    if exist(FileString, 'file') == 2
        FileExist = 1;
    end
    
    % % 本地数据存在，进行尾部更新添加
    if 1 == FileExist
        try
            str = ['load ',FileString];
            eval(str);
            
            if ~isempty(DataCell)
                str = [ Scode, ...
                    ' 日期：',num2str( DateTemp ),' 本地数据已存在' ];
                disp(str);
                
                % % % 数据异常监测Block
                

                
            else % % 本地数据存在，但为空
                
                NewList = [NewList;DateTemp];
                
                DateStr = num2str(DateTemp);
                FutureCode = Fcode;
                [DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, FutureCode);
                if isempty(DataCell)
                    str = [ Scode, ...
                        ' 日期：',num2str( DateTemp ),' 数据获取失败，请检查！' ];
                    disp(str);

                    ProbList = [ProbList;DateTemp];
                    continue;
                end
                DateListOut = [DateListOut;DateTemp];
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
        FutureCode = Fcode;
        [DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, FutureCode);
        if isempty(DataCell)
            str = [ Scode, ...
                ' 日期：',num2str( DateTemp ),' 数据获取失败，请检查！' ];
            disp(str);

            ProbList = [ProbList;DateTemp];
            continue;
        end
        
        DateListOut = [DateListOut;DateTemp];
        save(FileString,'DataCell','-v7.3');
    end
    
    NewListLen = size(NewList)
    ProbListLen = size(ProbList)
    
    elapsedTimeTemp = toc(ticID);
    str = [ '循环已经累计耗时', num2str(elapsedTimeTemp), ' seconds(',num2str(elapsedTimeTemp/60), ' minutes)',...
        '(',num2str(elapsedTimeTemp/60/60), ' hours)',];
    disp(str);
    
end