%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demonstration of the 2D image analysis portion of the 
% master's thesis by Alan Smith

% An interactive matlab gui is called here to allow the user to explore
% the 5 supplied point cloud datasets and observe the effect of changing
% various image processing parameters and how it affects the resultant
% centroidal regions

% Author: Alan Smith
% Date: 12-1-2020


%% Choose a raw image stack to inspect
% %Open a previous result (comment out all but 1 of these lines)
cd ..
% imgDir =  sprintf('%s\\previousResults\\VTH\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\IBHS_G\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\IBHS_D\\tempSlices\\',pwd);
imgDir =  sprintf('%s\\previousResults\\UNM_smallRebar\\tempSlices\\',pwd);
% imgDir =  sprintf('%s\\previousResults\\BBTC\\tempSlices\\',pwd);
cd frontEnd

%Launch the interactive histogram inspection program (optional)
% histogramInteractive(imgDir)

close all
%Launch the ineractive filter program
imageProcessDemo(imgDir)
% filtersInteractive(imgDir)
% kernelRegionCreation(imgDir);
