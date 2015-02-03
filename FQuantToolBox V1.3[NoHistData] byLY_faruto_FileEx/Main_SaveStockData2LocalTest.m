%% Main_SaveStockData2LocalTest
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/01/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%% 日志文件

fid = fopen('Dlog.txt','at+');
str = ['日期时间：',datestr(now),' 操作记录日志by李洋faruto '];
fprintf(fid,'%s\n',str);
%% 获取股票代码列表
run = 0;
if 1 == run
    try
        [StockList,StockListFull] = GetStockList_Web;
        save('StockList','StockList');
        
        str = ['日期时间：',datestr(now),' 更新股票代码列表'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 更新股票代码列表失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
else
    load StockList;
end

%% 获取指数代码列表
run = 0;
if 1 == run
    [IndexList] = GetIndexList_Web;
    IndexCodeDouble = cell2mat( IndexList(:,3) );
    save('IndexList','IndexList');
else
    load IndexList;
end
%% SaveStockInfo 获取股票基本信息以及所属行业板块（证监会行业分类）和所属概念板块（新浪财经定义）
run = 0;
if 1 == run
    [SaveLog,ProbList,NewList] = SaveStockInfo(StockList);
end
%% SaveStockNotice 获取个股公司公告信息，并保存文件至本地
run = 0;
if 1 == run
    [NoticeFileListCell,SaveLog,ProbList,NewList] = SaveStockNotice(StockList);
end
%% SaveStockInvestorRelationsInfo 获取个股投资者关系信息，并保存文件至本地
run = 0;
if 1 == run
    [IRInfoFileListCell,SaveLog,ProbList,NewList] = SaveStockInvestorRelationsInfo(StockList);
end
%% SaveIndexTSDay 保存指数数据
run = 0;
if 1 == run
    [SaveLog,ProbList,NewList] = SaveIndexTSDay(IndexList);
end
%% 股票数据更新-除权除息数据-无并行操作
run = 0;
if 1 == run
    try
        AdjFlag = 0;
        XRDFlag = 0;
        [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag);
        if ~isempty(ProbList)
            [SaveLog,ProbList,NewList] = SaveStockTSDay(ProbList,AdjFlag,XRDFlag);
        end
        str = ['日期时间：',datestr(now),' 股票数据更新-除权除息数据'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 股票数据更新-除权除息数据失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 股票数据更新-除权除息数据-并行操作 spmd Test
run = 0;
if 1 == run
    WorkNum = 3;
    if isempty(gcp('nocreate'))
        Pobj = parpool( WorkNum );
        Pobj.NumWorkers
    end
    Pobj = gcp('nocreate');
    Pobj.NumWorkers
    % delete(Pobj);
    
    % % 30
    Sind = 1;
    StockList = StockList(Sind:end,:);
    
    SList = cell(WorkNum, 1);
    Num = floor( size(StockList,1)/WorkNum );
    for i = 1:WorkNum
        if i == WorkNum
            Lind = 1+Num*(i-1);
            SList{i} = StockList(Lind:end,:);
        else
            Lind = 1+Num*(i-1);
            Rind = Lind+Num-1;
            SList{i} = StockList(Lind:Rind,:);
        end
    end
    spmd
        AdjFlag = 0;
        XRDFlag = 0;
        [SaveLog,ProbList,NewList] = SaveStockTSDay(SList{labindex},AdjFlag,XRDFlag);
        
        str = ['日期时间：',datestr(now),' 股票数据更新-除权除息数据-并行操作'];
        fprintf(fid,'%s\n',str);
        
    end
end
%% 获取交易明细数据Tick-无并行操作
run = 0;
if 1 == run
    try
        [SaveLog,ProbList,NewList] = SaveStockTick(StockList);
        if ~isempty(ProbList)
            PList = ProbList;
            CheckFlag = 1;
            [SaveLog,ProbList,NewList] = SaveStockTick(StockList,[],PList,CheckFlag);
        end
        str = ['日期时间：',datestr(now),' 获取股票交易明细数据结束'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 获取股票交易明细数据失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 获取交易明细数据Tick-并行操作 spmd Test
run = 0;
if 1 == run
    WorkNum = 3;
    if isempty(gcp('nocreate'))
        Pobj = parpool( WorkNum );
        Pobj.NumWorkers
    end
    Pobj = gcp('nocreate');
    Pobj.NumWorkers
    % delete(Pobj);
    
    % % 30
    Sind = 1;
    StockList = StockList(Sind:end,:);
    
    SList = cell(WorkNum, 1);
    Num = floor( size(StockList,1)/WorkNum );
    for i = 1:WorkNum
        if i == WorkNum
            Lind = 1+Num*(i-1);
            SList{i} = StockList(Lind:end,:);
        else
            Lind = 1+Num*(i-1);
            Rind = Lind+Num-1;
            SList{i} = StockList(Lind:Rind,:);
        end
    end
    spmd
        
        [SaveLog,ProbList,NewList] = SaveStockTick(SList{labindex});
        
        str = ['日期时间：',datestr(now),' 获取股票交易明细数据结束'];
        fprintf(fid,'%s\n',str);
        
    end
end
%% 股票数据更新-前复权
run = 0;
if 1 == run
    try
        AdjFlag = 1;
        XRDFlag = 0;
        [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag);
        str = ['日期时间：',datestr(now),' 股票数据更新-前复权'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 股票数据更新-前复权失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 股票数据更新-后复权
run = 0;
if 1 == run
    try
        AdjFlag = 2;
        XRDFlag = 0;
        [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag);
        str = ['日期时间：',datestr(now),' 股票数据更新-后复权'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 股票数据更新-后复权失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 除权除息信息
run = 0;
if 1 == run
    try
        AdjFlag = 0;
        XRDFlag = 1;
        [SaveLog,ProbList,NewList] = SaveStockTSDay(StockList,AdjFlag,XRDFlag);
        if ~isempty(ProbList)
            [SaveLog,ProbList,NewList] = SaveStockTSDay(ProbList,AdjFlag,XRDFlag);
        end
        str = ['日期时间：',datestr(now),' 更新除权除息信息'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 更新除权除息信息失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 财务指标
run = 0;
if 1 == run
    try
        Opt = 0;
        [SaveLog,ProbList,NewList] = SaveStockFD(StockList,Opt);
        if ~isempty(ProbList)
            [SaveLog,ProbList,NewList] = SaveStockFD(ProbList,Opt);
        end
        str = ['日期时间：',datestr(now),' 更新财务指标'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 更新财务指标失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 3张表
run = 0;
if 1 == run
    try
        Opt = 1;
        [SaveLog,ProbList,NewList] = SaveStockFD(StockList,Opt);
        if ~isempty(ProbList)
            [SaveLog,ProbList,NewList] = SaveStockFD(ProbList,Opt);
        end
        str = ['日期时间：',datestr(now),' 更新3张表'];
        fprintf(fid,'%s\n',str);
    catch err
        str = ['日期时间：',datestr(now),' 更新3张表失败：',err.message];
        fprintf(fid,'%s\n',str);
        for i = 1:size(err.stack,1)
            str = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
            fprintf(fid,'%s\n',str);
        end
    end
end
%% 关闭打开的文件

fclose('all');

%% Exist
% exist;

%% Record Time
toc;
displayEndOfDemoMessage(mfilename);