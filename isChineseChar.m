function isFlag = isChineseChar(InputString,encoding)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 2
    encoding = 'GB2312';
end
if nargin < 1
    InputString = 'FM百度一下Test';
end

Len = length(InputString);
isFlag = zeros(Len,1);
%% 'GB2312'
if strcmpi( encoding, 'GB2312')
    % 对于GB2312的字符（ie.区位），一个汉字对应于两个字节。 每个字节都是大于A0（十六进制,即160），
    % 若，第一个字节大于A0，而第二个字节小于A0，那么它应当不是汉字（仅仅对于GB2312)
    for i = 1:Len
        info = unicode2native(InputString(i),encoding);
        bytes = size(info,2);
        Ftemp = 0;
        if (bytes == 2)
            if(info(1)>160 && info(2)>160)
                Ftemp = 1;
            end
        end
        isFlag(i) = Ftemp;
    end
end
%% 
