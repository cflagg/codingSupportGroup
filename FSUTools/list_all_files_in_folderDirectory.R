# create list of folders and files
# loop through each folder and each file
# count the number of rows in each file
# save the count

library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)

# only lists the folders
folderList <- list.files("Z:/2015data", full.names = TRUE)

# lists all folders in a directory, including sub-folders
dirList <- list.dirs("Z:/2015data")

# need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
rowList <- list()
counter = 0
for (folder in dirList){
  # list all files in a particular folder
  folder_content <- list.files(folder)
  for (file in folder_content){
    # iterate the file count for tracking and for indexing the list
    counter = counter + 1
    # EXCEPTION HANDLING -- PASS ON GRASS -- this will keep the loop going even if there is an error
    try({
    # grab the file type
    fileType <- str_sub(string = file, start = -4, end = -1)
    print(paste(counter, fileType))
    # pass the full file path
    filePath <- paste(folder,"/",file, sep="")
      if (fileType == ".csv"){
        # add the number of rows
        rowList[counter][1] <-nrow(read.csv(filePath))
        # add the protocol type
        rowList[[counter]][2] <- str_sub(file, 1,3)
        # add file name for tracking purposes
        rowList[[counter]][3] <- file
      }else if (fileType == "xlsx"){
        t <- loadWorkbook(filePath)
        file_x <- readWorksheet(t, sheet = 1, header = TRUE)
        rowList[counter][1] <-nrow(file_x)
        # add the protocol type
        rowList[[counter]][2] <- str_sub(file, 1,3)
        # add file name for tracking
        rowList[[counter]][3] <- file
    }
    })
  }
}

# munging the list into a data frame
rowsProtocol <- plyr::ldply(rowList)
colnames(rowsProtocol) <- c("rows", "protocol", "fileName")

# grab the uniques
unique(rowsProtocol$protocol)

# protocol strings of interest
prot_str <- c("tck", "cdw", "dhp", "ltr", "mos", "vst", "sls", "soi", "Pla", "div")

# convert to numeric
rowsProtocol$rows <- as.numeric(rowsProtocol$rows)

# # http://stackoverflow.com/questions/27903890/summarize-rows-grouped-by-id-and-preserve-other-non-grouping-variables
# filter out the crap e.g. csv files from the WebUI, oddly named files etc.
row_summary <- dplyr::filter(rowsProtocol, protocol %in% prot_str) %>% 
  group_by(protocol) %>% 
  summarize(meanRows_perFile = mean(rows), minRows_perFile = min(rows), maxRow_perFiles = max(rows), totalRows_allFiles = sum(rows), nFiles=length(rows)) 

# print it out
row_summary
  
# how the data would be summarized
ddply(rowsProtocol, ~protocol, summarize, meanRows = mean(rows))

# determine how many files were not parsed
# sapply() takes the first element of the group | ldply() turns the output into a data.frame | table() summarizes the output 
# "== 0" tests the condition that a file has zero rows (i.e. a NULL) 
table(ldply(sapply(rowList, "[[" ,1)) == 0)


