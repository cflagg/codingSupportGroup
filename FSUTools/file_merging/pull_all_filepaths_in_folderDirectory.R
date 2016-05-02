############################################# Script Summary #############################################
## This script will parse through every folder and sub-folder of the drop-box (or specified root directory) 
## and store the full file path inside a list object. The list is collapsed into a vector and can be used 
## to grep on specific file name patterns. 
############################################# Script Summary #############################################

# Pseudo-code
# create list of folders and files
# loop through each folder and each file (nested loop: folder path > file)
# open file, count the number of rows
# save the count in a list
# turn list into data frame

#library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)

############################################# VARIABLE INPUTS #############################################
# These variables are passed onto functions below
# last year's dropbox data
# directory <- "N:/Science/FSU/DataL0fromFOPs/fieldData2014"
directory <- "Z:/" # current dropbox data - 2014, 2015, 2016


# only lists the folders in the root
folderList <- list.files(directory, full.names = TRUE)

# lists all folders in a directory, including sub-folders ## VARIABLE INPUT ## 
dirList <- list.dirs(directory)

# a re-usable function
fileParser <- function(directoryList, outputType = "vector"){
  # need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
  fullFilenameList <- list() # initialize a list object to populate
  counter = 0
  for (folder in directoryList){
    # browser() # this is the interactive debugger, its scope is global & local
    # list all files in a particular folder
    folder_content <- list.files(folder, full.names = TRUE)
    for (fileN in folder_content){
      # iterate the file count for tracking and for indexing the list
      counter = counter + 1
      fullFilenameList[[counter]] <- fileN
      print(fileN)
    }
  }
    # return a list
    return(fullFilenameList)
  }
}

# execute function
flatList <- fileParser(dirList, output = "vector")

# grep VST files
flatList2 <- grep(pattern = "VST|vst", x = flatList, value = TRUE)

# grep VST mapping and tagging only
flatList3 <- grep(pattern = "mapping", x = flatList2, value = TRUE)

# grep .csv 
flatList4 <- grep(pattern = ".csv", x = flatList3, value = TRUE)

# stack the CSVs
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

# save the stack
fileStack <- multipleCombine(flatList4, ply = ldply)

# TEST -- are the sites in this set?
prototype_sites <- c("SERC", "GRSM")
prototype_sites %in% unique(fileStack$siteID)

# filter to prototype
## NEED TO ADD VEG CHARACTERIZATION DATA
prototype_sites <- dplyr::filter(fileStack, siteID %in% c("SERC", "GRSM"))

# summary of data
str(prototype_sites)

# summarize by plotID
ddply(prototype_sites, ~siteID+plotID, summarize, totalTags = length(tagID))


# check SERC_046
serc046 <- filter(prototype_sites, plotID == "SERC_046")

length(unique(serc046$tagID))

duplicated(serc046)

View(serc046)
