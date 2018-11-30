function [Status, Message] = SaveData2File(Data, FileName, ColNamesCell,varargin)
%% SaveData2File
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/05/01
%% 输入输出预处理
Status = 1;
Message = [];
if nargin < 3 || isempty(ColNamesCell)
    ColNamesCell = [];
end
if nargin < 2 || isempty(FileName)
    FileName = 'OutData.xlsx';
end
if nargin < 1 || isempty(Data)
    Status = 0;
    Message = '缺少输入参数，请输入待保存的数据！';
    disp(Message);
    return;
end

% ColNamesCell 处理
[Rlen, Clen] = size(Data);
if ~isempty(ColNamesCell)
    tlen = length(ColNamesCell);
    if tlen < Clen
        for i = tlen+1:Clen
            str = ['VarName',num2str(i)];
            ColNamesCell{i} = str;
        end
    end
    
    if tlen > Clen
        ColNamesCell = ColNamesCell(1:Clen);
    end
end

% FileName 检查处理
ind = find(FileName == '.', 1,'last');
if isempty(ind)
    FileName = [FileName,'.xlsx'];
    ind = find(FileName == '.', 1,'last');
end
ExtCell = {'.txt','.dat','.csv','.xls','.xlsb','.xlsx','.xlsm'};

ExtName = FileName(ind:end);
if ~ismember(ExtName, ExtCell)
    Status = 0;
    Message = '请检查输入的文件扩展名！（仅支持如下扩展名）';
    disp(Message);
    disp(ExtCell);
    return;
end

tExtCell = {'.xls','.xlsb','.xlsx','.xlsm'};
if ismember(ExtName, tExtCell)
    warning('off')
end

%% Main

switch class( Data )
    case 'double'
        
        [tS, tM] = Double2File(Data, FileName, ColNamesCell,varargin{:});
        
    case 'cell'
        
        [tS, tM] = Cell2File(Data, FileName, ColNamesCell,varargin{:});
        
    case 'struct'
        
        [tS, tM] = Struct2File(Data, FileName, ColNamesCell,varargin{:});
        
    otherwise
        Status = 0;
        Message = '输入数据类型未知！请检查！';
        disp(Message);
        return;
end

end
%% sub fun-Double2File
function [tS, tM] = Double2File(Data, FileName, ColNamesCell,varargin)

tS = 1;
tM = [];

tCell = num2cell(Data);
if ~isempty( ColNamesCell )
    tCell = [ColNamesCell;tCell];
end
Fun = @(x)( num2str(x) );
tCell = cellfun( Fun,tCell, 'UniformOutput', false);

T = cell2table(tCell);
writetable(T,FileName,'WriteVariableNames',false,varargin{:});

end

%% sub fun-Cell2File
function [tS, tM] = Cell2File(Data, FileName, ColNamesCell,varargin)

tS = 1;
tM = [];

tCell = Data;
if ~isempty( ColNamesCell )
    tCell = [ColNamesCell;tCell];
end
Fun = @(x)( num2str(x) );
tCell = cellfun( Fun,tCell, 'UniformOutput', false);

T = cell2table(tCell);
writetable(T,FileName,'WriteVariableNames',false,varargin{:});

end

%% sub fun-Struct2File
function [tS, tM] = Struct2File(Data, FileName, ColNamesCell,varargin)

tS = 1;
tM = [];

[tS, tM] = Cell2File(Data, FileName, ColNamesCell,varargin{:});

end