function kernelRegionCreation(imgDir)
    %The only input is a single "raw" image
%     img = imread("G:\PythonCode_Winter\newData_hangar\tempSlices\zRaw\z_slice_200.png");
%     img = imread(img_url);
    %Determine the size of the figure window based on image size and my 1440p monitor
%     imgDir = 'G:\PythonCode_Winter\newData_IBHS_D_cleanest\tempSlices\';
    sliceNum = 100;
    N = 1000;%Number of slices
    ax = 'x';
    imgInfo = struct('ax',ax,'sliceNum',sliceNum,'mode',0);%mode 0 = template, 1 = convolve, 2 = thresh, 3 = cluster, 4 = results
    save('imgInfo.mat','imgInfo');
    img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
    
    sz = size(img);
    if sz(2)/2 > sz(1)
        W = 0.8; H = 0.80*sz(1)/(sz(2)/2);
    else
        W = 0.8*(sz(2)/2)/sz(1); H=0.80;
    end
    sz_x = 2300;
    sz_y = 1150;
    
    %Leave some room at the bottom for our buttons
    f = figure('Position',[100,100,sz_x,sz_y]);
    
    ax_handel = axes('Parent',f,'position',[0.05 0.12  0.80 0.80]);
    ax_handel.Position = [0.05 0.12 W H];
    %Plot the image
    plotFilteredImg(0,ax_handel)
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
                    'String',sprintf('Slice Number = %i',imgInfo.sliceNum),'BackgroundColor',bgcolor);
    a.Callback = {@scrollButton,a3};
    
    
    
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
    
    
    %Define the template/convolution toggle
    bg2 = uibuttongroup('Visible','off','Position',[0.9 0.85 0.1 0.15],...
        'SelectionChangedFcn',@bselection_tc);
    bg2.UserData = struct('dir',imgDir,'num',sliceNum);
    bt = uicontrol(bg2);
    bt.Style = 'radiobutton';
    bt.String = "template";
    bt.Value = 1;
    bt.Position = [50,100,100,40];
    bt.HandleVisibility = 'off';
    
    bc = uicontrol(bg2);
    bc.Style = 'radiobutton';
    bc.String = "convolution";
    bc.Position = [50,50,100,40];
    bc.HandleVisibility = 'off';
    
    bg2.Visible = 'on';
    
    %Define a text box to display cluster/region data
%     c1 = uicontrol;
%     c1
    
    %Define the cluster initializer button
    c = uicontrol;
    c.String = 'Create New Cluster';
    c.Callback = @newCluster;
    c.UserData = struct('img',img);
    c.Position = [150+offset,20,200,40];

    %Define the region selector button
    d = uicontrol;
    d.String = 'Assign Region to Cluster';
    d.Callback = @newRegion;
    d.UserData = struct('regionList',[],'numRegions',0,'img',img);
    d.Position = [400+offset,20,200,40];

    %Define the depth assignment button
    e = uicontrol;
    e.String = 'Assign Depth to Region(s)';
    e.Callback = @assignDepth;
    e.Position = [650+offset,20,200,40];
    
    %Define the close button
    e = uicontrol;
    e.String = 'Finish';
    e.Callback = @closeButtonPushed;
    e.Tag = 'closeButton';
    e.Position = [900+offset,20,75,40];
    
    
    %Clear the contents of regionList both stored file and in button
    function newCluster(hObject,event)
        
    end
    
    function scrollButton(hObject,event, outHandle)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;

        imgInfo = struct('ax',imgInfo.ax,'sliceNum',round(hObject.Value),'mode',imgInfo.mode);
        outHandle.String = sprintf('Slice Number = %i',imgInfo.sliceNum);
        save('imgInfo.mat','imgInfo');
        plotFilteredImg(0,ax_handel)
    end

    function bselection_tc(hObject,event)
        cla;
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;

        img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
        
        sz = size(img);
        if sz(2)/2 > sz(1)
            W = 0.8; H = 0.80*sz(1)/(sz(2)/2);
        else
            W = 0.8*(sz(2)/2)/sz(1); H=0.80;
        end
        ax_handel.Position = [0.05 0.12 W H];
        
        if strcmp(event.NewValue.String,'template')
            imgInfo = struct('ax',imgInfo.ax,'sliceNum',imgInfo.sliceNum,'mode',0);
        end
        if strcmp(event.NewValue.String,'convolution')
            imgInfo = struct('ax',imgInfo.ax,'sliceNum',imgInfo.sliceNum,'mode',1);
        end
        save('imgInfo.mat','imgInfo');
        plotFilteredImg(0,ax_handel)
        

    end
    function bselection(hObject,event)
       cla;
       imgInfo = load('imgInfo.mat');
       imgInfo = imgInfo.imgInfo;
       
       imgInfo = struct('ax',event.NewValue.String,'sliceNum',imgInfo.sliceNum,'mode',imgInfo.mode);
       img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
       sz = size(img);
        if sz(2)/2 > sz(1)
            W = 0.8; H = 0.80*sz(1)/(sz(2)/2);
        else
            W = 0.8*(sz(2)/2)/sz(1); H=0.80;
        end
       ax_handel.Position = [0.05 0.12 W H];
       save('imgInfo.mat','imgInfo');
       plotFilteredImg(0,ax_handel)
%        axis equal
       
    end
    
    function closeButtonPushed(hObject,eventdata)
        close all;
    end

%     function newRegion(hObject,eventdata)
%         hold on
%         %Grab the image, regionList, and number of regions from the button's
%         %database
%         data = hObject.UserData;
%         imgInfo = load('imgInfo.mat');
%         imgInfo = imgInfo.imgInfo;
%         img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
%         
%         regionList = data.regionList;
%         numRegions = data.numRegions;
% 
%         %Invert image temporarily since crosshairs are black and unchangable
%         plotFilteredImg(1,ax_handel)
%         fprintf("Please select top left corner of region %d\n",numRegions+1)
%         coordinates_input = ginput(1);
%         row1 = round(coordinates_input(2));
%         column1 = round(coordinates_input(1));
% 
%         fprintf("Please select bottom right corner of region %d\n",numRegions+1)
%         coordinates_input = ginput(1);
%         row2 = round(coordinates_input(2));
%         column2 = round(coordinates_input(1));
%         region = [row1,column1,row2,column2];
% 
%         %Update the region list with the newly captured region
%         regionList = vertcat(regionList,region);
%         hObject.UserData = struct('regionList',regionList,'numRegions',numRegions + 1,'img',img);
%         
% 
%         %Replot the original image and new bounding boxes 
%         %(since inverted image overwrote everything)
%         plotFilteredImg(0,ax_handel)
%         rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
%         for k = 1:numRegions
%             region = regionList(k,:);
%             row1 = region(1);
%             column1 = region(2);
%             row2 = region(3);
%             column2 = region(4);
%             rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
%         end
%         %Save the regionList so we can pass it to the histogram button later
%         save('regionList.mat','regionList')
%     end
% 
%     function histogramButtonPushed(hObject,eventdata)
%         %Grab regionList from saved file
%         regionList = load('regionList.mat');
%         regionList = regionList.regionList;
%         allPts = [];
%         
%         hold on;
%         for k = 1:length(regionList(:,1))
%             region = regionList(k,:);
%             row1 = region(1);
%             column1 = region(2);
%             row2 = region(3);
%             column2 = region(4);
%             rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
%         end
%         
%         figure;%create new figure window
% 
%         %Grab image from userData of button
%         imgInfo = load('imgInfo.mat');
%         imgInfo = imgInfo.imgInfo;
%         img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
% 
%         
% 
%         %Set binLimits to 0.05 instead of 0 to avoid capturing the background
%         histogram(img,'BinLimits',[0.05,255]);
% 
%         %For each region, extract points within rectangle, 
%         %flatten to a vector (2D to 1D), and append to "allPts"
%         for k = 1:length(regionList(:,1))
%             region = regionList(k,:);
%             pts = img(region(1):region(3),region(2):region(4));
%             sz = size(pts);
%             allPts = vertcat(allPts,reshape(pts,sz(1)*sz(2),1));
%         end
% 
%         %Plot the things
%         hold on
%         histogram(allPts,'BinLimits',[0.05,255]);
%         legend('Overall Image','Selected Regions')
%         xlabel('Distribution of Intensity')
%         ylabel('Count')
%     end

    function plotFilteredImg(invFlag, ax)
        cla
        imgInfo = load('imgInfo.mat');
        imgInfo = imgInfo.imgInfo;
        img = imread([imgDir,imgInfo.ax,'Filt\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'_filt.png']);
        set(ax,'Color',[0.5,0.5,0.5])
        if imgInfo.mode == 0
            if invFlag == 1 %If we're currently requesting user coordinates...
                %Invert image temporarily since crosshairs are black and unchangable
                image(ax,uint8(255)-img);
            end
            if invFlag == 0 %Otherwise plot filtered image
                image(ax,img); 
            end
        end
        
        kernel = imread(['G:\PythonCode_Fall\tennisResults_9-12-2020\images\kernels\kernel_',num2str(3),'.png']);
        kernel = kernel*2-1;
        kernel_ax = axes('Parent',f,'position',[0.90 0.65  0.05 0.15]);
        image(kernel_ax,kernel);
        colormap gray
        axis equal
        set(kernel_ax,'Color',[0,0,0]);
        if imgInfo.mode == 1 %check if convolution is needed
            
            res = conv2(img,kernel);
            res = res*255/max(max(res));
            res(res < 100) = 0;
            image(ax,res);
            colormap hot
            caxis(ax,[100,255])
            
        end    
    end
end
