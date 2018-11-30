function [output,status] = urlreadwrite_General(fcn,catchErrors,varargin)
%URLREADWRITE A helper function for URLREAD and URLWRITE.

%   Matthew J. Simoneau, June 2005
% 	Sharath Prabhal,     September 2012
%   Copyright 1984-2012 The MathWorks, Inc.

% This function requires Java.
error(javachk('jvm',fcn))
import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

% Be sure the proxy settings are set.
com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

% Parse inputs.
inputs = parseInputs(fcn,varargin);
urlChar = inputs.url;

% Set default outputs.
output = '';
status = 0;

% GET method.  Tack param/value to end of URL.
for i = 1:2:numel(inputs.get)
    if (i == 1), separator = '?'; else separator = '&'; end
    param = char(java.net.URLEncoder.encode(inputs.get{i}));
    value = char(java.net.URLEncoder.encode(inputs.get{i+1}));
    urlChar = [urlChar separator param '=' value];
end

% Create a urlConnection.
[urlConnection,errorid] = getUrlConnection(urlChar,inputs.timeout,...
    inputs.useragent,inputs.authentication, inputs.username, inputs.password);
if isempty(urlConnection)
    if catchErrors, return
    else error(mm(fcn,errorid));
    end
end

% POST method.  Write param/values to server.
if ~isempty(inputs.post)
    try
        urlConnection.setDoOutput(true);
        urlConnection.setRequestProperty( ...
            'Content-Type','application/x-www-form-urlencoded');
        printStream = java.io.PrintStream(urlConnection.getOutputStream);
        for i=1:2:length(inputs.post)
            if (i > 1), printStream.print('&'); end
            param = char(java.net.URLEncoder.encode(inputs.post{i}));
            value = char(java.net.URLEncoder.encode(inputs.post{i+1}));
            printStream.print([param '=' value]);
        end
        printStream.close;
    catch
        if catchErrors, return
        else error(mm(fcn,'PostFailed'));
        end
    end
end

% Get the outputStream.
switch fcn
    case 'urlread_General'
        outputStream = java.io.ByteArrayOutputStream;
    case 'urlwrite_General'
        [file,outputStream] = getFileOutputStream(inputs.filename);
end

% Read the data from the connection.
try
    inputStream = urlConnection.getInputStream;
    % This StreamCopier is unsupported and may change at any time.
    isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
    isc.copyStream(inputStream,outputStream);
    inputStream.close;
    outputStream.close;
catch e
    outputStream.close;
    if strcmp(fcn,'urlwrite_General')
        delete(file);
    end
    if catchErrors
        return
    elseif strfind(e.message,'java.net.SocketTimeoutException:')
        error(mm(fcn,'Timeout'));
    elseif strfind(e.message,'java.net.UnknownHostException:')
        host = regexp(e.message,'java.net.UnknownHostException: ([^\n\r]*)','tokens','once');
        error(mm(fcn,'UnknownHost',host{1}));
    elseif strfind(e.message,'java.io.FileNotFoundException:')
        error(mm(fcn,'FileNotFound'));
    elseif strfind(e.message,'java.net.Authenticator.requestPasswordAuthentication')
        error(mm(fcn,'BasicAuthenticationFailed'));    
    else
        error(mm(fcn,'ConnectionFailed'));
    end
end

if isempty(inputs.charset)
    contentType = char(urlConnection.getContentType);
    charsetMatch = regexp(contentType,'charset=([A-Za-z0-9\-\.:_])*','tokens','once');
    if isempty(charsetMatch)
        if strncmp(urlChar,'file:',4)
            charset = char(java.lang.System.getProperty('file.encoding'));
        else
            charset = 'UTF-8';
        end
    else
        charset = charsetMatch{1};
    end
else
    charset = inputs.charset;
end

switch fcn
    case 'urlread_General'
        output = native2unicode(typecast(outputStream.toByteArray','uint8'),charset);
    case 'urlwrite_General'
        output = char(file.getAbsolutePath);
end
status = 1;

function m = mm(fcn,id,varargin)
m = message(['MATLAB:' fcn ':' id],varargin{:});

function results = parseInputs(fcn,args)
p = inputParser;
p.addRequired('url',@(x)validateattributes(x,{'char'},{'nonempty'}))
if strcmp(fcn,'urlwrite_General')
    p.addRequired('filename',@(x)validateattributes(x,{'char'},{'nonempty'}))
end
p.addParamValue('get',{},@(x)checkpv(fcn,x))
p.addParamValue('post',{},@(x)checkpv(fcn,x))
p.addParamValue('timeout',[],@isnumeric)
p.addParamValue('useragent',[],@ischar)
p.addParamValue('charset',[],@ischar)
p.addParamValue('authentication', [], @ischar)
p.addParamValue('username', [], @ischar)
p.addParamValue('password', [], @ischar)
p.FunctionName = fcn;
p.parse(args{:})
results = p.Results;

function checkpv(fcn,params)
if mod(length(params),2) == 1
    error(mm(fcn,'InvalidInput'));
end

function [urlConnection,errorid] = getUrlConnection(urlChar,timeout,...
    userAgent,authentication,userName,password)
	
import org.apache.commons.codec.binary.Base64;	
% Default output arguments.
urlConnection = [];
errorid = '';

% Determine the protocol (before the ":").
protocol = urlChar(1:find(urlChar==':',1)-1);

% Try to use the native handler, not the ice.* classes.
switch protocol
    case 'http'
        try
            handler = sun.net.www.protocol.http.Handler;
        catch exception %#ok
            handler = [];
        end
    case 'https'
        try
            handler = sun.net.www.protocol.https.Handler;
        catch exception %#ok
            handler = [];
        end
    otherwise
        handler = [];
end

% Create the URL object.
try
    if isempty(handler)
        url = java.net.URL(urlChar);
    else
        url = java.net.URL([],urlChar,handler);
    end
catch exception %#ok
    errorid = 'InvalidUrl';
    return
end

% Get the proxy information using the MATLAB proxy API.
proxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url); 

% Open a connection to the URL.
if isempty(proxy)
    urlConnection = url.openConnection;
else
    urlConnection = url.openConnection(proxy);
end

% Set MATLAB as the User Agent
if isempty(userAgent)
    userAgent = ['MATLAB R' version('-release') ' '  version('-description')];
end
urlConnection.setRequestProperty('User-Agent', userAgent);

% If username and password exists, perform basic authentication
if strcmpi(authentication,'Basic')
    usernamePassword = [userName ':' password];
    usernamePasswordBytes = int8(usernamePassword)';
    usernamePasswordBase64 = char(Base64.encodeBase64(usernamePasswordBytes)');
    urlConnection.setRequestProperty('Authorization', ['Basic ' usernamePasswordBase64]);
end

% Set the timeout.
if (nargin > 2 && ~isempty(timeout))
    % Handle any numeric datatype and convert.
    milliseconds = int32(double(timeout)*1000);
    % Java inteprets 0 as no timeout. This would be confusing if we rounded
    % to 0 from something else, e.g. "'timeout',.0001".
    if milliseconds == 0
        milliseconds = int32(1);
    end
    urlConnection.setConnectTimeout(milliseconds);
    urlConnection.setReadTimeout(milliseconds);
end

function [file,fileOutputStream] = getFileOutputStream(location)
% Specify the full path to the file so that getAbsolutePath will work when the
% current directory is not the startup directory and urlwrite is given a
% relative path.
file = java.io.File(location);
if ~file.isAbsolute
   location = fullfile(pwd,location);
   file = java.io.File(location);
end

try
    % Make sure the path isn't nonsense.
    file = file.getCanonicalFile;
    % Open the output file.
    fileOutputStream = java.io.FileOutputStream(file);
catch
    error(mm('urlwrite_General','InvalidOutputLocation',char(file.getAbsolutePath)));
end
