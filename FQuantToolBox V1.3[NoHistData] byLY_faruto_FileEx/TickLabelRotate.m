function TickLabelRotate(AX_handle,tag,rot,HorizontalAlignment,UpDown)
% ×ø±êTickLabelÐý×ª
% by LiYang
% Email:farutoliyang@gmail.com
% 2012/5/25
% Matlab Version : Matlab R2011b
%%
if nargin < 5
    % 1 Down 2 Up 3 Left 4 Right
    UpDown = 1;
end
if nargin < 4
    HorizontalAlignment = 'right';
    % left | center | right
end
if nargin < 3
    rot = 60;
end
if nargin < 2
    tag = 'x';
end
%% 
switch tag
    case 'x'
        str = get(AX_handle,'XTickLabel');
        x = get(AX_handle,'XTick');
        yl = ylim(AX_handle);
        set(AX_handle,'XTickLabel',[]);
        if UpDown == 1
            y = zeros(size(x)) + yl(1) - range(yl)/80;       
        end
        if UpDown == 2
            y = zeros(size(x)) + yl(end) + range(yl)/80;
        end
        
        text(x,y,str,'rotation',rot,...
            'Interpreter','none','HorizontalAlignment',HorizontalAlignment);
    case 'y'
        str = get(AX_handle,'YTickLabel');
        y = get(AX_handle,'YTick');
        xl = xlim(AX_handle);
        set(AX_handle,'YTickLabel',[]);
        if UpDown == 3
            x = zeros(size(y)) + xl(1) - range(xl)/80;       
        end
        if UpDown == 4
            x = zeros(size(y)) + xl(end) + range(xl)/80;
        end
        
        text(x,y,str,'rotation',rot,...
            'Interpreter','none','HorizontalAlignment',HorizontalAlignment);
end