############################################# Script Summary #############################################
## This script will parse through every folder and sub-folder of the drop-box (or specified root directory) 
## and store the full file path inside a list object. The list is collapsed into a vector and can be used 
## to grep on specific file name patterns. 


##### CUSTOM FUNCTIONS #####
## functioned used below
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

# a re-usable function - outputType can be 'vector' or 'list'
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
  # what kind of output should be returned?
  ifelse(outputType == "vector", 
         # return a vector
         return(unlist(fullFilenameList)),
         # return a list
         return(fullFilenameList))
}
##

##### Pseudo-code #####
# create list of folders and files
# loop through each folder and each file (nested loop: folder path > file)
# pull full file path
# store all file paths
# turn list into vector

##### LIBRARY IMPORTS ##### 
#library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)

############################################# VARIABLE INPUTS #############################################
# These variables are passed onto functions below
# last year's dropbox data
# directory <- "N:/Science/FSU/DataL0fromFOPs/fieldData2014"
directory <- "Z:/" # current dropbox data - 2014, 2015, 2016
###########################################################################################################

##### MAP FILES IN DROP BOX ######
# only lists the folders in the root
folderList <- list.files(directory, full.names = TRUE)

# lists all folders in a directory, including sub-folders ## VARIABLE INPUT ## 
dirList <- list.dirs(directory)


##### MERGE TOGETHER MAPPING FILES ######
# execute function
allFilesList <- fileParser(dirList, outputType = "vector")

# grep VST files 
vstList2 <- grep(pattern = "VST|vst", x = allFilesList, value = TRUE)

# grep VST mapping and tagging only
mappingList3 <- grep(pattern = "mapping", x = vstList2, value = TRUE)

# grep .csv 
mappingList4 <- grep(pattern = ".csv", x = mappingList3, value = TRUE)

# save the stack
mappingStack <- multipleCombine(mappingList4, ply = ldply)


##### PUT TOGETHER APPARENT INDIVIDUAL FILES ######
## grep vstList2 for app ind
indivList3 <- grep(pattern = "apparent", x = vstList2, value = TRUE)

## grep CSVs to be safe
indivList4 <- grep(pattern = ".csv", x = indivList3, value = TRUE)

# save the stack
indivStack <- multipleCombine(indivList4, ply = ldply)


##### DATA CHECK FOR FOLIAR BGC PROTOTYPE #####

## check data types of primary key fields (date, plotID, tagID)
# check dates
class(indivStack$date)
class(mappingStack$date)
class(indivStack$plotID)
class(mappingStack$plotID)
class(indivStack$tagID)
class(mappingStack$tagID)


## TEST -- are the sites in this set?
prototype_sites <- c("SERC", "GRSM")
prototype_sites %in% unique(mappingStack$siteID)

# filter to prototype
prototype_sites <- dplyr::filter(mappingStack, siteID %in% c("SERC", "GRSM"))

# summary of data
str(prototype_sites)

# summarize by plotID
ddply(prototype_sites, ~siteID+plotID, summarize, totalTags = length(tagID))

# check SERC_046 -- it has a lot of tags
serc046 <- filter(prototype_sites, plotID == "SERC_046")

length(unique(serc046$tagID))

## are there any pure dupes in the serc_046 plot?
duplicated(serc046)

# View(serc046)

##### MERGE MAPPING AND APPARENT INDIVIDUALS BY DATE, TAGID, PLOTID #####
# convert indivStack$date to character to match mappingStack
indivStack$date <- as.character(indivStack$date)

## using apparent individuals as the left table ("columnName.x"); 
merged_data <- left_join(x = indivStack, y = mappingStack, by = c("date", "plotID", "tagID"))

## now filter down to the target plotIDs
