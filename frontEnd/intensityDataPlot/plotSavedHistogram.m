
%Load a previously saved set of regions for plotting fancy
% regionList = load('regionList_VTH_Z.mat');
% imgInfo = load('imgInfo_VTH_Z.mat');

regionList = load('regionList_IBHSG_Z.mat');
imgInfo = load('imgInfo_IBHSG_Z.mat');


cd ..\..
% imgDir =  sprintf('%s\\previousResults\\VTH\\tempSlices\\',pwd);
imgDir =  sprintf('%s\\previousResults\\IBHS_G\\tempSlices\\',pwd);
cd frontEnd\intensityDataPlot


regionList = regionList.regionList;
allPts = [];


for k = 1:length(regionList(:,1))
    region = regionList(k,:);
    row1 = region(1);
    column1 = region(2);
    row2 = region(3);
    column2 = region(4);
%     rectangle('Position',[column1,row1,column2-column1,row2-row1],'EdgeColor',[1,1,1]);
end

hold on;
%Grab image from userData of button
imgInfo = imgInfo.imgInfo;
img = imread([imgDir,imgInfo.ax,'Raw\',imgInfo.ax,'_slice_',num2str(imgInfo.sliceNum),'.png']);



%Set binLimits to 0.05 instead of 0 to avoid capturing the background
histogram(img,'BinLimits',[0.05,255],'FaceColor',[0.5,0.5,0.5],'BinWidth',1,'EdgeColor',[0.5,0.5,0.5]);


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
histogram(allPts,'BinLimits',[0.05,255],'FaceColor','k','BinWidth',1,'FaceAlpha',1);
legend('Overall Image','Structural Points','Fontsize',26,'fontweight','bold')
xlabel('Intensity (I)','fontweight','bold','Fontsize',26)
ylabel('Count','fontweight','bold','Fontsize',26)
set(gcf,'color','w');
% ylim([0,125])
% set(gca, 'YScale', 'log')