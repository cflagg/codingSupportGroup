# cflagg (3/9/2015)
# Load library
library(plyr)

########################################## 1) Set working directory ##########################################
# Set working directory and file path ... relative path will work if Git folders are in "Documents"
setwd("../Documents/GitHub/organismalIPT/spatialData") 
# alternative method: file.path(getwd(),directory2)
# store the working directory as a variable, so you don't have to type it all out
pathToFiles <- getwd()

# Create directory to hold new output from script - if needed
#dir.create(file.path(pathToFiles, "QA_Files"),showWarnings = FALSE)

########################################## 2) Setup File Grabbing ##########################################
#set this to the prefix for the sheets in your module; make specific to file name batch 
myPrefix <- 'plotSpatialData_'
mySuffix <- '.csv'

# load and inspect files from working directory
fileList <- list.files(pathToFiles, full.names=TRUE) # list all the files, full.names=TRUE is necessary for ldplay/lapply to work below
# solution from: http://stackoverflow.com/questions/13441204/using-lapply-and-read-csv-on-multiple-files-in-r
fileGrab1 <- fileList[grep(myPrefix,fileList)] # subset to just the ones in your module, using prefix, if needed
# fileGrab2 <- fileGrab1[grep(mySuffix,fileGrab1)] # subset again, if needed, with another suffix


########################################## 3) Combine files in the dir ##########################################
# this is "Solution 2" from another reference script I have "ingestFileMerging_plotData.Rmd"; the other solutions use looping

# this is a function with two inputs - the file list and the type of plyr operation
# the file list here should point to "fileGrab1" for this specific script
multipleCombine <- function(input, ply = llply){
  ply(input, function(x){
    t <- read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE) # read the csv
    t1 <- rbind(t) # rbind it to a temporary variable
    return(t1) # return the full variable
}
)
}

# example use - combine the list of files (hence "l") into a dataframe (hence "d")
combined.df = multipleCombine(fileGrab1, ply = ldply)

########################################## 4) Split a data frame into multiple files ##########################################
# This example takes the combined file above and splits it into separate files for each unique domainID
fileSuffix = as.character("newFileSuffix")
d_ply(combined.df,.(domainID), function(input) 
  write.csv(input, file = paste0("D", unique(input$domainID),"_",fileSuffix, ".csv", sep="")))



