# source for file merging

# the file list here should point to "fileGrab1" for this specific script
multiCombine <- function(input, ply = llply){
  ply(input, function(x){
    t <- read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE) # read the csv
    t1 <- rbind(t) # rbind it to a temporary variable
    return(t1) # return the full variable
  }
  )
}

# function for combining multiple Excel workbooks with a single worksheet
multiCombine_xls <- function(fileList, ...){
  ldply(fileList, function(x){
   t <- loadWorkbook(x)
   t2 <- readWorksheet(t, sheet = 1, ...)
   # append the names from the worksheet to the data.frame
   names(t2) <- readWorksheet(t, sheet = 1, ...)
   t3 <- rbind(data.frame(t2))
  }
)
}

# function for combining multiple worksheets in a single .xls file