function [StockDataXRD, adjFactor] = CalculateStockXRD(StockData, XRD_Data, AdjFlag, AlgoFlag)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% 涨跌幅前后复权算法
% 经典前后复权算法
% 等比复权算法
% StockData:日期 开 高 低 收
% AdjFlag 1:前复权价格生成 2:后复权价格生成
% % % 待完成 待完善 2014.12.09
% 除权价=(除权前一日收盘价+配股价X配股比率-每股派息)/(1+配股比率+送股比率)
% 除权因子=除权前一日收盘价/除权价
% AlgoFlag 如果 1 == AlgoFlag 此时要求输入的StockData的最后一列为复权因子
% 1 涨跌幅前后复权算法
% 2 经典前后复权算法
%% 输入输出预处理
if nargin < 4 || isempty(AlgoFlag)
    AlgoFlag = 1;
end
if nargin < 3 || isempty(AdjFlag)
    AdjFlag = 1;
end

Date = StockData(:,1);

StockDataXRD = [];
adjFactor = [];

StockDataXRD = StockData;
StockDataXRD(:,1) = StockData(:,1);
%% 前复权价格生成
if 1 == AdjFlag
    % 涨跌幅前后复权算法
    % % 次数输入的StockData的数据最好从上市日开始
    if 1 == AlgoFlag
        if size(StockData,2) > 5
            BackwardAdjFactor = StockData(:,end);
            ForwardAdjFactor = BackwardAdjFactor/BackwardAdjFactor(end,1);
            
            for i = 2:5
                StockDataXRD(:,i) = StockData(:,i).*ForwardAdjFactor;
            end
        else
            str = ['输入的StockData数据列数不够，至少应该为日期、开、高、低、收、复权因子'];
            disp(str);
        end
    end
    
    
    % 经典前后复权算法   
    if 2 == AlgoFlag
        for i = 2:5
            Web_XRD_Data = XRD_Data;
            Stock_Data_Date = Date;
            Stock_Data_Close = StockData(:,i);
            [ XRD_Close ] = F_Stock_XRD_Processing(Web_XRD_Data,Stock_Data_Date,Stock_Data_Close);
            StockDataXRD(:,i) = XRD_Close;
        end
    end
end
%% 后复权价格生成
if 2 == AdjFlag
    % 涨跌幅前后复权算法
    if 1 == AlgoFlag
        if size(StockData,2) > 5
            BackwardAdjFactor = StockData(:,end);
            ForwardAdjFactor = BackwardAdjFactor/BackwardAdjFactor(end,1);
            
            for i = 2:5
                StockDataXRD(:,i) = StockData(:,i).*BackwardAdjFactor;
            end
        else
            str = ['输入的StockData数据列数不够，至少应该为日期、开、高、低、收、复权因子'];
            disp(str);
        end
    end
    
    
    % 经典前后复权算法   
    if 2 == AlgoFlag
        
        
    end   
end

end

%% sub function
function [ XRD_Close ] = F_Stock_XRD_Processing(Web_XRD_Data,Stock_Data_Date,Stock_Data_Close)
%% 调用格式:
%      [ XRD_Close ] = F_Stock_XRD_Processing(Web_XRD_Data,Stock_Data_Date,Stock_Data_Close)
% 输入: Web_XRD_Data → 除权除息数据
%       Stock_Data_Date → 日期数据
%       Stock_Data_Close → 价格（收盘价）数据
% 输出: XRD_Close → 前复权数据
% by Chandeman
% 校验于 2014/8/4
% 如有任何问题请联系Email: 414117285@qq.com
%% 找出除权除夕日期的位置

if ~isempty(Web_XRD_Data)
    
    XRD_Time = nan(length(Web_XRD_Data(:,1)),1);
    Intermediate_variable_j = length(Web_XRD_Data(:,1));
    
    for Intermediate_variable_i = length(Web_XRD_Data(:,1)) : -1 : 1
        
        if find(Web_XRD_Data(Intermediate_variable_i,1) == Stock_Data_Date(:,1))
            XRD_Time(Intermediate_variable_j,1) = ...
                find(Web_XRD_Data(Intermediate_variable_i,1) == Stock_Data_Date(:,1));
            Intermediate_variable_j = Intermediate_variable_j - 1;
        end
        
    end
    
    XRD_Time = XRD_Time(~isnan(XRD_Time));
    
    %% 前复权处理
    
    XRD_Close = nan(length(Stock_Data_Close),1);
    
    if ~isempty(XRD_Time)
        
        XRD_Data = Web_XRD_Data(end-length(XRD_Time)+1:end,:);
        
        for Intermediate_variable_i = length(XRD_Time) : -1 : 0
            
            if  Intermediate_variable_i == length(XRD_Time)
                XRD_Close(XRD_Time(Intermediate_variable_i):end) = ...
                    Stock_Data_Close(XRD_Time(Intermediate_variable_i):end);
            elseif Intermediate_variable_i == 0
                XRD_Close(1:XRD_Time(Intermediate_variable_i+1)-1) = ...
                    Stock_Data_Close(1:XRD_Time(Intermediate_variable_i+1)-1);
                for Intermediate_variable_j = 1 : length(XRD_Time)
                    XRD_Close(1:XRD_Time(Intermediate_variable_i+1)-1) = ...
                        (XRD_Close(1:XRD_Time(Intermediate_variable_i+1)-1) - XRD_Data(Intermediate_variable_j,4)/10 + XRD_Data(Intermediate_variable_j,5)/10*XRD_Data(Intermediate_variable_j,6))...
                        /(1+(XRD_Data(Intermediate_variable_j,2)+XRD_Data(Intermediate_variable_j,3)+XRD_Data(Intermediate_variable_j,5))/10);
                end
            else
                XRD_Close(XRD_Time(Intermediate_variable_i):XRD_Time(Intermediate_variable_i+1)-1) = ...
                    Stock_Data_Close(XRD_Time(Intermediate_variable_i):XRD_Time(Intermediate_variable_i+1)-1);
                for Intermediate_variable_j = Intermediate_variable_i + 1 : length(XRD_Time)
                    XRD_Close(XRD_Time(Intermediate_variable_i):XRD_Time(Intermediate_variable_i+1)-1) = ...
                        (XRD_Close(XRD_Time(Intermediate_variable_i):XRD_Time(Intermediate_variable_i+1)-1) - XRD_Data(Intermediate_variable_j,4)/10 + XRD_Data(Intermediate_variable_j,5)/10*XRD_Data(Intermediate_variable_j,6))...
                        /(1+(XRD_Data(Intermediate_variable_j,2)+XRD_Data(Intermediate_variable_j,3)+XRD_Data(Intermediate_variable_j,5))/10);
                end
            end
            
        end
        
    else
        XRD_Close = Stock_Data_Close;
    end
    
else
    XRD_Close = Stock_Data_Close;
end

XRD_Close = round(XRD_Close*100)/100;
end