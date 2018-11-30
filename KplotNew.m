function KplotNew(varargin)
%% fun help
% function Kplot(O,H,L,C)
%          Kplot(O,H,L,C,date)
%          Kplot(O,H,L,C,date,colorUp,colorDown,colorLine)
%          Kplot(OHLC)
%          Kplot(OHLC,date)
%          Kplot(OHLC,date,colorUp,colorDown,colorLine)
% required inputs: column vectors of O(pen), H(igh), L(ow)
% and C(lose) prices of commodity. 
% Alternative: OHLC matrix of size [rowsx4] 
%
% Note: identical inputs as required for barChartPlot except for colors
% See if we have [OHLC] or seperate vectors and retrieve our 
% required variables (Feel free to make this code more pretty ;-)
%%
isMat = size(varargin{1},2);
indexShift = 0;

if isMat == 4,
    O = varargin{1}(:,1);
    H = varargin{1}(:,2);
    L = varargin{1}(:,3);
    C = varargin{1}(:,4);
else
    O = varargin{1};
    H = varargin{2};
    L = varargin{3};
    C = varargin{4};
    indexShift = 3;
end
if nargin+isMat < 7,
    colorDown = 'g'; 
    colorUp = 'r'; 
    colorLine = 'k';
else
    colorUp = varargin{3+indexShift};
    colorDown = varargin{4+indexShift};
    colorLine = varargin{5+indexShift};
end
if nargin+isMat < 6,
    date = (1:length(O))';
else
    if varargin{2+indexShift} ~= 0
        date = varargin{2+indexShift};
    else
        date = (1:length(O))';
    end
end

% w = Width of body, change multiplier to draw body thicker or thinner
% the 'min' ensures no errors on weekends ('time gap Fri. Mon.' > wanted
% spacing)
if length(date)>=3
    w=.3*min([(date(2)-date(1)) (date(3)-date(2))]);
else
    w = .3;
end
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
    %    line([date(i) date(i)],[L(i) H(i)],'Color',colorLine);
    
    % ÑôÏß
    if O(i)<=C(i)
        colorLine = colorUp;
        line([date(i) date(i)],[L(i) O(i)],'Color',colorLine);
        line([date(i) date(i)],[C(i) H(i)],'Color',colorLine);        
    end
    % ÒõÏß
    if O(i)>C(i)
        colorLine = colorDown;
        line([date(i) date(i)],[L(i) C(i)],'Color',colorLine);
        line([date(i) date(i)],[O(i) H(i)],'Color',colorLine);
    end 
end
%%%%%%%%%%draw white (or user defined) body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorDown,'EdgeColor', colorDown);
end
%%%%%%%%%%draw black (or user defined) body(up day)%%%%%%%%%%%%%%%%%%%
n=find(d>=0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorUp,'EdgeColor', colorUp);
end

xlim([0 length(O)+1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off