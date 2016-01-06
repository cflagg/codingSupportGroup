# the file list here should point to "fileGrab1" for this specific script
multipleCombine <- function(input, ply = llply){
  ply(input, function(x){
    # read the file in
    t <- read.csv(x, header=FALSE, sep=",",stringsAsFactors = FALSE) # read the csv
    # evaluate whether it has the correct header; if TRUE read the file in again WITH header; if FALSE run colnames()
    t1 <- if(colnames(t) %in% c("siteID")){
      colnames(t)
      t[-1,]
    }else{
      colnames(t) <- c("siteID", "b","sup")
      t[-1,]
    }
    t2 <- rbind(t1) # rbind it to a temporary variable
    return(t2) # return the full variable
  }
  )
}

# read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE)

multipleCombine("C:/Users/cflagg/Documents/csv_test1.csv", ldply)
