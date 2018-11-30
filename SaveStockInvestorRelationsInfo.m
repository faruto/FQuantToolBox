function [IRInfoFileListCell,SaveLog,ProbList,NewList] = SaveStockInvestorRelationsInfo(StockList)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% 输入输出预处理
if nargin < 1 || isempty(StockList)
    load StockList.mat;
end

IRInfoFileListCell = [];
SaveLog = [];
ProbList = [];
NewList = [];

Len = size(StockList, 1);
StockCode = StockList(:,2);
StockName = StockList(:,1);

Date_G = '20050101';
%% 除权时序数据

ticID = tic;
% 1:Len
% 1:1041
% 1042:2286
% 2287:Len
for i = 1:Len
    disp('======')
    RunIndex = i
    Scode = StockCode{i}
    Sname = StockName{i}
    disp('============')
    
    % % 中小板、创业板
    if strcmpi( Scode(1:2),'sh')
        continue;
    end
    
    % % DebugMode
    DebugMode_OnOff = 0;
    if 1 == DebugMode_OnOff
       if strcmpi(Scode,'sz000617')~=1
           continue;
       end
    end
    
    FolderStr = ['./DataBase/Stock/StockInvestorRelationsInfo_file/',StockCode{i},'_IRInfoFile'];
    if ~isdir( FolderStr )
        mkdir( FolderStr );
    end
    
    FileString = [FolderStr,'/',StockCode{i},'_IRInfoFile.mat'];
    FileExist = 0;
    if exist(FileString, 'file') == 2
        FileExist = 1;
    end
    
    % % 本地数据存在，进行尾部更新添加
    if 1 == FileExist
        try

            MatObj = matfile(FileString,'Writable',true);
            [nrows, ncols]=size(MatObj,'IRInfoFileListCell');
            
            if nrows>1
                len = nrows;
                Temp = MatObj.IRInfoFileListCell(len,2);
                Temp = Temp{1};
                DateTemp = datestr( datenum(num2str(Temp),'yyyymmddHHMM')+1,'yyyy-mm-dd' );
                
                StockCodeInput = Scode;
                BeginDate = DateTemp;
                EndDate = datestr(today, 'yyyymmdd');
                
                [IRDataCell] = GetStockInvestRInfo_Web(StockCodeInput,BeginDate,EndDate);
                if isempty(IRDataCell)
                    str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或没有最新文件，请检查！' ];
                    disp(str);
                    LenTemp = size( ProbList,1 )+1;
                    ProbList{LenTemp,1} = Sname;
                    ProbList{LenTemp,2} = Scode;
%                     continue;
                end
                
                newFileListCell = NoticeDataCell2FileListCell(IRDataCell);
                
                MatObj.IRInfoFileListCell = [MatObj.IRInfoFileListCell;newFileListCell(2:end,:)];
                
                
            else % % 本地数据存在，但为空
                % % 获取上市日期
                FolderStr_StockInfo = ['./DataBase/Stock/StockInfo_mat'];
                FileString_StockInfo = [FolderStr_StockInfo,'/',StockCode{i},'_StockInfo.mat'];
                if exist(FileString_StockInfo, 'file') == 2
                    str = ['load ',FileString_StockInfo];
                    eval(str);
                    if ~isempty( StockInfo.IPOdate )
                        IPOdate = StockInfo.IPOdate;
                    else
                        IPOdate = Date_G;
                    end
				else
					IPOdate = Date_G;                    
                end
                DateTemp = datestr( datenum(num2str(IPOdate),'yyyymmdd'),'yyyy-mm-dd' );
                
                LenTemp = size( NewList,1 )+1;
                NewList{LenTemp,1} = Sname;
                NewList{LenTemp,2} = Scode;
                
                StockCodeInput = Scode;
                BeginDate = DateTemp;
                EndDate = datestr(today, 'yyyymmdd');
                
                [IRDataCell] = GetStockInvestRInfo_Web(StockCodeInput,BeginDate,EndDate);
                if isempty(IRDataCell)
                    str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或没有最新文件，请检查！' ];
                    disp(str);
                    LenTemp = size( ProbList,1 )+1;
                    ProbList{LenTemp,1} = Sname;
                    ProbList{LenTemp,2} = Scode;
%                     continue;
                end
                
                newFileListCell = NoticeDataCell2FileListCell(IRDataCell);
                
                MatObj.IRInfoFileListCell = newFileListCell;
                
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
        FolderStr_StockInfo = ['./DataBase/Stock/StockInfo_mat'];
        FileString_StockInfo = [FolderStr_StockInfo,'/',StockCode{i},'_StockInfo.mat'];
        if exist(FileString_StockInfo, 'file') == 2
            str = ['load ',FileString_StockInfo];
            eval(str);
            if ~isempty( StockInfo.IPOdate )
                IPOdate = StockInfo.IPOdate;
            else
                IPOdate = Date_G;
            end
        else
            IPOdate = Date_G;            
        end
        DateTemp = datestr( datenum(num2str(IPOdate),'yyyymmdd'),'yyyy-mm-dd' );
        
        LenTemp = size( NewList,1 )+1;
        NewList{LenTemp,1} = Sname;
        NewList{LenTemp,2} = Scode;
        
        StockCodeInput = Scode;
        BeginDate = DateTemp;
        EndDate = datestr(today, 'yyyymmdd');
        
        [IRDataCell] = GetStockInvestRInfo_Web(StockCodeInput,BeginDate,EndDate);
        if isempty(IRDataCell)
            str = [ StockCode{i},'-',StockName{i}, ' 数据获取失败或没有最新文件，请检查！' ];
            disp(str);
            LenTemp = size( ProbList,1 )+1;
            ProbList{LenTemp,1} = Sname;
            ProbList{LenTemp,2} = Scode;
            continue;
        end
        
        newFileListCell = NoticeDataCell2FileListCell(IRDataCell);
        
        IRInfoFileListCell = newFileListCell;
        save(FileString, 'IRInfoFileListCell','-v7.3');
    end
    
    % % 保存文件至本地数据库
%     if ~isempty(newFileListCell)
%         str = ['===FileSave2LocalDB Begin==='];
%         disp(str);
%         str = ['保存文件至本地'];
%         disp(str);      
%         
%         tLen = size(newFileListCell,1);
%         for tR = 2:tLen
%             temp = newFileListCell{tR,7};
%             
%             tFileString = [FolderStr,'/',temp]
%             
%             tURL = newFileListCell{tR,5}
%             
%             try
%                 outfilename = websave(tFileString,tURL);
%             catch err
%                 str = ['日期时间：',datestr(now),' 保存文件失败：',err.message];
%                 fprintf('%s\n',str);
%                 for i = 1:size(err.stack,1)
%                     str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
%                     fprintf('%s\n',str);
%                 end
%             end
%         end
%         str = ['===FileSave2LocalDB End==='];
%         disp(str);         
%     end

    % % 保存文件至本地数据库-全文件列表检查
    if 1 == FileExist
        FileListCellFull = MatObj.IRInfoFileListCell;
    else
        FileListCellFull = newFileListCell;
    end
    if ~isempty(FileListCellFull)
        str = ['===FileSave2LocalDB_Full Begin==='];
        disp(str);
        str = ['保存文件至本地'];
        disp(str);      
        
        tLen = size(FileListCellFull,1);
        for tR = 2:tLen
            temp = FileListCellFull{tR,7};
            
            % 文件名检查，文件名不能包含 / \ : * ？ " < > |
            CheckChar = {'\';'/';':';'*';'?';'"';'<';'>';'|';char(26)};
            CFlag = 0;
            for Ti = 1:length(CheckChar)
                if sum( temp==CheckChar{Ti} ) ~= 0
                    temp( temp==CheckChar{Ti} ) = '_';
                    CFlag = 1;
                end
            end
            if 1 == FileExist && 1 == CFlag
                tCell = {temp};
                MatObj.IRInfoFileListCell(tR,7) = tCell;
            end
            
            tFileString = [FolderStr,'/',temp];
            if exist(tFileString, 'file') ~= 2
                FileSave = tFileString
                tURL = FileListCellFull{tR,5};
                
                try
                    options = weboptions('Timeout',60);
                    outfilename = websave(tFileString,tURL,options);
                catch err
                    str = ['日期时间：',datestr(now),' 保存文件失败：',err.message];
                    fprintf('%s\n',str);
                    for i = 1:size(err.stack,1)
                        str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
                        fprintf('%s\n',str);
                    end
                end
                
            end
        end
        str = ['===FileSave2LocalDB_Full End==='];
        disp(str);         
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
% % % [EOF_Main]


%% sub function - NoticeDataCell2FileListCell
function newFileListCell = NoticeDataCell2FileListCell(IRDataCell)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% 输入输出预处理
if isempty(IRDataCell)
    newFileListCell = [];
    return;
end
% Head = {'StockCode','DateTime'[Str],'Title','NoticeType','FileURL','FileSize'};
% 2
% Head = {'StockCode','DateTime'[Double],'Title','NoticeType','FileURL','FileSize','FileName'};
newFileListCell = cell(size(IRDataCell,1),size(IRDataCell,2)+1);
newFileListCell(:,1:size(IRDataCell,2)) = IRDataCell;
newFileListCell{1,size(newFileListCell,2)} = 'FileName';
%% loop
for i = 2:size(IRDataCell,1)
    temp = IRDataCell{i,2};
    temp = datestr(datenum(temp),'yyyymmddHHMM');
    temp = str2double(temp);
    newFileListCell{i,2} = temp;
    
    tURL = IRDataCell{i,5};
    NameExt = GetExtName(tURL);
    
    Fstr = [IRDataCell{i,1},'_',num2str(newFileListCell{i,2}),'_',IRDataCell{i,3},NameExt];
    
    % 文件名检查，文件名不能包含 / \ : * ？ " < > | 
    CheckChar = {'\';'/';':';'*';'?';'"';'<';'>';'|';char(26)};
    for Ti = 1:length(CheckChar)
        if sum( Fstr==CheckChar{Ti} ) ~= 0
            Fstr( Fstr==CheckChar{Ti} ) = '_';
        end;
    end    
    
    newFileListCell{i,7} = Fstr;
    
end

end
% % % [EOF_NoticeDataCell2FileListCell]

%% sub function-GetExtName
function ExtName = GetExtName(URL)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% 输入输出预处理
ExtName = '.ExtensionNotKnown';
if isempty(URL)
    return;
end

%%
ExtNameCell = {'.pdf',...
    '.doc','.docx','.xls','.xlsx',...
    '.ppt','.pptx',...
    '.txt','.html',...
    '.mat',...
    '.jpg','.png','.tiff','.bmp','.jpeg','gif'};

% for i = 1:length(ExtNameCell)
%     expr = ExtNameCell{i};
%     out = regexpi(URL, expr,'match');
%     if ~isempty( out )
%         ExtName = out{1};
%         if strcmpi(expr,'.doc') || strcmpi(expr,'.ppt') || strcmpi(expr,'.xls')
%             ExtName = [ExtName,'X'];
%         end
%         break;
%     end
% end

ind = find( URL =='/' );
if ~isempty(ind)
    ind = ind(end);
    Tind = find( URL =='?' );
    if ~isempty(Tind) && Tind(1)>ind
        Tind = Tind(1);
        DotInd = find(URL(ind:Tind) == '.',1);
        if ~isempty(DotInd)
            temp = URL(ind:Tind);
            ExtName = temp(DotInd:end-1);
        end
    end
end

if strcmpi(ExtName, '.ExtensionNotKnown')
    ind = find( URL == '.' );
    if ~isempty(ind)
        ind = ind(end);
        Temp = URL(ind:end);
        if strcmpi(Temp,'.cn') || strcmpi(Temp,'.com') || ...
                strcmpi(Temp,'.net') || strcmpi(Temp,'.org')
            ExtName = '.html';
        end
    end
end

end
% % % [EOF_GetExtName]
