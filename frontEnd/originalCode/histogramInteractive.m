function histogramInteractive(imgDir)
    %The only input is a single "raw" image
%     img = imread("G:\PythonCode_Winter\newData_hangar\tempSlices\zRaw\z_slice_200.png");
%     img = imread(img_url);
    %Determine the size of the figure window based on image size and my 1440p monitor
%     imgDir = 'G:\PythonCode_Winter\newData_IBHS_D_cleanest\tempSlices\';
    sliceNum = 100;
    N = 1000;%Number of slices
    ax = 'x';
    imgInfo = struct('ax',ax,'sliceNum',sliceNum);
    save('imgInfo.mat','imgInfo');
    
    img = imread([imgDir,ax,'Raw\',ax,'_slice_',num2str(sliceNum),'.png']);
    sz = size(img);
    sz_x = 2250;
    sz_y = 800;
    
    %Leave some room at the bottom for our buttons
    f = figure('Position',[100,100,sz_x,sz_y+350]);
    ax = axes('Parent',f,'position',[0.05 0.12  0.90 0.85]);
    %Plot the image
    image(img);
%     axis equal
    colormap gray
    regionList = [];
    numRegions = 0;
    offset = (sz_x-(120+300+75+60+50+150))/2;
    
    %Define the sliceNumber scroll bar
    val = (120+300+75+60+50+150);
    
    
    
    
    
    %Define scroll bar to select slice number
    bgcolor = f.Color;
    a = uicontrol('Parent',f,'Style','slider','Position',[offset,85,val,25],...
              'value',sliceNum, 'min',0, 'max',N-1);
    a1 = uicontrol('Parent',f,'Style','text','Position',[offset-25,85,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    a2 = uicontrol('Parent',f,'Style','text','Position',[offset+val,85,23,23],...
                    'String',N-1,'BackgroundColor',bgcolor);
    a3 = uicontrol('Parent',f,'Style','text','Position',[offset+val/2,60,100,23],...
                    'String','Slice Number','BackgroundColor',bgcolor);
    a.Callback = @scrollButton;
    
    %Define the x,y,z options
    bg = uibuttongroup('Visible','off','Position',[0 0 1 0.05],...
        'SelectionChangedFcn',@bselection);
    bg.UserData = struct('dir',imgDir,'num',sliceNum);
    bx = uicontrol(bg);
    bx.Style = 'radiobutton';
    bx.String = "x";
    bx.Value = 1;
    bx.Position = [20+offset,20,30,40];
    bx.HandleVisibility = 'off';
    
    by = uicontrol(bg);
    by.Style = 'radiobutton';
    by.String = "y";
    by.Position = [50+offset,20,30,40];
    by.HandleVisibility = 'off';
    
    bz = uicontrol(bg);
    bz.Style = 'radiobutton';
    bz.String = "z";
    bz.Position = [80+offset,20,30,40];
    bz.HandleVisibility = 'off';
    
    bg.Visible = 'on';
    
    
    %Define the region generator button
    c = uicontrol;
    c.String = 'Generate Region';
    c.Callback = @regionButtonPushed;
    c.Tag = 'regionGenerator';
    c.UserData = struct('regionList',[],'numRegions',0,'img',img);
    c.Position = [150+offset,20,120,40];

    %Define the histogram generator button
    d = uicontrol;
    d.String = 'Generate Histogram of Intensity Distribution';
    d.Callback = @histogramButtonPushed;
    d.Tag = 'histogramGenerator';
    d.UserData = struct('img',img);
    d.Position = [350+offset,20,300,40];

    %Define a clear regions button
    e = uicontrol;
    e.String = 'Clear Regions';
    e.Callback = @clearButtonPushed;
    e.Position = [700+offset,20,100,40];
    
    %Define the close button
    e = uicontrol;
    e.String = 'Finish';
    e.Callback = @closeButtonPushed;
    e.Tag = 'closeButton';
    e.Position = [850+offset,20,75,40];
    
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
    
    function scrollButton(hObject,event)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;

        imgInfo = struct('ax',imgInfo.ax,'sliceNum',round(hObject.Value));
        save('imgInfo.mat','imgInfo');
        img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);
        image(img);
%         axis equal
    end

    function bselection(hObject,event)
       cla;
       imgInfo = load('imgInfo.mat');
       imgInfo = imgInfo.imgInfo;
       
       imgInfo = struct('ax',event.NewValue.String,'sliceNum',imgInfo.sliceNum);
       save('imgInfo.mat','imgInfo');
       img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);
       image(img);
%        axis equal
       
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
%         axis equal
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
end
