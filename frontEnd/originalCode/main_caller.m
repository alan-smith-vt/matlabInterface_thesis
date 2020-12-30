%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the primary front end of the point cloud processing algorithm

% Python scripts will be called from here to run the main program
%   As of 9-16-2020, python scripts are a work in progress. They work on my
%   machine but have not been adaptive to generic machines yet.

% Interactive matlab programs are shown here to allow the user to explore
% the datasets and observe the effects of the various parameters

% Author: Alan Smith
% Date: 9-12-2020
% 
%% Generate RAW images for N slices along each axis
%Choose point cloud, save location, and raw image parameters
pc_url = "../pointClouds/BBTC_dec.pcd";
saveLoc = '../tennisResults_9-12-2020';
Nx = 1000; Ny = 1000; Nz = 1000;

%Tell python where to save everything via a temporary parameter file
createParamFile('saveLoc.py',sprintf('saveLoc = ''%s''',saveLoc));

%Create the parameter files for the x,y,z directions
createParamFile(sprintf('%s/x_parameters.py',saveLoc),'ax = 0',sprintf('N = %i',Nx),sprintf('pc_url = ''%s''',pc_url));
createParamFile(sprintf('%s/y_parameters.py',saveLoc),'ax = 1',sprintf('N = %i',Ny),sprintf('pc_url = ''%s''',pc_url));
createParamFile(sprintf('%s/z_parameters.py',saveLoc),'ax = 2',sprintf('N = %i',Nz),sprintf('pc_url = ''%s''',pc_url));

%Call the python scripts in new command windows to generate the raw imgs
% !python3 slice_caller.py x_parameters &
% !python3 slice_caller.py y_parameters &
% !python3 slice_caller.py z_parameters &
% input('\nPress enter when command windows are finished >');
fprintf('\n\n')


%% Choose a raw image stack to inspect

%Open a previous result (comment out all but 1 of these lines)
% imgDir =  sprintf('%s\\previousResults\\VTH\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\IBHS_G\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\IBHS_D\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\UNM_smallRebar\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\BBTC\\tempSlices\\',pwd);

%Open current results
cd ..
imgDir = sprintf('%s\\%s\\images\\raw\\',pwd,saveLoc(4:end));
cd frontEnd
%Launch the interactive histogram inspection program
% histogramInteractive(imgDir)

%Launch the ineractive filter program
filtersInteractive(imgDir)

%% Generate filtered images using chosen parameters
%Choose filter parameters for each axis
x_tLow = 0; x_tHigh = 255; x_M = 5; x_dilate_size = 7; x_erode_size = 5;
y_tLow = 0; y_tHigh = 255; y_M = 5; y_dilate_size = 7; y_erode_size = 5;
z_tLow = 0; z_tHigh = 255; z_M = 5; z_dilate_size = 7; z_erode_size = 5;

appendParamFile(sprintf('%s/x_parameters.py',saveLoc),sprintf('tLow = %i',x_tLow),sprintf('tHigh = %i',x_tHigh),...
    sprintf('M = %i',x_M),sprintf('dilate_size = %i',x_dilate_size),sprintf('erode_size = %i',x_dilate_size));
appendParamFile(sprintf('%s/y_parameters.py',saveLoc),sprintf('tLow = %i',y_tLow),sprintf('tHigh = %i',y_tHigh),...
    sprintf('M = %i',y_M),sprintf('dilate_size = %i',y_dilate_size),sprintf('erode_size = %i',y_dilate_size));
appendParamFile(sprintf('%s/z_parameters.py',saveLoc),sprintf('tLow = %i',z_tLow),sprintf('tHigh = %i',z_tHigh),...
    sprintf('M = %i',z_M),sprintf('dilate_size = %i',z_dilate_size),sprintf('erode_size = %i',z_dilate_size));

% !python3 filter_caller.py x_parameters &
% !python3 filter_caller.py y_parameters &
% !python3 filter_caller.py z_parameters &
% input('\nPress enter when command windows are finished >');
fprintf('\n\n')

%% Launch depth region labeler program -> assign a "z" range for each region

%Open current results
cd ..
imgDir = sprintf('%s\\%s\\images\\filtered\\',pwd,saveLoc(4:end));
cd frontEnd
kernelRegionCreation(imgDir);
%Psuedo-code
%Background will be filtered images
%Controls will be most similar to the histogram interactive program,
    %start from there and modify it
    
%Create region group
    %add to region group
    %assign depth subsections to region group
    %choose slice along depth to pick slice# to go back to to chose
        %preliminary kernel
    %repeat for each depth subsection
    %clean up kernels in external photo editing software
    
%Final parameterized results:
%x_parameter_file
    %region 1
    %region 2
%y_parameter_file
    %regionCluster 1 - (piecewise linear framing system)
        %region 1
            %x1,y1,x2,y2 bounding box
            %[d0, df] depth range
            %kernel url
        %region 2
            %x1,y1,x2,y2 bounding box
            %[d0, df] depth range
            %kernel url
        %region N

%Create convolution kernels and assign to each region

%Generate sparse centroidal cloud