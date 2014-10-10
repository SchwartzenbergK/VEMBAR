VEMBAR
======

## Description
This function was developed to mimic the output of VEM BARS version 1.3, an application developed 
by OSHA and written in Visual Basic for the analysis of video exposure monitoring data. 
The purpose of the function is to convert a data file containing time series concentration 
data from respirator fit testing and convert it to a video file containing a visual playback 
of the data in the form of bar graphs. This video can later be synced with actual video of the 
fit test so that specific fit factor data can be correlated to actions performed by the subjects 
of the fit test.

## R Package and Software Dependencies
*•	The function requires the installation of the animation package in R, which enables the 
conversion of multiple images (in this case, bar plots) to a video file.