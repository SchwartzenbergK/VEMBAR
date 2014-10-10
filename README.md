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
	+ The manual for the package can be found at
 http://cran.r-project.org/web/packages/animation/animation.pdf and 
 additional documentation can be found at http://cran.r-project.org/web/packages/animation/index.html

	+ A useful paper describing the functions available in the package can be found at
 http://www.jstatsoft.org/v53/i01/paper
 
 + The function saveVideo(), from the animation package, is called by vembar. This function 
 requires that the program FFmpeg be installed on the local computer. FFmpeg is free software for,
 among other things, the conversion of image files to video.
 
	+ It can be downloaded for windows at http://ffmpeg.zeranoe.com/builds/ . 
	+ Additional information can be found at http://www.ffmpeg.org/index.html
 
 ## Data Format
 This function is set up to process data saved in .csv format  with three columns. The first 
 column is the time (in seconds), the second column is the fit factor (FF), and the concentration
 of particles inside the mask (Inside.Mask)
 
 ## Function Arguments
 + filepath: this is the file path for the data file to be processed. 
 For example "C:/Users/Kevin/Documents/Data/datafile1.csv"
 + ffmdir: this is the path for the application ffmpeg.exe, which is used as an argument
 to the function saveVideo(), which coverts the series of bar plots into a video file. Once
 you have installed FFmpeg on your computer, it is recommended that you add an appropriate 
 default value to this argument in the function definition line. 
	+For example, the first line of the function currently reads:
	vembar <- function (filepath,ffmdir,outputdir=getwd()){
 
	+If ffmpeg.exe is located at C:/Program Files/FFmpeg/bin/ffmpeg.exe on your computer, you would 
 change the first line of the function to read:
vembar <- function (filepath,ffmdir="C:/Program Files/FFmpeg/bin/ffmpeg.exe",outputdir=getwd()){
this will prevent you from having to remember and enter the file path each time you call the function.

+	outputdir: this is the directory into which the video file and processed data file will be created.
 The default value is the current working directory.
 
 ## Function Output
+ The function generates a series of .png images, stored in the temporary folder for the R session,
 containing bar plots for each data point in the file.
+ A video file with the same name as the data file, but a .mp4 extension is generated in the 
directory specified by the outputdir argument
+ A .csv file containing the processed data is also generated in the directory specified by the
 outputdir argument. The .csv file contains 5 columns of data: 2 columns containing the time in
 minutes and seconds, a column containing a timestamp string in the form "MM:SS.S", and the FF
 and Inside Mask data from the original file. The file will be given the same name as the source
 data file but with the prefix "processed_" added at the beginning. So for example, if the 
 source data were contained in the file "datafile1.csv", the processed data would be stored as
 "processed_datafile1.csv"

 ## Notes
+ Since the function generates one .png file for each data point and then converts them to .mp4 
 format, the process takes a while: up to 1-2 minutes depending on the length of the data file, 
 CPU, and available RAM.
+ The function file is commented in much detail and is another good source of information about
 the function.

 