classdef fGetFutrues < handle
    %% fGetFutrues
    % by LiYang_faruto
    % Email:farutoliyang@foxmail.com
    % 2015/6/1
    %% properties
    properties
        
        
        
        isSave = 0;
        isPlot = 0;
        
        isTicToc = 0;
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
        %% fGetFutrues()
        function obj = fGetFutrues( varargin )
            
            
        end
        
        %% GetHotMonth()
        function OutputData = GetHotMonth(obj)
            OutputData = [];
            % %===输入参数检查 开始===
            Flag = ParaCheck(obj);
            if 0 == Flag
                str = ['请检查输入参数是否正确！'];
                disp(str)
                return;
            end
            
            % %===输入参数检查 完毕===
            
            
            URL = 'http://www.touchance.cn/hotmap.html';
            
            URLchar = urlread(URL,'Charset','GBK');
            URLString = java.lang.String(URLchar);
            
            expr = ['</table>@','(.*?)','</font></body></html>'];
            TimeUpdate = regexpi(URLchar, expr,'tokens');
            while iscell(TimeUpdate)
                TimeUpdate = TimeUpdate{1,1};
            end
            [~,TableCell] = GetTableFromWeb(URL,'GBK');
            
            HotTable = TableCell{1,1};
            tCell = cell(1,5);
            tCell{1,1} = ['更新时间：',TimeUpdate];
            OutputData = [tCell; HotTable];
            
            
            % % % Plot Demo
            if 1 == obj.isPlot && ~isempty(OutputData)
                
                scrsz = get(0,'ScreenSize');
                f = figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
                d = OutputData;
                t = uitable(f,'Data',d,'ColumnWidth',{200});
                t.Position(3) = t.Extent(3)+50;
                t.Position(4) = f.Position(4)-50;
                f.Position(3) = t.Extent(3)+100;
                
            end
            
            % % % Save
            if 1 == obj.isSave && ~isempty(OutputData)
                if obj.isTicToc == 1
                    tic;
                end
                
                tOutputData = OutputData;
                
                FolderStr = ['./DataBaseTemp/Futures'];
                if ~isdir( FolderStr )
                    mkdir( FolderStr );
                end
                

                FileName = ['期货品种主力合约列表'];

                FileString = [FolderStr,'/',FileName,'.xlsx'];
                FileExist = 0;
                if exist(FileString, 'file') == 2
                    FileExist = 1;
                end
                if 1 == FileExist
                    FileString = [FolderStr,'/',FileName,'(1)','.xlsx'];
                end
                
                tFileName = FileString;
                ColNamesCell = [];
                Data = tOutputData;
                [Status, Message] = SaveData2File(Data, tFileName, ColNamesCell);
                
                str = [FileName,'已保存至',FileString];
                disp(str);
                
                if obj.isTicToc == 1
                    str = ['数据保存完毕！共耗时：'];
                    disp(str);
                    toc;
                end
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
