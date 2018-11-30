function [StockInfo] = GetStockInfo_Web(StockCode)
% 获取股票基本信息以及所属行业板块（证监会行业分类）和所属概念板块（新浪财经定义）
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
% 公司简介：http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpInfo/stockid/600588.phtml
% 板块信息：http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/600588/menu_num/2.phtml
%% 输入输出预处理
if nargin < 1 || isempty(StockCode)
    StockCode = '600588';
end

% 股票代码预处理，目标代码demo '600588'
% 股票代码预处理，目标代码demo '600588'
if strcmpi(StockCode(1),'s')
    StockCode = StockCode(3:end);
end
if strcmpi(StockCode(end),'h') ||  strcmpi(StockCode(end),'z')
    StockCode = StockCode(1:end-2);
end
StockInfo = [];
%% 获取公司简介
URL = ['http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpInfo/stockid/',StockCode,'.phtml'];

[~,TableCell] = GetTableFromWeb(URL);

if iscell( TableCell ) && ~isempty(TableCell)
    TableInd = 4;
    FIndCell = TableCell{TableInd};
else
    FIndCell = [];
end

StockInfo.CompanyIntro = FIndCell;

temp = StockInfo.CompanyIntro{3,4};
if ~isempty(temp)
    temp = str2double( datestr(datenum(temp,'yyyy-mm-dd'),'yyyymmdd') );
    StockInfo.IPOdate = temp;
else
    StockInfo.IPOdate = [];
end

temp = StockInfo.CompanyIntro{4,2};
temp = str2double( temp );
StockInfo.IPOprice = temp;
%% 获取板块信息
% http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/600588/menu_num/2.phtml
URL = ...
    ['http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/',StockCode,'/menu_num/2.phtml'];

[~,TableCell] = GetTableFromWeb(URL);

if iscell( TableCell ) && ~isempty(TableCell)
    TableInd = 4;
    tIndustrySector = TableCell{TableInd};
    TableInd = 5;
    tConceptSector_Sina = TableCell{TableInd};
else
    tIndustrySector = [];
    tConceptSector_Sina = [];
    return;
end

temp = tIndustrySector{3,1};
StockInfo.IndustrySector = temp;

temp = tConceptSector_Sina(3:end,1);
StockInfo.ConceptSector_Sina = temp;
if strcmpi(temp,'对不起，暂时没有相关概念板块信息')
    StockInfo.ConceptSector_Sina = [];
end
