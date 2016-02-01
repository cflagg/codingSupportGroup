############################################# Script Summary #############################################
## This script will parse through every folder and sub-folder of the drop-box, open each .csv or .xlsx file, and count the number o rows.
## I wrote it to get a better idea of how many records there are per protocol to better inform the Time Estimates in the Manual Data Transcription protocol. 
## Author: Cody Flagg
############################################# Script Summary #############################################

# Pseudo-code
# create list of folders and files
# loop through each folder and each file (nested loop: folder path > file)
# open file, count the number of rows
# save the count in a list
# turn list into data frame

library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)


############################################# VARIABLE INPUTS #############################################
# These variables are passed onto functions below
# last year's dropbox data
# directory <- "N:/Science/FSU/DataL0fromFOPs/fieldData2014"
directory <- "Z:/2015data" # current dropbox data

# # protocol strings of interest -- what to parse the file output for, after it has been collated
prot_str <- c("tck", "cdw", "dhp", "ltr", "mos", "vst", "sls", "soi", "Pla", "div") # for 2015 -- soils data have a few prefixes
# prot_str <- c("phe")
############################################# VARIABLE INPUTS #############################################

# only lists the folders in the root
folderList <- list.files(directory, full.names = TRUE)

# lists all folders in a directory, including sub-folders ## VARIABLE INPUT ## 
dirList <- list.dirs(directory)

# fileParse <- function(){
# need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
fullFileList <- list() # initialize a list object to populate
counter = 0
for (folder in dirList){
  # browser() # this is the interactive debugger, its scope is global & local
  # list all files in a particular folder
  folder_content <- list.files(folder)
  for (fileN in folder_content){
    # iterate the file count for tracking and for indexing the list
    counter = counter + 1
    # EXCEPTION HANDLING -- PASS ON GRASS -- this will keep the loop going even if there is an error
    # Added b/c there are .xls and .xlsx files
    try({
      # grab the file type
      fileType <- str_sub(string = fileN, start = -4, end = -1)
      print(paste(counter, fileType))
      # pass the full file path
      filePath <- paste(folder,"/",fileN, sep="")
      if (fileType == ".csv"){
        # add the number of rows 
        fullFileList[counter][1] <-read.csv(filePath) # this is just storing the row count, rather than the file contents
        # add the protocol type
        fullFileList[[counter]][2] <- str_sub(fileN, 1,3)
        # add file name for tracking purposes 
        fullFileList[[counter]][3] <- fileN
      }else if (fileType == "xlsx"){
        t <- loadWorkbook(filePath)
        file_x <- readWorksheet(t, sheet = 1, header = TRUE)
        fullFileList[counter][1] <-file_x # this is just storing the row count, rather than the file contents
        # add the protocol type
        fullFileList[[counter]][2] <- str_sub(fileN, 1,3)
        # add file name for tracking
        fullFileList[[counter]][3] <- fileN
      }
    })
  }
}
#}

