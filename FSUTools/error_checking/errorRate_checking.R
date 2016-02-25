# # munge plant div PDR data: L0 1m^2 data 
library(plyr)
library(dplyr)
library(stringr)
library(XLConnect)


# base path
basePath <- "Z:/2015data/errorRateTracking"
# list folders
dirList <- list.dirs(basePath, full.names = TRUE)

# function to return file path of all files from a root folder (i.e. multiple sub-folders)
fileParse <- function(directoryList){
  # need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
  fileList <- list() # initialize a list object to populate
  counter = 1
  for (folder in directoryList){
    filepaths <- list.files(folder, full.names = TRUE)
    fileList[[counter]] <- filepaths # double brackets to populate a list
    counter = counter + 1
  }
  return(unlist(fileList)) ## collapse the list elements...don't need to use ldply because we don't need multiple columns
}

# list of files
out <- fileParse(directoryList = dirList)

# function accepts a file list, reads the file, and returns a list of data frames -- works for .csv, .xls, and .xlsx
cond_merge <- function(fileList){ llply(fileList, function(x){
  file_type <- stringr::str_sub(x, -4, -1)
  print(file_type) # print the file type
  # if it's a csv:
  if (file_type == ".csv"){
    read.csv(x, header = T)
    # if it's an xls file
  } else if (file_type == "xlsx" | file_type == ".xls"){
    readWorksheet(loadWorkbook(x), sheet = 1, header = TRUE)}
})}

yo <- cond_merge(out)

sup <- ldply(yo)

sup2 <- sup[,c(1:12)]

# the sums are getting doubled for some reason
ddply(sup2, ~protocol+domainID, summarize,
      totalErrors = sum(numberOfCellsWithErrors)/2, 
      totalCells = sum(numberOfCellsChecked)/2)


