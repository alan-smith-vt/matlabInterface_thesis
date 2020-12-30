
imgDir = 'G:\PythonCode_Winter\newData_hangar_cleaner\tempSlices\';
sliceNum = 200;
N = 1000;%Number of slices
ax = 'z';
imgInfo = struct('ax',ax,'sliceNum',sliceNum);
save('imgInfo.mat','imgInfo');

img = imread([imgDir,ax,'Raw\',ax,'_slice_',num2str(sliceNum),'.png']);
sz = size(img);
sz_x = 2250;
sz_y = 800;

%Leave some room at the bottom for our buttons
f = figure('Position',[100,100,sz_x,sz_y+350]);
ax1 = axes('Parent',f,'position',[0.05 0.12  0.90 0.85]);
%Plot the image
image(img);
axis equal
colormap gray


M = 5;
tLow = 150;
tHigh = 200;
dilate_size = 7;
erode_size = 5;
binFlag = 1;
save('filterInfo.mat','M','tLow','tHigh','dilate_size','erode_size','binFlag')
plotFilteredImg(imgDir)


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
    img(img > 0) = 255;%Binarize
    %Morphology operators
    dilate_kernel = strel('square',p.dilate_size);
    img = imdilate(img,dilate_kernel);
    erode_kernel = strel('square',p.erode_size);
    img = imerode(img,erode_kernel);
    image(img);
end






