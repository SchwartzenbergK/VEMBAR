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
+	The function requires the installation of the animation package in R, which enables the 
conversion of multiple images (in this case, bar plots) to a video file.

 ++ The manual for the package can be found at
 http://cran.r-project.org/web/packages/animation/animation.pdf and 
 additional documentation can be found at http://cran.r-project.org/web/packages/animation/index.html

 ++ A useful paper describing the functions available in the package can be found at
 http://www.jstatsoft.org/v53/i01/paper
 
 +	The function saveVideo(), from the animation package, is called by vembar. This function 
 requires that the program FFmpeg be installed on the local computer. FFmpeg is free software for,
 among other things, the conversion of image files to video.
 
 ++ It can be downloaded for windows at http://ffmpeg.zeranoe.com/builds/ . 
 ++ Additional information can be found at http://www.ffmpeg.org/index.html
 
 ## Data Format
 This function is set up to process data saved in .csv format  with three columns. The first 
 column is the time (in seconds), the second column is the fit factor (FF), and the concentration
 of particles inside the mask (Inside.Mask)
 
 ## Function Arguments
 1.	filepath: this is the file path for the data file to be processed. 
 For example "C:/Users/Kevin/Documents/Data/datafile1.csv"
 
 2.	ffmdir: this is the path for the application ffmpeg.exe, which is used as an argument
 to the function saveVideo(), which coverts the series of bar plots into a video file. Once
 you have installed FFmpeg on your computer, it is recommended that you add an appropriate 
 default value to this argument in the function definition line. For example, the first 
 line of the function currently reads: vembar <- function (filepath,ffmdir,outputdir=getwd()){
 
 If ffmpeg.exe is located at C:/Program Files/FFmpeg/bin/ffmpeg.exe on your computer, you would 
 change the first line of the function to read:
vembar <- function (filepath,ffmdir="C:/Program Files/FFmpeg/bin/ffmpeg.exe",outputdir=getwd()){
this will prevent you from having to remember and enter the file path each time you call the function.

 3.	outputdir: this is the directory into which the video file and processed data file will be created.
 The default value is the current working directory.
 