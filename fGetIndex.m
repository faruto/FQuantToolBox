classdef fGetIndex < handle
    %% fGetIndex
    % 获取指数相关数据
    % 获取指数成分股
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        isSave = 1;
        Code = '000300';
        
    end
    %% properties(SetAccess = private, GetAccess = public)
    properties(SetAccess = private, GetAccess = public)
        
        
    end
    
    %% properties(Access = protected)
    properties(Access = protected)
        
    end
    
    %% properties(Access = private)
    properties(Access = private)
        
    end
    
    %% methods
    
    methods
        %% fGetIndex()
        function obj = fGetIndex( varargin )
            
            
        end
        
        %% Fun()
        function [OutputData,dStr] = GetCons(obj,varargin )
            OutputData = [];
            dStr = [];
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
    
            % 399704深证上游 399705深证中游 399706深证下游
            % 399701深证F60 399702深证F120 399703深证F200
            SpecialList = {'399704';'399705';'399706';'399701';'399702';'399703';};
            
            CustomList = {};
            
            FolderStr = ['./IndexCons'];
            if ~isdir( FolderStr )
                mkdir( FolderStr );
            end
            
            FileName = [obj.Code,'成分股'];
            FileString = [FolderStr,'/',FileName,'.xls'];
            FileExist = 0;
            if exist(FileString, 'file') == 2
                FileExist = 1;
            end
            if 1 == FileExist
                FileString = [FolderStr,'/',FileName,'(1)','.xls'];
            end
            
            if obj.Code(1) == '3' && ~ismember(obj.Code,SpecialList)
                % http://www.cnindex.com.cn/docs/yb_399005.xls
                URL = ['http://www.cnindex.com.cn/docs/yb_',obj.Code,'.xls'];
                
                try
                    outfilename = websave(FileString,URL);
                catch
                    str = ['数据获取失败，请检查输入的指数代码！',obj.Code];
                    disp(str);
                    return;
                end
                
                [num,txt,raw] = xlsread(outfilename);
                
                dStr = raw{1,8};
                
                OutputData = raw(:,3:6);
                OutputData(1,:) = {'Code','Name','Weight','Industry'};                
                
            else
                
                URL = ['http://www.csindex.com.cn/sseportal/ps/zhs/hqjt/csi/',obj.Code,'cons.xls'];
                
                try
                    outfilename = websave(FileString,URL);
                catch
                    str = ['数据获取失败，请检查输入的指数代码！',obj.Code];
                    disp(str);
                    return;
                end
                
                [status,sheets] = xlsfinfo(outfilename);
                dStr = ['更新时间：',sheets{1,1}];
                
                [num,txt,raw] = xlsread(outfilename);
                
                OutputData = raw;
                OutputData(1,:) = {'Code','Name','Name(Eng)','Exchange'};
                
            end
            
            
            if obj.isSave == 0
            
                delete(FileString);
                
            else
                
                str = [obj.Code,'指数成分股数据已保存至',FileString];
                disp(str);
                
            end
            
        end
        
        
        %% 输入参数检查函数
        function Flag = ParaCheck(obj, varargin )
            Flag = 1;
            
            % %===输入参数检查 开始===
            
%             checkflag = ismember( lower(obj.DownUpSampling),lower(obj.DownUpSampling_ParaList) );
%             if checkflag ~= 1
%                 str = ['DownUpSampling参数输入错误请检查！可选的参数列表为（大小写都行）：'];
%                 disp(str);
%                 ParaList = obj.DownUpSampling_ParaList
%                 Flag = 0;
%                 return;
%             end
            
             % %===输入参数检查 完毕===
        end    
        
        
        
        
        
    end
    
end
