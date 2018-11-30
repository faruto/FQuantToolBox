%% Main_MatlabSendMailTest
% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/05/01
%% A Little Clean Work
tic;
% clear;
% clc;
% close all;
format compact;
%%

SourceAddress = '输入自己的邮箱地址'; %自己的邮箱地址
password = '输入自己邮箱的密码'; %输入自己邮箱的密码

subject = '中文英文123Test';
content = subject;

TargetAddress = SourceAddress;

MatlabSendMailGeneral(subject, content, TargetAddress, [],SourceAddress,password);


%% Record Time
toc;
displayEndOfDemoMessage(mfilename);