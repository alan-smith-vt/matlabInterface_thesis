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
Assume this will be the main caller function which will
start with a point cloud .pcd file and go all the way
to exportting the .txt files to load the model into autoCAD

We will need at the very least user specified convolution templates

We may also need user specified region growing parameters

'''
#Import all the things
import sys
sys.path.insert(1, '../backEnd')
args = sys.argv
import time
import importlib

if len(args) <= 1:
    print('Please provide parameter file name/location\n.')
    time.sleep(2)
    exit()

import saveLoc
sys.path.insert(1, saveLoc.saveLoc)
p = importlib.import_module(args[1])

import open3d
import numpy as np
import bisect
from filterImages import filterImagesf

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
pcd_load = open3d.read_point_cloud(p.pc_url)
xyz_load = np.asarray(pcd_load.points)
rgb_load = np.asarray(pcd_load.colors)

#Zero the point cloud
start,begining = clockMsg("\t\t",start,begining,flag)
print("*"*numStar + "Zeroing Point Cloud" + "*"*numStar)
xyz_load = xyz_load - np.min(xyz_load, axis=0)


R = np.load(saveLoc.saveLoc + "/backups/br.npy",allow_pickle=True)

#Slice the point cloud


start,begining = clockMsg("\t\t",start,begining,flag)

print("*"*numStar + "Slicing and Processesing " + str(args[1][0]) + "*"*numStar)
start,begining = filterImagesf(start,begining,xyz_load,rgb_load,p.ax,p.N,p.tLow,p.tHigh,p.M,p.dilate_size,p.erode_size)
start,begining = clockMsg("\t\t",start,begining,flag)
