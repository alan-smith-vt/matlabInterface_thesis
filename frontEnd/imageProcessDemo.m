function imageProcessDemo(imgDir)

    %Define the original image properties
    sliceNum = 500;
    N = 1000;%Number of slices
    ax = 'x';
    
    
    
    %Define the image info structure
    imgInfo = struct('ax',ax,'sliceNum',sliceNum);
    save('imgInfo.mat','imgInfo');
    
    %Define the options mode structure
    options = struct('mode','Input Image','kernelName',1,'thresh',100,'epsilon',25,'minPoints',10);
    save('options.mat','options');
    
    %Define the starting filter parameters
    M = 1;
    tLow = 0;
    tHigh = 255;
    dilate_size = 0;
    erode_size = 0;
    binFlag = 0;
    save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
    
    %Read the base image
    img = imread([imgDir,ax,'Raw\',ax,'_slice_',num2str(sliceNum),'.png']);
    sz = size(img);
    sz_x = 2250;
    sz_y = 800;
    
    %Leave some room at the bottom for our buttons
    f = figure('Position',[100,100,sz_x,sz_y+350]);
    kernel_ax = axes('Parent',f,'position',[0.825 0.70  0.15 0.27]);
    ax = axes('Parent',f,'position',[0.05 0.12  0.75 0.85]);%[xmin, ymin, xmax, ymax]
    realAxes = ax;
    plotKernel()
    %Plot the image
    image(img);
    colormap gray
    regionList = [];
    numRegions = 0;
    offset = (sz_x-(120+300+75+60+50+150))/2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Define the primary analysis options
    bg1 = uibuttongroup('Visible','off','Position',[0.825 0.4 0.15 0.2],...
        'SelectionChangedFcn',@optionSelection);
    bg1.UserData = struct('dir',imgDir,'num',sliceNum);
    
    bText = uicontrol(bg1);
    bText.Style = 'text';
    bText.Position = [10,135+20,200,40];
    bText.String = 'Main Window Display Mode';
    
    bImg = uicontrol(bg1);
    bImg.Style = 'radiobutton';
    bImg.String = "Input Image";
    bImg.Value = 1;
    bImg.Position = [10,135,200,40];%xmin, ymin, xdelta, ydelta
    bImg.HandleVisibility = 'off';
    
    
    bConv = uicontrol(bg1);
    bConv.Style = 'radiobutton';
    bConv.String = "Convolution Results";
    bConv.Position = [10,100,200,40];
    bConv.HandleVisibility = 'off';
    
    bCluster = uicontrol(bg1);
    bCluster.Style = 'radiobutton';
    bCluster.String = "Clustering Results";
    bCluster.Position = [10,65,200,40];
    bCluster.HandleVisibility = 'off';
    
    bCentroid = uicontrol(bg1);
    bCentroid.Style = 'radiobutton';
    bCentroid.String = "Final Centroids";
    bCentroid.Position = [10,30,200,40];
    bCentroid.HandleVisibility = 'off';
    
    bg1.Visible = 'on';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Create the kernel selection dropdown list
    listing = dir([imgDir(1:end-11),'templates\',imgInfo.ax,'_templates\']);
    dropString = {};
    for ii = 1:numel(listing)-2
        dropString{ii} = getfield(listing,{ii+2}).name;
    end
    bKernel = uicontrol;
    bKernel.Style = 'popupmenu';
    bKernel.Position = [2000,600,200,150];
    bKernel.String = dropString;
    bKernel.Callback = @bKernelCaller;
    
    
    

    %Define the sliceNumber scroll bar
    val = (120+300+75+60+50+150);
    
    %Define the x,y,z options
    bg = uibuttongroup('Visible','off','Position',[0 0 1 0.1],...
        'SelectionChangedFcn',@bselection);
    bg.UserData = struct('dir',imgDir,'num',sliceNum);
    bx = uicontrol(bg);
    bx.Style = 'radiobutton';
    bx.String = "x";
    bx.Value = 1;
    bx.Position = [-120+offset,75,30,40];%xmin, ymin, xdelta, ydelta
    bx.HandleVisibility = 'off';
    
    by = uicontrol(bg);
    by.Style = 'radiobutton';
    by.String = "y";
    by.Position = [-90+offset,75,30,40];
    by.HandleVisibility = 'off';
    
    bz = uicontrol(bg);
    bz.Style = 'radiobutton';
    bz.String = "z";
    bz.Position = [-60+offset,75,30,40];
    bz.HandleVisibility = 'off';
    
    bg.Visible = 'on';
    
    
    
    %Define scroll bar to select slice number
    bgcolor = f.Color;
    a = uicontrol('Parent',f,'Style','slider','Position',[offset,85,val,25],...
              'value',sliceNum, 'min',0, 'max',N-1);
    a1 = uicontrol('Parent',f,'Style','text','Position',[offset,85-25,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    a2 = uicontrol('Parent',f,'Style','text','Position',[offset+val-30,85-25,23,23],...
                    'String',N-1,'BackgroundColor',bgcolor);
    a3 = uicontrol('Parent',f,'Style','text','Position',[offset+val/2,55,100,23],...
                    'String',sprintf('Slice Number = %i',imgInfo.sliceNum),'BackgroundColor',bgcolor);
    a.Callback = {@scrollButton,a3};
    
    %Create the text input for slice number selection  
    aa = uicontrol;
    aa.Style = 'edit';
    aa.Position = [offset+val/2+115,60,50,20];
    aa.Callback = {@sliceChanged,a3};
    
    aa1 = uicontrol;
    aa1.Style = 'text';
    aa1.Position = [offset+val/2+165,60,100,20];
    aa1.String = '(Specific Slice)';
    
    
    
    
    %Define the region generator button
    c = uicontrol;
    c.String = 'Generate Region';
    c.Callback = @regionButtonPushed;
    c.Tag = 'regionGenerator';
    c.UserData = struct('regionList',[],'numRegions',0,'img',img);
    c.Position = [50,70,120,40];

    %Define the histogram generator button
    d = uicontrol;
    d.String = 'Generate Histogram of Intensity Distribution';
    d.Callback = @histogramButtonPushed;
    d.Tag = 'histogramGenerator';
    d.UserData = struct('img',img);
    d.Position = [50,20,250,40];

    %Define a clear regions button
    e = uicontrol;
    e.String = 'Clear Regions';
    e.Callback = @clearButtonPushed;
    e.Position = [200,70,100,40];
    
    %Define the close button
    e = uicontrol;
    e.String = 'Finish';
    e.Callback = @closeButtonPushed;
    e.Tag = 'closeButton';
    e.Position = [1250+offset,20,75,40];
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Define the filter options boxes
    offset = offset - 300;
    p = load('filterInfo.mat');
    %Create the M option
    g1 = uicontrol;
    g1.Style = 'text';
    g1.Position = [175+offset,10,50,20];
    g1.String = sprintf('M = %d',p.M);
        
    g = uicontrol;
    g.Style = 'edit';
    g.Position = [175+offset,35,50,20];
    g.Callback = {@Mchanged,g1};
    
    %Create the tLow option 
    h1 = uicontrol;
    h1.Style = 'text';
    h1.Position = [250+offset,10,75,20];
    h1.String = sprintf('tLow = %d',p.tLow);
        
    h = uicontrol;
    h.Style = 'edit';
    h.Position = [250+offset,35,75,20];
    h.Callback = {@tLowChanged,h1};
    
    %Create the tHigh option 
    j1 = uicontrol;
    j1.Style = 'text';
    j1.Position = [350+offset,10,75,20];
    j1.String = sprintf('tHigh = %d',p.tHigh);
        
    j = uicontrol;
    j.Style = 'edit';
    j.Position = [350+offset,35,75,20];
    j.Callback = {@tHighChanged,j1};
    
    %Create the binarize toggle
    k = uicontrol;
    k.Style = 'togglebutton';
    k.Position = [450+offset,20,75,20];
    k.String = 'Binarize';
    k.Callback = @binToggle;
    k.Value = p.binFlag;
    
    %Create the dilate size option 
    o1 = uicontrol;
    o1.Style = 'text';
    o1.Position = [550+offset,10,75,20];
    o1.String = sprintf('dilate size = %d',p.dilate_size);
        
    o = uicontrol;
    o.Style = 'edit';
    o.Position = [550+offset,35,75,20];
    o.Callback = {@dilateChanged,o1};
    
    %Create the erode size option 
    q1 = uicontrol;
    q1.Style = 'text';
    q1.Position = [650+offset,10,75,20];
    q1.String = sprintf('erode size = %d',p.erode_size);
    
    q = uicontrol;
    q.Style = 'edit';
    q.Position = [650+offset,35,75,20];
    q.Callback = {@erodeChanged,q1};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Create a preset filter options button
    r = uicontrol;
    r.String = 'Apply Preset';
    r.Callback = {@presetApplied};
    r.Position = [500,50,100,25];
    
    s = uicontrol;
    s.String = 'Reset Parameters';
    s.Callback = {@resetApplied};
    s.Position = [500,25,100,25];
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %Define scroll bar to select threshold
    val = (120+300+75+60+50+150)+350;
    bgcolor = f.Color;
    bThresh = uicontrol('Parent',f,'Style','slider','Position',[offset+val,85,200,25],...
              'value',options.thresh, 'min',0, 'max',255);
    bThresh1 = uicontrol('Parent',f,'Style','text','Position',[offset+val-5,60,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    bThresh2 = uicontrol('Parent',f,'Style','text','Position',[offset+val+180,60,23,23],...
                    'String','255','BackgroundColor',bgcolor);
    bThresh3 = uicontrol('Parent',f,'Style','text','Position',[offset+val+10,55,150,23],...
                    'String',sprintf('Threshold = %i',options.thresh),'BackgroundColor',bgcolor);
    bThresh.Callback = {@scrollButtonThresh,bThresh3};
    
    %Create the text input for slice number selection  
    bThresh4 = uicontrol;
    bThresh4.Style = 'edit';
    bThresh4.Position = [offset+val+215,85,50,20];
    bThresh4.Callback = {@threshChanged,bThresh3};
    
    bThresh5 = uicontrol;
    bThresh5.Style = 'text';
    bThresh5.Position = [offset+val+215+50,85,100,20];
    bThresh5.String = '(Specific Thresh)';
    
    %Create text input for clustering options
    bEpsilon1 = uicontrol;
    bEpsilon1.Style = 'text';
    bEpsilon1.Position = [offset+val,10,75,20];
    bEpsilon1.String = sprintf('Epsilon = %d',options.epsilon);
    
    bEpsilon = uicontrol;
    bEpsilon.Style = 'edit';
    bEpsilon.Position = [offset+val,35,75,20];
    bEpsilon.Callback = {@bEpsilonChanged,bEpsilon1};
    
    %Create text input for clustering options
    bMinPoints1 = uicontrol;
    bMinPoints1.Style = 'text';
    bMinPoints1.Position = [offset+val+100,10,75,20];
    bMinPoints1.String = sprintf('Min Points = %d',options.minPoints);
    
    bMinPoints = uicontrol;
    bMinPoints.Style = 'edit';
    bMinPoints.Position = [offset+val+100,35,75,20];
    bMinPoints.Callback = {@bMinPointsChanged,bMinPoints1};
    


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update clustering stuff
    function scrollButtonThresh(hObject,event, outHandle)
        cla;
        options = load('options.mat');
        options = options.options;
        options = struct('mode',options.mode,'kernelName',options.kernelName, ...
           'thresh',hObject.Value,'epsilon',options.epsilon,'minPoints',options.minPoints);
        save('options.mat','options');
        outHandle.String = sprintf('Threshold = %i',round(options.thresh));
        plotImg()
    end

    function threshChanged(hObject, event, outHandle)
        cla;
        newThresh = get(hObject, 'string');
        newThresh = str2double(newThresh);
        
        options = load('options.mat');
        options = options.options;
        options = struct('mode',options.mode,'kernelName',options.kernelName, ...
           'thresh',newThresh,'epsilon',options.epsilon,'minPoints',options.minPoints);

        save('options.mat','options');
        outHandle.String = sprintf('Threshold = %i',round(options.thresh));
        plotImg()
    end

    function bEpsilonChanged(hObject, event, outHandle)
        cla;
        options = load('options.mat');
        options = options.options;
        
        newEps = get(hObject, 'string');
        newEps = str2double(newEps);
        
        options = struct('mode',options.mode,'kernelName',options.kernelName, ...
           'thresh',options.thresh,'epsilon',newEps,'minPoints',options.minPoints);
        
        save('options.mat','options');
        plotImg()
        outHandle.String = sprintf('Epsilon = %d',options.epsilon);
    end

    function bMinPointsChanged(hObject, event, outHandle)
        cla;
        options = load('options.mat');
        options = options.options;
        
        newMP = get(hObject, 'string');
        newMP = str2double(newMP);
        
        options = struct('mode',options.mode,'kernelName',options.kernelName, ...
           'thresh',options.thresh,'epsilon',options.epsilon,'minPoints',newMP);
        
        save('options.mat','options');
        plotImg()
        outHandle.String = sprintf('Min Points = %d',options.minPoints);
    end



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
        plotImg()
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
        plotImg()
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
        plotImg()
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
        plotImg()
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
        plotImg()
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
        plotImg()
        outHandle.String = sprintf('erode size = %d',erode_size);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Update all the filter parameters to the presets
    function presetApplied(hObject, event)
        cla;
        %Define the starting filter parameters
        M = 5;
        tLow = 50;
        tHigh = 255;
        dilate_size = 7;
        erode_size = 5;
        binFlag = 1;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        g1.String = sprintf('M = %d',M); 
        h1.String = sprintf('tLow = %d',tLow);
        j1.String = sprintf('tHigh = %d',tHigh);
        k.Value = binFlag;
        o1.String = sprintf('dilate size = %d',dilate_size);
        q1.String = sprintf('erode size = %d',erode_size);
        plotImg()
    end

    function resetApplied(hObject,event)
        cla;
        %Define the starting filter parameters
        M = 1;
        tLow = 0;
        tHigh = 255;
        dilate_size = 0;
        erode_size = 0;
        binFlag = 0;
        save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
        g1.String = sprintf('M = %d',M); 
        h1.String = sprintf('tLow = %d',tLow);
        j1.String = sprintf('tHigh = %d',tHigh);
        k.Value = binFlag;
        o1.String = sprintf('dilate size = %d',dilate_size);
        q1.String = sprintf('erode size = %d',erode_size);
        plotImg()
    end
        

    %When slice number is entered manually, update everything accordingly
    function sliceChanged(hObject, event, outHandle)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        newSliceNum = get(hObject, 'string');
        newSliceNum = str2double(newSliceNum);
        imgInfo = struct('ax',imgInfo.ax,'sliceNum',round(newSliceNum));
        save('imgInfo.mat','imgInfo');
        outHandle.String = sprintf('Slice Number = %i',imgInfo.sliceNum);
        plotImg()
    end
    
    %Clear the contents of regionList both stored file and in button
    function clearButtonPushed(hObject,event)
        regionList = [];
        save('regionList.mat','regionList');
        h = findobj('Tag','regionGenerator');
        data = h.UserData;
%         display(data);
        h.UserData.regionList = [];
        h.UserData.numRegions = 0;
    end
    
    function scrollButton(hObject,event, outHandle)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;

        imgInfo = struct('ax',imgInfo.ax,'sliceNum',round(hObject.Value));
        save('imgInfo.mat','imgInfo');
        outHandle.String = sprintf('Slice Number = %i',imgInfo.sliceNum);
        plotImg()
    end

    function bselection(hObject,event)
       cla;
       imgInfo = load('imgInfo.mat');
       imgInfo = imgInfo.imgInfo;
       
       imgInfo = struct('ax',event.NewValue.String,'sliceNum',imgInfo.sliceNum);
       save('imgInfo.mat','imgInfo');
       plotImg()
       listing = dir([imgDir(1:end-11),'templates\',imgInfo.ax,'_templates\']);
        dropString = {};
        for ii = 1:numel(listing)-2
            dropString{ii} = getfield(listing,{ii+2}).name;
        end
        bKernel.String = dropString;
        plotKernel()
    end

    function bKernelCaller(hObject,event)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
       
        plotImg()
        options = load('options.mat');
        options = options.options;

        options = struct('mode',options.mode,'kernelName',hObject.Value, ...
           'thresh',options.thresh,'epsilon',options.epsilon,'minPoints',options.minPoints);
        save('options.mat','options');

        plotKernel()
    end
    
    function optionSelection(hObject,event)
       cla;
       options = load('options.mat');
       options = options.options;
       
       options = struct('mode',event.NewValue.String,'kernelName',options.kernelName, ...
           'thresh',options.thresh,'epsilon',options.epsilon,'minPoints',options.minPoints);
       save('options.mat','options');
       plotImg()
    end
   

    function closeButtonPushed(hObject,eventdata)
        close all;
    end

    function regionButtonPushed(hObject,eventdata)
        %Grab the image, regionList, and number of regions from the button's
        %database
        data = hObject.UserData;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);
        
        regionList = data.regionList;
        numRegions = data.numRegions;

        %Invert image temporarily since crosshairs are black and unchangable
        image(uint8(255)-img);
        fprintf("Please select top left corner of region %d\n",numRegions+1)
        coordinates_input = ginput(1);
        row1 = round(coordinates_input(2));
        column1 = round(coordinates_input(1));

        fprintf("Please select bottom right corner of region %d\n",numRegions+1)
        coordinates_input = ginput(1);
        row2 = round(coordinates_input(2));
        column2 = round(coordinates_input(1));
        region = [row1,column1,row2,column2];

        %Update the region list with the newly captured region
        regionList = vertcat(regionList,region);
        hObject.UserData = struct('regionList',regionList,'numRegions',numRegions + 1,'img',img);
        hold on

        %Replot the original image and new bounding boxes 
        %(since inverted image overwrote everything)
        image(img);
        rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
        for k = 1:numRegions
            region = regionList(k,:);
            row1 = region(1);
            column1 = region(2);
            row2 = region(3);
            column2 = region(4);
            rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
        end
        %Save the regionList so we can pass it to the histogram button later
        save('regionList.mat','regionList')
    end

    function histogramButtonPushed(hObject,eventdata)
        %Grab regionList from saved file
        regionList = load('regionList.mat');
        regionList = regionList.regionList;
        allPts = [];
        
        hold on;
        for k = 1:length(regionList(:,1))
            region = regionList(k,:);
            row1 = region(1);
            column1 = region(2);
            row2 = region(3);
            column2 = region(4);
            rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
        end
        
        figure;%create new figure window

        %Grab image from userData of button
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);

        

        %Set binLimits to 0.05 instead of 0 to avoid capturing the background
        histogram(img,'BinLimits',[0.05,255]);

        %For each region, extract points within rectangle, 
        %flatten to a vector (2D to 1D), and append to "allPts"
        for k = 1:length(regionList(:,1))
            region = regionList(k,:);
            pts = img(region(1):region(3),region(2):region(4));
            sz = size(pts);
            allPts = vertcat(allPts,reshape(pts,sz(1)*sz(2),1));
        end

        %Plot the things
        hold on
        histogram(allPts,'BinLimits',[0.05,255]);
        legend('Overall Image','Selected Regions')
        xlabel('Distribution of Intensity')
        ylabel('Count')
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function plotImg()
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        p = load('filterInfo.mat');
        options = load('options.mat');
        options = options.options;
        mode = options.mode;
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
        if strcmp(mode,'Input Image')
            image(img);
        else
            listing = dir([imgDir(1:end-11),'templates\',imgInfo.ax,'_templates\']);
            kernel = imread([getfield(listing,{3}).folder,'\',getfield(listing,{2+options.kernelName}).name]);
            kernel = double(im2bw(kernel,0));
            kernel = kernel*2-1;
            res = conv2(img,kernel);
            res = res*255/max(max(res));
            
            if strcmp(mode,'Convolution Results')
                image(res);
                colormap hot
                colorbar
            else
%                 thresh = 200;
                [X,Y,idx] = convolutionHelper(res,options.thresh,kernel,options.epsilon, options.minPoints);
                image(img);
                hold on
                if strcmp(mode,'Clustering Results')
                    gscatter(X(:,1),X(:,2),idx)
%                     scatter(X(:,1),X(:,2),20,'filled','m')
                    else
                        if strcmp(mode,'Final Centroids')
                            scatter(Y(:,1),Y(:,2),50,'r*')
                            sInput = size(kernel)*1.5;
                            for i = 1:length(Y(:,1))
                                rectangle('Position',[Y(i,1)-sInput(2)/2,Y(i,2)-sInput(1)/2,sInput(2),sInput(1)],'EdgeColor','y','LineWidth',2)
                            end
                        end
                end
            end
        end
    end
    function plotKernel()
        axes(kernel_ax)
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        p = load('filterInfo.mat');
        options = load('options.mat');
        options = options.options;
        mode = options.mode;
        
        listing = dir([imgDir(1:end-11),'templates\',imgInfo.ax,'_templates\']);
        kernel = imread([getfield(listing,{3}).folder,'\',getfield(listing,{2+options.kernelName}).name]);
        image(kernel_ax, kernel);
        colormap gray
        axis equal
        set(kernel_ax,'Color',[0,0,0]);
        axes(realAxes)
    end
end
