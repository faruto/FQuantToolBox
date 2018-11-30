function unicodestr = URLHexCode2Unicode(InputString,encoding)
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2014/12/12
%% 输入输出预处理
if nargin < 2
    encoding = 'GB2312';
end
if nargin < 1
    InputString = '%B0%D9%B6%C8%D2%BB%CF%C2';
end

unicodestr = [];
%% 转换
Tind = find( InputString == '%' );

NumTemp = zeros(1,length(Tind));
for i = 1:length(Tind)
    temp = InputString( Tind(i)+1:Tind(i)+2 );
    NumTemp(i) = hex2dec(temp);
    
end

unicodestr = native2unicode(NumTemp,encoding);