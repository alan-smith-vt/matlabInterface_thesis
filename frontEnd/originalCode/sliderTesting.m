
    GUI.a = 1;
    GUI.fh = figure;
    GUI.h1 = uicontrol('style','Edit',...
                       'string','1',...
                       'Units','normalized',...
                       'Position',[0.1 0.8 0.8 0.2],...
                       'backgroundcolor','w',...
                       'Tag','EditField');
    GUI.h2 = uicontrol('style','Edit',...
                       'string','XX',...
                       'Units','normalized',...
                       'Position',[0.1 0.1 0.8 0.2],...
                       'backgroundcolor','c',...
                       'Tag','EditField2',...
                       'Enable','off');
    GUI.h3 = uicontrol('Style','PushButton',...
                       'String','Disp a2',...
                       'Units','normalized',...
                       'Position',[0.1 0.4 0.8 0.15],...
                       'callback',{@func_compute,GUI.h1,GUI.h2},...
                       'backgroundcolor',...
                       'r','FontSize',12);

 function func_compute(~,~,InHandle,OutHandle)
   a = str2double(InHandle.String);
   b = a * a;
   OutHandle.String = num2str(b);
 end