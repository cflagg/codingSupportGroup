# create list of folders and files
# loop through each folder and each file
# count the number of rows in each file
# save the count

library(XLConnect)
library(stringr)
library(plyr)

folderList <- list.files("Z:/2015data", full.names = TRUE)

dirList <- list.dirs("Z:/2015data")

# if the directory structure was more flat, with only .csv files
rowList <- list()
for (folder in folderList){
  folder_content <- list.files(folder)
  # print(folder_content)
  for (file in folder_content){
    print(nrow(read.csv(paste(folder,"/", file, sep=""))))
    rowList[file] <- nrow(read.csv(paste(folder,"/", file, sep="")))
  }
}

# munging the list into a data frame
sto <- plyr::ldply(rowList)
colnames(sto) <- c("file", "rows")
# take the first 3 letters of the string, which is the protocol abbreviation
sto$module <- str_sub(sto[,1], 1,3)

# how the data would be summarized
ddply(sto, ~module, summarize, meanRows = mean(rows))

# need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
rowList <- list()
counter = 0
for (folder in dirList){
  folder_content <- list.files(folder)
  # print the file types
  # print(str_sub(string = folder_content, start = -4, end = -1))
  # if the file types 
#   fileType <- str_sub(string = folder_content, start = -4, end = -1)
#   print(paste(counter,fileType, sep = "||"))
  for (file in folder_content){
    counter = counter + 1
    # EXCEPTION HANDLING -- PASS ON GRASS IF IT DONT WORK MAN
    try({
    fileType <- str_sub(string = file, start = -4, end = -1)
    print(paste(counter, fileType))
    filePath <- paste(folder,"/",file, sep="")
      if (fileType == ".csv"){
        # add the number of rows
        rowList[counter][1] <-nrow(read.csv(filePath))
        # add the protocol type
        rowList[[counter]][2] <- str_sub(file[,1], 1,3)
      }else if (fileType == "xlsx"){
        t <- loadWorkbook(filePath)
        file_x <- readWorksheet(t, sheet = 1, header = TRUE)
        rowList[counter][1] <-nrow(file_x)
        # add the protocol type
        rowList[[counter]][2] <- str_sub(file[,1], 1,3)
    }
    })
  }
}


