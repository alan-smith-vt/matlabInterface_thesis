function filtersInteractive(imgDir)

    %Define the initial image properties
    sliceNum = 150;
    N = 1000;%Max number of slices
    ax = 'x';
    
    %Define the image info structure
    imgInfo = struct('ax',ax,'sliceNum',sliceNum);
    save('imgInfo.mat','imgInfo');

    %Define the starting filter parameters
    M = 5;
    tLow = 0;
    tHigh = 255;
    dilate_size = 0;
    erode_size = 0;
    binFlag = 0;
    save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
    
    %Read the base image
    img = imread([imgDir,ax,'Raw\',ax,'_slice_',num2str(sliceNum),'.png']);
    sz = size(img);
    sz_x = 1800;
    sz_y = 600;
    
    %Leave some room at the bottom for our buttons
    f = figure('Position',[100,100,sz_x,sz_y+350]);
    ax = axes('Parent',f,'position',[0.05 0.12  0.90 0.85]);
    %Plot the image
    plotFilteredImg(imgDir)
    colormap gray

    offset = (sz_x-(120+300+75+60+50+150))/2;
    val = (120+300+75+60+50+150);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Define the filter options boxes
    
    p = load('filterInfo.mat');
    %Create the M option
    g1 = uicontrol;
    g1.Style = 'text';
    g1.Position = [175+offset,30,50,20];
    g1.String = sprintf('M = %d',p.M);
        
    g = uicontrol;
    g.Style = 'edit';
    g.Position = [175+offset,5,50,20];
    g.Callback = {@Mchanged,g1};
    
    %Create the tLow option 
    h1 = uicontrol;
    h1.Style = 'text';
    h1.Position = [250+offset,30,75,20];
    h1.String = sprintf('tLow = %d',p.tLow);
        
    h = uicontrol;
    h.Style = 'edit';
    h.Position = [250+offset,5,75,20];
    h.Callback = {@tLowChanged,h1};
    
    %Create the tHigh option 
    j1 = uicontrol;
    j1.Style = 'text';
    j1.Position = [350+offset,30,75,20];
    j1.String = sprintf('tHigh = %d',p.tHigh);
        
    j = uicontrol;
    j.Style = 'edit';
    j.Position = [350+offset,5,75,20];
    j.Callback = {@tHighChanged,j1};
    
    %Create the binarize toggle
    k = uicontrol;
    k.Style = 'togglebutton';
    k.Position = [450+offset,5,75,20];
    k.String = 'Binarize';
    k.Callback = @binToggle;
    k.Value = p.binFlag;
    
    %Create the dilate size option 
    o1 = uicontrol;
    o1.Style = 'text';
    o1.Position = [550+offset,30,75,20];
    o1.String = sprintf('dilate size = %d',p.dilate_size);
        
    o = uicontrol;
    o.Style = 'edit';
    o.Position = [550+offset,5,75,20];
    o.Callback = {@dilateChanged,o1};
    
    %Create the erode size option 
    q1 = uicontrol;
    q1.Style = 'text';
    q1.Position = [650+offset,30,75,20];
    q1.String = sprintf('erode size = %d',p.erode_size);
        
    q = uicontrol;
    q.Style = 'edit';
    q.Position = [650+offset,5,75,20];
    q.Callback = {@erodeChanged,q1};
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Define scroll bar to select slice number
    bgcolor = f.Color;
    a = uicontrol('Parent',f,'Style','slider','Position',[offset,85,val,25],...
              'value',sliceNum, 'min',0, 'max',N-1);
    a1 = uicontrol('Parent',f,'Style','text','Position',[offset-25,85,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    a2 = uicontrol('Parent',f,'Style','text','Position',[offset+val,85,23,23],...
                    'String',N-1,'BackgroundColor',bgcolor);
    a3 = uicontrol('Parent',f,'Style','text','Position',[offset+val/2,60,100,23],...
                    'String',sprintf('Slice Number = %i',imgInfo.sliceNum),'BackgroundColor',bgcolor);
    a.Callback = {@scrollButton,a3};
    
    %Define the x,y,z options
    bg = uibuttongroup('Visible','off','Position',[0 0 0.2 0.05],...
        'SelectionChangedFcn',@bselection);
    bg.UserData = struct('dir',imgDir,'num',sliceNum);
    bx = uicontrol(bg);
    bx.Style = 'radiobutton';
    bx.String = "x";
    bx.Value = 1;
    bx.Position = [20+100,10,30,40];
    bx.HandleVisibility = 'off';
    
    by = uicontrol(bg);
    by.Style = 'radiobutton';
    by.String = "y";
    by.Position = [50+100,10,30,40];
    by.HandleVisibility = 'off';
    
    bz = uicontrol(bg);
    bz.Style = 'radiobutton';
    bz.String = "z";
    bz.Position = [80+100,10,30,40];
    bz.HandleVisibility = 'off';
    
    bg.Visible = 'on';
    

    
    %Define the close button
    e = uicontrol;
    e.String = 'Finish';
    e.Callback = @closeButtonPushed;
    e.Tag = 'closeButton';
    e.Position = [850+offset,20,75,40];
    
    
    function Mchanged(hObject, event, outHandle)
        p = load('filterInfo.mat');
        M = get(hObject, 'string');
        M = str2double(M);
        
        tLow = p.tLow;
        tHigh = p.tHigh;
        dilate_size = p.dilate_size;
        erode_size = p.erode_size;
        binFlag = p.binFlag;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
        outHandle.String = sprintf('M = %d',M);
    end

    function tLowChanged(hObject, event, outHandle)
        p = load('filterInfo.mat');
        tLow = get(hObject, 'string');
        tLow = str2double(tLow);
        
        M = p.M;
        tHigh = p.tHigh;
        dilate_size = p.dilate_size;
        erode_size = p.erode_size;
        binFlag = p.binFlag;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
        outHandle.String = sprintf('tLow = %d',tLow);
    end

    function tHighChanged(hObject, event, outHandle)
        p = load('filterInfo.mat');
        tHigh = get(hObject, 'string');
        tHigh = str2double(tHigh);
        
        M = p.M;
        tLow = p.tLow;
        dilate_size = p.dilate_size;
        erode_size = p.erode_size;
        binFlag = p.binFlag;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
        outHandle.String = sprintf('tHigh = %d',tHigh);
    end

    function binToggle(hObject, event)
        p = load('filterInfo.mat');
        M = p.M;
        tLow = p.tLow;
        tHigh = p.tLow;
        dilate_size = p.dilate_size;
        erode_size = p.erode_size;
        binFlag = get(hObject,'Value');
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
    end

    function dilateChanged(hObject, event, outHandle)
        p = load('filterInfo.mat');
        dilate_size = get(hObject, 'string');
        dilate_size = str2double(dilate_size);
        
        M = p.M;
        tLow = p.tLow;
        tHigh = p.tHigh;
        erode_size = p.erode_size;
        binFlag = p.binFlag;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
        outHandle.String = sprintf('dilate size = %d',dilate_size);
    end
    
    function erodeChanged(hObject, event, outHandle)
        p = load('filterInfo.mat');
        erode_size = get(hObject, 'string');
        erode_size = str2double(erode_size);
        
        M = p.M;
        tLow = p.tLow;
        tHigh = p.tHigh;
        dilate_size = p.dilate_size;
        binFlag = p.binFlag;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        plotFilteredImg(imgDir)
        outHandle.String = sprintf('erode size = %d',erode_size);
    end

    function scrollButton(hObject,event, outHandle)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;

        imgInfo = struct('ax',imgInfo.ax,'sliceNum',round(hObject.Value));
        outHandle.String = sprintf('Slice Number = %i',imgInfo.sliceNum);
        save('imgInfo.mat','imgInfo');
        plotFilteredImg(imgDir)
    end

    function bselection(hObject,event)
       cla;
       imgInfo = load('imgInfo.mat');
       imgInfo = imgInfo.imgInfo;
       
       imgInfo = struct('ax',event.NewValue.String,'sliceNum',imgInfo.sliceNum);
       save('imgInfo.mat','imgInfo');
       plotFilteredImg(imgDir)
    end
    
    function closeButtonPushed(hObject,eventdata)
        close all;
    end

    function plotFilteredImg(imgDir)
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        p = load('filterInfo.mat');
        img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);
        sz = size(img);
        imgMat = zeros(sz(1),sz(2),p.M);
        imgMat = uint8(imgMat);
        start = imgInfo.sliceNum-floor(p.M/2);
        for i=1:p.M
            img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(start+i),'.png']);
            img(img < p.tLow) = 0;%threshold
            img(img > p.tHigh) = 0;%threshold
            imgMat(:,:,i) = img;
        end

        img = mean(imgMat,3);
        if p.binFlag == 1
            img(img > 0) = 255;%Binarize
        end
        %Morphology operators
        if p.dilate_size > 0
            dilate_kernel = strel('square',p.dilate_size);
            img = imdilate(img,dilate_kernel);
        end
        if p.erode_size > 0
            erode_kernel = strel('square',p.erode_size);
            img = imerode(img,erode_kernel);
        end
        image(img);
    end
end
