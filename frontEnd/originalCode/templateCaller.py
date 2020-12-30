# -*- coding: utf-8 -*-
"""
Created on Wed Feb 12 09:34:49 2020

@author: Alan
"""

# -*- coding: utf-8 -*-
"""
Created on Tue Feb 11 17:30:04 2020

@author: Alan
"""

'''
This file will call the template generator with parameters
created by matlab and saved in the parameter file
'''

#Import all the things
import sys
sys.path.insert(1, '../backEnd')
import time
import open3d
import numpy as np
import bisect
from slicePointCloud import slicePointCloudf
from createTemplates import createTemplatesf
#from filterDupeRegions_v2 import filterRegions
#from findIntersections import findIntersectionsf
#from growLine_v2 import regionGrow

#from removeInnerPoints import removeInner
from debug import clockMsg
global begining
global start
begining = time.perf_counter()
start = time.perf_counter()
flag = True
numStar = 25
#Load the decimated and manually aligned point cloud
    #(Consider trying to load the whole thing via slicing it)
print("*"*numStar + "Opening Point Cloud" + "*"*numStar)
pcd_load = open3d.read_point_cloud(params.pc_url)
xyz_load = np.asarray(pcd_load.points)
rgb_load = np.asarray(pcd_load.colors)

#Zero the point cloud
start,begining = clockMsg("\t\t",start,begining,flag)
print("*"*numStar + "Zeroing Point Cloud" + "*"*numStar)
xyz_load = xyz_load - np.min(xyz_load, axis=0)

print("*"*numStar + "Calculating Bounds" + "*"*numStar)
x_range = max(xyz_load[:,0])-min(xyz_load[:,0])
y_range = max(xyz_load[:,1])-min(xyz_load[:,1])
z_range = max(xyz_load[:,2])-min(xyz_load[:,2])

R = [x_range, y_range, z_range]
np.save("backups/br.npy",R)

#Extract a few example filtered slices for template extraction
start,begining = clockMsg("\t\t",start,begining,flag)
print("*"*numStar + "Creating template slices" + "*"*numStar)

#Start with a = [250, 500, 750]
start,begining = createTemplatesf(start,begining,xyz_load,rgb_load,0,a=[250,500,750],tLow=60,tHigh=255,M=5,dilate=7,erode=5)
start,begining = createTemplatesf(start,begining,xyz_load,rgb_load,1,a=[350,450,550,650],tLow=1,tHigh=255,M=5,dilate=7,erode=5)
start,begining = createTemplatesf(start,begining,xyz_load,rgb_load,2,a=[300,350,375,425,450],tLow=1,tHigh=255,M=5,dilate=7,erode=5)
