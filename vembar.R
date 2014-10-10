

vembar <- function (filepath,ffmdir,outputdir=getwd()){
  #Developed by Kevin Schwartzenberg
  #Updated 2014/05/02
  
  #This function takes as input the file location of a .csv data file containing
  # three columns (time in seconds, FF, and Inside Mask), processes the data and
  #produces an mp4 video file showing a playback of the data in the form of bar
  #graphs. This can up to a minute or two to complete depending on the number of
  #data points in the file
  
  #In order for this function to work properly, you must have downloaded FFmpeg,
  #a free tool for creating video files from a series of picture files
  #ffmpeg for Windows can be downloaded at http://ffmpeg.zeranoe.com/builds/
  # more documentation is available at http://www.ffmpeg.org/index.html
  
  #ffmdir is the path of the file ffmpeg.exe, which executes the FFmpeg program
  #Once you download the program, I recommend that you change the function 
  #definition to include an appropriate default value for ffmdir so that you 
  #don't have to enter it each time. For example, for my computer I would change
  #the code in line 3 to read:
  #vembar<- function(filepath,
  #ffmdir="E:/FFmpeg/ffmpeg-20140429-git-21c7e99-win64-static/bin/ffmpeg.exe",
  #outputdir=getwd()){
  
  
  #outputdir is the directory into which you want the video file to be saved. 
  #The default value is the current working directory.
  
  #Load the animation package, which contains the functions necessary to turn a 
  #series of images into a video file. You will need to install this package 
  #before running the function for the first time.
  #If you are curious about the package see the documentation in R
  # and/or check out this paper: http://www.jstatsoft.org/v53/i01/paper
  library(animation)
  
  #Grabs the filename of the data file, removes the file extension and saves as 
  #a character variable so if your filepath was "C:/Users/Margaret/datafile.csv"
  # this would store "datafile" in the variable fileID. This will be useful 
  #later for naming the video file.
  fileID<- strsplit(tail(strsplit(filepath,split="/")[[1]],n=1),split="[.]")[[1]][1]
  

  #Using the fileID, create the filename for the video. Using our example above,
  #this would store "datafile.mp4" in the variable vidfile
  vidfile<- paste(fileID,".mp4",sep="")
  
  
  # Load the datafile containing the relevant data.
  data <- read.csv(file=filepath, header=TRUE)
  
  #The sample data you gave me contained some strange things in the Inside Mask 
  #column. If the value was greater than 1000, it was stored as "1,056" (i.e. as
  # a character string with commas separating the thousands place). Because of 
  #that, R wanted to treat the column as a factor variable. This bit of code 
  #gets around that, although NA's will still be produced if there are values 
  #with quotes and commas in the data files you use. If this becomes a problem
  #let me know and we can work out a more automated way of dealing with it.
  data$Inside.Mask <- as.numeric(as.character(data$Inside.Mask))
  
  #Create a new data frame for the processed data with the minutes and seconds,
  #a timestamp string, and the original data
  dataout<-data.frame("minutes"=floor(data[,1]/60),"seconds"=data[,1]%%60,
                      "timestamp"=NA,"FF"=data$FF,"Inside.Mask"=data$Inside.Mask)
  
  #This for loop is used to translate the minutes and seconds into a character string
  #of the for MM:SS.S. This will later be used to display the time that corresponds with the
  #FF and Inside Mask values displayed in the graphs
  for (j in 1:nrow(dataout)){
    if (dataout$seconds[j] < 10){
      dataout$timestamp[j]<- paste(dataout$minutes[j],":0",round(dataout$seconds[j],2),sep="")
    }
    else {
      dataout$timestamp[j]<- paste(dataout$minutes[j],":",round(dataout$seconds[j],1),sep="")
    }
    
  }
  
  #write the new data frame to a csv file with the same file name as the original
  #but "processed_" added at the beginning.
  write.csv(dataout,file=paste(outputdir,"/processed_",fileID,".csv",sep=""),
            row.names=FALSE)
  
  #Determine the scale maximums for each variable. Based on the histogram of the 
  #sample data I was given, it looks like the values are mostly very low with a 
  # few extreme values. I tried to choose axis maximums that would show most of
  #the data points clearly on the bar plot, but you can experiment if you like 
  #by changing the probability for the quantile function.After some 
  #experimentation I chose .7 for Inside Mask(i.e. the value for which 70% of the 
  # data points are lower) and .9 for the FF.
  
  FFmax<- quantile(dataout$FF,na.rm=TRUE,probs=.9)
  IMmax<- quantile(dataout$Inside.Mask,na.rm=TRUE,probs=.7)
  
  #determine the number of rows in your data set. This will be used to determine
  #how many bar plots need to be produced as "frames" of your video file
  n<- nrow(dataout)
  
  #Now save the data as a video showing barplots of the FF. The saveVideo 
  #function takes the series of images produced inside the for loop and turns 
  #them into a mp4 video file using a third party open source software called 
  #FFmpeg. Any of the commands with "ani." in them relate to the animation package.
  saveVideo({
    oopt <- ani.options(interval=1, nmax = n, ffmpeg=ffmdir, outdir=outputdir)
    
    #This for loop creates an image for each data point
    for (i in 1:n) {
      #Set the plot area to be a row of 5 plot windows, magnify the font size to
      # 1.5x normal
      par(mfrow=c(1,5),cex=1.25)
      
      #In the first plot window, put a bargraph showing the Inside.Mask value for
      #that point, if the value is over the max, just show the max
      if (dataout[i,5]> IMmax){
              im <- IMmax
      }
      else{
              im <- dataout[i,5]
      }
      barplot(im,col="red",ylim=c(0,IMmax),xlab="Inside",space=0)
      
      #print the actual value, rounded to 2 decimal places as the title of that 
      #bar plot
      title(main=paste(round(dataout[i,5],2),"\np/cm^3"),col.main="red",adj=0)
      
      #a blank plot in the second window for spacing reasons
      plot(1, ann = FALSE, type = "n", axes = FALSE)
      
      #a blank plot in the third window, to which we add a title which is the 
      #timestamp for the data point
      plot(1, ann = FALSE, type = "n", axes = FALSE)
      title(paste("Time\n",dataout[i,3]),col.main="blue")
      
      #another blank plot for spacing reasons
      plot(1, ann = FALSE, type = "n", axes = FALSE)
      
      #a bar graph in the fifth window showing the FF value for that data point
      # if the value is over the max, just show the max
      if (dataout[i,4]> FFmax){
              ff <- FFmax
      }
      else{
              ff <- dataout[i,4]
      }
      barplot(ff,col="darkgreen",ylim=c(0,FFmax),xlab="FF",space=0)
      
      #again, print the actual value as the title for the bar graph
      title(main=round(dataout[i,4],2),col.main="darkgreen",adj=1)
      ani.pause()
    }
    ani.options(oopt)
    #Now a series of options for the saveVideo function
  }, img.name=fileID, outdir=outputdir, ani.width=750, ani.height=750, 
  video.name=vidfile, ffmpeg=ffmdir, other.opts=("-r 5"))
  
}