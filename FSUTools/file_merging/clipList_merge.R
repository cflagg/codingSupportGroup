library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)
library(gtools)

directory <- "N:/Common/TOS/clipID_soil_Lists_2015"
dirList <- list.dirs(directory)

# fileParse <- function(){
# need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
fileListOut <- list() 
counter = 0

for (folder in dirList){
  folder_content <- list.files(folder)
  folder_content <- folder_content[grep(pattern = "clipList|cliplist", x = folder_content)]
  for (fileN in folder_content){
    counter = counter + 1
    try({
      fileType <- str_sub(string = fileN, start = -4, end = -1)
      print(paste(counter, fileType))
      filePath <- paste(folder,"/",fileN, sep="")
      if (fileType == ".csv"){
        fileListOut[[counter]] <- read.csv(filePath, header = TRUE)
      }
      # USE if there are xlsx files
#       else if (fileType == "xlsx"){
#         t <- loadWorkbook(filePath)
#         file_x <- readWorksheet(t, sheet = 1, header = TRUE)
#         fileListOut[counter][1] <- file_x
# #         fileListOut[[counter]][2] <- str_sub(fileN, 1,3)
# #         fileListOut[[counter]][3] <- fileN
#       }
    })
  }
}
# }

# dump the empties
fileListOut <- Filter(length,fileListOut)


fileListOut_merge <- ldply(fileListOut, smartbind)


