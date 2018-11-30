function URLHexCode = Unicode2URLHexCode_Ch(InputString,encoding)
% 仅将输入的字符串中的中文字符转换成GB2312编码
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 2
    encoding = 'GB2312';
end
if nargin < 1
    InputString = 'BD百度Tt一下SS';
end
if isempty(InputString)
    URLHexCode = [];
    return;
end

URLHexCode = [];
%% 转换
Len = length(InputString);
isFlag = isChineseChar(InputString,encoding);
for i = 1:Len
    if isFlag(i) == 1

        temp = unicode2native(InputString(i),encoding);
        
        HexTemp = dec2hex(temp);
        
        StrTemp =[];
        for i = 1:size(HexTemp,1)
            
            StrTemp = [StrTemp,'%',HexTemp(i,:)];
        end
        
        URLHexCode = [URLHexCode,StrTemp];
        
    else
        URLHexCode = [URLHexCode,InputString(i)];
    end
end