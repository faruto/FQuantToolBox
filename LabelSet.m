function LabelSet(Ghandle, Dates, TickStep, TickNum, Style,XTRot)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/5/1
%% Check
if nargin < 6 || isempty(XTRot)
    XTRot = 55;
end
if nargin < 5
    % 0 默认形式
    % 1 日线数据-月标签
    % 2 日线数据-年标签
    % 3 分钟线数据-日标签
    % 4 分钟线数据-月标签
    % 5 分钟线数据-年标签
    % 
    % 8 自适应调整
    Style = 0;
    
end
if nargin < 4 || isempty(TickNum)
    TickNum = 50;
end
if nargin < 3 || isempty(TickStep)
    TickStep = length(Dates)/TickNum;
    TickStep = ceil(TickStep);
end
%% 自适应调整
if Style == 8 
    temp = Dates(1);
    if round(temp/1e11)>=1
        Style = 5;
		
    else   
        Style = 2;
		
    end

end
%% 

if Style == 1 || Style == 2
    
    Year = floor( Dates/1e4 );
    Year_unique = unique(Year);
    
    YearMonth = floor( Dates/1e2 );
    YearMonth_unique = unique(YearMonth);
    
end

if Style == 3 || Style == 4 || Style == 5
    Year = floor( Dates/1e8 );
    Year_unique = unique(Year);
    
    YearMonth = floor( Dates/1e6 );
    YearMonth_unique = unique(YearMonth);
    
    YearMonthDay = floor( Dates/1e4 );
    YearMonthDay_unique = unique(YearMonthDay);    
end

%% Label Set
switch Style
    
    % 0 默认形式
    case 0
        newTick = (1:TickStep:length(Dates))';
        if newTick(end) ~= length(Dates)
            newTick(end) = length(Dates);
        end
        
        TickLabel = Dates(newTick);
        TickLabelcell =  num2cell(TickLabel);
        newTickLabel = cellfun(@num2str, TickLabelcell,'UniformOutput', false);
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end
        
    % 1 日线数据-月标签    
    case 1
        newTick = zeros( length(YearMonth_unique),1 );
        newTickLabel = cell( length(YearMonth_unique),1 );
        for i = 1:length( YearMonth_unique )
            ind = find( YearMonth == YearMonth_unique(i), 1, 'first');
            newTick(i) = ind;
            newTickLabel{i,1} = num2str( YearMonth_unique(i) );
            
        end
        
        % 第一个位置和最后一个位置重新设定
        newTickLabel{1,1} = num2str(Dates(1));
        if newTick(end) ~= length(Dates)
            newTick(end+1,1) = length(Dates);
            Len = length(newTickLabel);
            newTickLabel{Len+1,1} = num2str(Dates(end));
        else
            Len = length(newTickLabel);
            newTickLabel{Len,1} = num2str(Dates(end));            
        end
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end
      
    % 2 日线数据-年标签    
    case 2
        newTick = zeros( length(Year_unique),1 );
        newTickLabel = cell( length(Year_unique),1 );
        for i = 1:length( Year_unique )
            ind = find( Year == Year_unique(i), 1, 'first');
            newTick(i) = ind;
            newTickLabel{i,1} = num2str( Year_unique(i) );
        end
        
        % 第一个位置和最后一个位置重新设定
        newTickLabel{1,1} = num2str(Dates(1));
        if newTick(end) ~= length(Dates)
            newTick(end+1,1) = length(Dates);
            Len = length(newTickLabel);
            newTickLabel{Len+1,1} = num2str(Dates(end));
        else
            Len = length(newTickLabel);
            newTickLabel{Len,1} = num2str(Dates(end));             
        end       
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end
      
    % 3 分钟线数据-日标签    
    case 3
        newTick = zeros( length(YearMonthDay_unique),1 );
        newTickLabel = cell( length(YearMonthDay_unique),1 );
        for i = 1:length( YearMonthDay_unique )
            ind = find( YearMonthDay == YearMonthDay_unique(i), 1, 'first');
            newTick(i) = ind;
            newTickLabel{i,1} = num2str( YearMonthDay_unique(i) );
        end
        
        % 第一个位置和最后一个位置重新设定
        newTickLabel{1,1} = num2str(Dates(1));
        if newTick(end) ~= length(Dates)
            newTick(end+1,1) = length(Dates);
            Len = length(newTickLabel);
            newTickLabel{Len+1,1} = num2str(Dates(end));
        else
            Len = length(newTickLabel);
            newTickLabel{Len,1} = num2str(Dates(end));             
        end          
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end
     
    % 4 分钟线数据-月标签    
    case 4
        newTick = zeros( length(YearMonth_unique),1 );
        newTickLabel = cell( length(YearMonth_unique),1 );
        for i = 1:length( YearMonth_unique )
            ind = find( YearMonth == YearMonth_unique(i), 1, 'first');
            newTick(i) = ind;
            newTickLabel{i,1} = num2str( YearMonth_unique(i) );
        end
        
        % 第一个位置和最后一个位置重新设定
        newTickLabel{1,1} = num2str(Dates(1));
        if newTick(end) ~= length(Dates)
            newTick(end+1,1) = length(Dates);
            Len = length(newTickLabel);
            newTickLabel{Len+1,1} = num2str(Dates(end));
        else
            Len = length(newTickLabel);
            newTickLabel{Len,1} = num2str(Dates(end));             
        end         
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end 
        
    % 5 分钟线数据-年标签    
    case 5
        newTick = zeros( length(Year_unique),1 );
        newTickLabel = cell( length(Year_unique),1 );
        for i = 1:length( Year_unique )
            ind = find( Year == Year_unique(i), 1, 'first');
            newTick(i) = ind;
            newTickLabel{i,1} = num2str( Year_unique(i) ); 
        end
        
        % 第一个位置和最后一个位置重新设定
        newTickLabel{1,1} = num2str(Dates(1));
        if newTick(end) ~= length(Dates)
            newTick(end+1,1) = length(Dates);
            Len = length(newTickLabel);
            newTickLabel{Len+1,1} = num2str(Dates(end));
        else
            Len = length(newTickLabel);
            newTickLabel{Len,1} = num2str(Dates(end));             
        end        
        
        set(Ghandle,'XTick',newTick);
        set(Ghandle,'XTickLabel',newTickLabel);
        if verLessThan('matlab', '8.4')
            TickLabelRotate(Ghandle, 'x', 30, 'right');
        else
            Gobj =gca;
            Gobj.XTickLabelRotation = XTRot;
        end  
        
    % Next Para    
        
    
    
    
end