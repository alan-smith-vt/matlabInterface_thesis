%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the primary front end of the point cloud processing algorithm
% Python scripts will be called from here to run the main program
% 
% Author: Alan Smith
% Date: 9-12-2020
% 
%% PsudoCode
function parameterWriter()
    pc_url = "../pointClouds/tennisBay.pcd";

    tLow = 1;
    tHigh = 255;
    M = 5;
    dilate = 7;
    erode = 5;

    a0 = [250,500,750];
    a1 = [350,450,550,650];
    a2 = [300,350,375,425,450];
end