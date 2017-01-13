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
  # directoryList == list.dirs(file_path)
  # outputType == vector OR list
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