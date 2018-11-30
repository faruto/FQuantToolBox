function [f,status] = urlwrite_General(url,filename,varargin)
%URLWRITE Save the contents of a URL to a file.
%   URLWRITE(URL,FILENAME) saves the contents of a URL to a file.  FILENAME
%   can specify the complete path to a file.  If it is just the name, it will
%   be created in the current directory.
%
%   F = URLWRITE(...) returns the path to the file.
%
%   F = URLWRITE(...,METHOD,PARAMS) passes information to the server as
%   part of the request.  The 'method' can be 'get', or 'post' and PARAMS is a
%   cell array of param/value pairs.
%
%   URLWRITE(...,'Timeout',T) sets a timeout, in seconds, when the function
%   will error rather than continue to wait for the server to respond or send
%   data.
%
%   [F,STATUS] = URLWRITE(...) catches any errors and returns the error code. 
%
%   Examples:
%   urlwrite('http://www.mathworks.com/',[tempname '.html'])
%   urlwrite('ftp://ftp.mathworks.com/README','readme.txt')
%   urlwrite(['file:///' fullfile(prefdir,'history.m')],'myhistory.m')
% 
%   From behind a firewall, use the Preferences to set your proxy server.
%
%   See also URLREAD.

%   Matthew J. Simoneau, 13-Nov-2001
%   Copyright 1984-2011 The MathWorks, Inc.

% Do we want to throw errors or catch them?
if nargout == 2
    catchErrors = true;
else
    catchErrors = false;
end

[f,status] = urlreadwrite_General(mfilename,catchErrors,url,filename,varargin{:});
