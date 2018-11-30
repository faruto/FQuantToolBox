function MatlabSendMailGeneral(subject, content, TargetAddress, Attachments,SourceAddress,password)
%% by LiYang_faruto
% Email:farutoliyang@foxmail.com
% 2015/05/01
%% 输入输出设置
if nargin < 6 || isempty(password)
    str = ['请输入发送邮件的邮箱密码'];
    disp(str);
    return;
end
if nargin < 5 || isempty(SourceAddress)
    str = ['请输入发送邮件的邮箱地址'];
    disp(str);
    return;
end
if nargin < 4
    Attachments = [];
end
if nargin < 3 || isempty(TargetAddress)
    TargetAddress = SourceAddress;
end
if nargin < 2 || isempty(content)
    content = 'contentTest(FromMatlab)';
end
if nargin < 1 || isempty(subject)
    subject = 'subjectTest(FromMatlab)';
end

%% SMTP_Server Get
ind = find( SourceAddress == '@', 1);
temp = SourceAddress(ind+1:end);

FieldName = temp;
SMTP_Server = ['smtp.',FieldName];

% ind = find( temp == '.', 1 );
% FieldName = temp(1:ind-1);
% if strcmpi(FieldName, 'foxmail')
%     FieldName = 'qq';
% end
% SMTP_Server = ['smtp.',FieldName,'.com'];

str = ['SMTP_Server=',SMTP_Server];
disp(str);
disp('即将发送邮件，若发送邮件不成功，请手动修改代码调整SMTP_Server');
%% 发送邮件
try
    setpref('Internet','SMTP_Server',SMTP_Server);%SMTP服务器，记住要改成自己邮箱的smtp（百度一下就行了）
    setpref('Internet','E_mail',SourceAddress);
    setpref('Internet','SMTP_Username',SourceAddress);
    setpref('Internet','SMTP_Password',password);
    
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    
    if isempty(Attachments)
        sendmail(TargetAddress, subject, content);
    else
        sendmail(TargetAddress, subject, content, Attachments);
    end
catch err
    str = ['发生异常'];
    disp(str);
    for i = 1:size(err.stack,1)
        StrTemp = ['FunName：',err.stack(i).name,' Line：',num2str(err.stack(i).line)];
        disp(StrTemp);
    end
    
%     str = ['SMTP_Server=',SMTP_Server];
%     disp(str);
%     disp('若发送邮件不成功，请手动修改代码调整SMTP_Server');
end

%%
disp('邮件发送完毕！');
DateTimedemo = datestr(now,'yyyy-mm-dd HH:MM:SS')
