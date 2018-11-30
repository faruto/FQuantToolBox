function [DataCell,StatusOut] = GetFutureVolOIRanking_Web(DateStr, FutureCode)
% 获取期货品种成交量和持仓量排名
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 2 || isempty(FutureCode)
    FutureCode = 'IF';
end
if nargin < 1 || isempty(DateStr)
    DateStr = '20141215';
end

StatusOut = 1;
DataCell = [];
%% 中金所-IF TF
% 获取数据网址http://www.cffex.com.cn/fzjy/ccpm/
% http://www.cffex.com.cn/fzjy/ccpm/201412/15/IF.xml
% http://www.cffex.com.cn/fzjy/ccpm/201412/15/TF.xml

% % 字段名字 举例
%{
	<data  Text="IF1401                        " Value="0" >
		<instrumentId>IF1401                        </instrumentId>
		<tradingDay>20140109</tradingDay>
		<dataTypeId>0</dataTypeId>
		<rank>1</rank>
		<shortname>国泰君安    </shortname>
		<volume>126973</volume>
		<varVolume>1519</varVolume>
		<partyid>0001      </partyid>
		<productid>IF      </productid>
	</data>
instrumentId 合约名称
tradingDay 交易日期
dataTypeId 数据类型ID-0：成交量排名数据；1：持买单量排名数据；2：持卖单量排名数据
rank 排名顺序
shortname 期货公司简称
volume 量
varVolume 相对上一日变化量
partyid 期货公司会员代码
productid 品种ID

%}
if strcmpi(FutureCode, 'if') || strcmpi(FutureCode, 'tf') 
    Fcode = upper(FutureCode);
    % % 获取网页内容
    
    datetemp = DateStr;
    dstring = [datetemp(1:6), '/', datetemp(7:end)];
    
    url2Read = ['http://www.cffex.com.cn/fzjy/ccpm/', dstring, '/',Fcode,'.xml'];
    
    if verLessThan('matlab', '8.3')
        [str,status] = urlread_General(url2Read, 'Charset', 'GBK', 'TimeOut', 10);
    else
        [str,status] = urlread(url2Read, 'Charset', 'GBK', 'TimeOut', 10);
        [str,status] = urlread(url2Read, 'TimeOut', 10);
    end
    URLString = java.lang.String(str);

    if status == 0
        StatusOut = 0;
        DataCell = [];
        return;
    end
    tradingDay = datetemp;
    % % 'instrumentId'
    String = str;
    FieldString = 'instrumentId';
    instrumentId = FieldGet(String, FieldString);
    
    if isempty(instrumentId)
        StatusOut = 0;
        DataCell = [];
        return;
    end
    % % 'shortname'
    String = str;
    FieldString = 'shortname';
    shortname = FieldGet(String, FieldString);
    % % 'partyid'
    String = str;
    FieldString = 'partyid';
    partyid = FieldGet(String, FieldString);
    % % 'volume'
    String = str;
    FieldString = 'volume';
    volume = FieldGet(String, FieldString);
    % % 'varVolume'
    String = str;
    FieldString = 'varVolume';
    varVolume = FieldGet(String, FieldString);
    % % 'rank'
    String = str;
    FieldString = 'rank';
    rank = FieldGet(String, FieldString);    
    
    % %
    len  = length(shortname)/60;
    tColNum = 3;
    tRowNum = length(shortname)/tColNum;
    if mod(length(shortname), 60)~=0
        disp('warning:mod(length(shortname), 60)~=0');
        disp(DateStr);
        len = ceil(len);
    end
    
    Table_Num = len;
    
    instrumentId = instrumentId(1:length(shortname));
    
    m = 3;
    n = tRowNum*tColNum/m;
    
    % shortname-partyid
    temp = strcat(shortname, '-');
    shortname = strcat(temp, partyid);
    
    instrumentId = reshape( instrumentId, m, n )';
    shortname = reshape( shortname, m, n )';
    partyid = reshape( partyid, m, n )';
    volume = reshape( volume, m, n )';
    varVolume = reshape( varVolume, m, n )';
    rank = reshape( rank, m, n )';
    
    volume = cellfun(@str2double, volume);
    varVolume = cellfun(@str2double, varVolume);
    rank = cellfun(@str2double, rank);
    
    % %
    DataCell = cell(Table_Num, 1);
    
    HeadTemp = cell(3, 10);
    HeadTemp{2,2} = '成交量排名';
    HeadTemp{2,5} = '持买单量排名';
    HeadTemp{2,8} = '持卖单量排名';
    HeadTemp(3,:) = {'名次','会员简称','成交量','比上交易日增减', ...
        '会员简称','持买单量', '比上交易日增减', '会员简称', '持卖单量', '比上交易日增减'};
    
    tRank = rank(:,1);
    IndOnd = find( tRank == 1 );
    RowNumCell = cell(Table_Num, 1);
    for i = 1:Table_Num
        if i < Table_Num
            sind = IndOnd(i);
            eind = IndOnd(i+1)-1;
            RowNumCell{i,1} = tRank( IndOnd(i):IndOnd(i+1)-1,: );
        else
            sind = IndOnd(i);
            eind = length(tRank);            
            RowNumCell{i,1} = tRank( IndOnd(i):end,: );
        end
        ranktemp = RowNumCell{i,1};
        RowNum = length(ranktemp);
        DataCell{i,1} = cell(RowNum+3, 10);
        
        
        CellTemp = cell(RowNum, 10);
        
        
        CellTemp(:,1) = num2cell(ranktemp);
        
        HeadTemp{1,1} = [instrumentId{sind,1}, '-',num2str(tradingDay)];
        
        CellTemp(:,2) = shortname( sind:eind,1 );
        temp = volume( sind:eind,1 );
        CellTemp(:,3) = num2cell(temp);
        temp = varVolume( sind:eind,1 );
        CellTemp(:,4) = num2cell(temp);
        
        CellTemp(:,5) = shortname( sind:eind,2 );
        temp = volume( sind:eind,2 );
        CellTemp(:,6) = num2cell(temp);
        temp = varVolume( sind:eind,2 );
        CellTemp(:,7) = num2cell(temp);
        
        CellTemp(:,8) = shortname( sind:eind,3 );
        temp = volume( sind:eind,3 );
        CellTemp(:,9) = num2cell(temp);
        temp = varVolume( sind:eind,3 );
        CellTemp(:,10) = num2cell(temp);
        
        DataCell{i,1}(1:3, :) =  HeadTemp;
        DataCell{i,1}(4:end, :) =  CellTemp;
        
    end
    
end


%% 上期所-
if strcmpi(FutureCode, 'cu')
    Fcode = upper(FutureCode);
    
end

%% 大交所-
if strcmpi(FutureCode, 'y')
    Fcode = upper(FutureCode);
    
end

%% 郑交所-
if strcmpi(FutureCode, 'sr')
    Fcode = upper(FutureCode);
    
end

%% End of GetFutureVolOIRanking_Web
end




%%  FieldGet-sub function
function DataCell = FieldGet(String, FieldString)
% FieldGet
% by LiYang
% Email:farutoliyang@gmail.com
% 2014/01/10
expr = ['<',FieldString,'>.*?</',FieldString,'>'];
[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = regexpi(String, expr);

Len = length(matchstring);
DataCell = cell(Len, 1);

for i = 1:Len
    strtemp = matchstring{1,i};
    [sind, eind] = regexpi(strtemp, '>.*?<');
    
    temp = strtemp(sind+1:eind-1);
    ind = find(temp == ' ');
    if ~isempty(ind)
        temp = temp(1:ind-1);
    end
    DataCell{i,1} = temp;
end
end