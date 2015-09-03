# source for file merging

# the file list here should point to "fileGrab1" for this specific script
multipleCombine <- function(input, ply = llply){
  ply(input, function(x){
    t <- read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE) # read the csv
    t1 <- rbind(t) # rbind it to a temporary variable
    return(t1) # return the full variable
  }
  )
}