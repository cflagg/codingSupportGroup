# source for file merging
library(XLConnect)
library(plyr)


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

## An example workbook file -- use as input
# f <- ("C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/multi_worksheet_ex.xlsx")

# create a function to pull all of the worksheets together into a single data frame
multiWorksheetCombine_xls <- function(input){
  # loading excel workbook
  #output <- data.frame()
  #browser()
  # create an empty object to fill
  output <- NULL
  t <- loadWorkbook(input)
  # variable to pass sheet names
  sheets_list <- getSheets(t)
  # iterate through every sheet, load workbook 't' and worksheet 's'
  for (sh in unique(sheets_list)){
    w <- readWorksheet(t, sheet = sh, header = TRUE)
    # fix herbaceous clip column names
    # add the date
    # print(head(t2))
    # append the names from the worksheet to the data.frame
    output <- rbind.fill(w, output)
  }
  return(output)
}



