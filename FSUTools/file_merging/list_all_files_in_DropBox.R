############################################# Script Summary #############################################
## This script will parse through every folder and sub-folder of the drop-box, open each .csv or .xlsx file, and count the number o rows.
## I wrote it to get a better idea of how many records there are per protocol to better inform the Time Estimates in the Manual Data Transcription protocol. 
## Author: Cody Flagg
############################################# Script Summary #############################################

# Pseudo-code: 
# create list of folders and files
# loop through each folder and each file (nested loop: folder path > file)
# open file, count the number of rows
# save the count in a list
# turn list into dataframe

library(XLConnect)
library(stringr)
library(plyr)
library(dplyr)


############################################# VARIABLE INPUTS #############################################
# These variables are passed onto functions below
# last year's dropbox data
# directory <- "N:/Science/FSU/DataL0fromFOPs/fieldData2014"
directory <- "Z:/2015data" # current dropbox data

# # protocol strings of interest -- what to parse the file output for, after it has been collated
prot_str <- c("tck", "cdw", "dhp", "ltr", "mos", "vst", "sls", "soi", "Pla", "div") # for 2015 -- soils data have a few prefixes
# prot_str <- c("phe")
############################################# VARIABLE INPUTS #############################################

# only lists the folders in the root
# folderList <- list.files(directory, full.names = TRUE)

# lists all folders in a directory, including sub-folders ## VARIABLE INPUT ## 
dirList <- list.dirs(directory)

# how does debug work?
# debug(mean) # point debug to a function you need to understand
# mean(1:10) # run the function
# undebug(mean) # turn debugger off when you're done

# this is a quick trick to use the visual debugger, turn the loop into a function with zero arguments (i.e. name <- function(){})
# , embed browser() inside of the loop, then call the function you just made ("fileParse()" below).
#  R will activate the debug() function, which is nearly identical to browser(), except that its scope is limited to local variables 
# within the function, AND it will highlight which line is being run for each 'enter' stroke

# fileParse <- function(){
# need to dive into each folder, decide if it's a .csv or .xlsx, then read the rows
rowList <- list() # initialize a list object to populate
counter = 0
for (folder in dirList){
  # browser() # this is the interactive debugger, its scope is global & local
  # list all files in a particular folder
  folder_content <- list.files(folder) # here is a new note
  for (fileN in folder_content){
    # iterate the file count for tracking and for indexing the list
    counter = counter + 1
    # EXCEPTION HANDLING -- PASS ON GRASS -- this will keep the loop going even if there is an error
    # Added b/c there are .xls and .xlsx files
    try({
    # grab the file type
    fileType <- str_sub(string = fileN, start = -4, end = -1)
    print(paste(counter, fileType))
    # **MODIFY HERE** -- If you pull out the 3-letter protocol prefix, you can pass that info to the if else statements 
    # to just grab files from a specific protocol e.g.: 
    # protocolType <- grep(pattern = contains("vst"), x = file)
    # pass the full file path
    filePath <- paste(folder,"/",fileN, sep="")
      # **MODIFY HERE**
      #if (fileType == ".csv" & protocolType == "vst")
      if (fileType == ".csv"){
        # add the number of rows - **MODIFY HERE** TO GRAB FULL CONTENTS OF FILE
        rowList[counter][1] <- nrow(read.csv(filePath)) # this is just storing the row count, rather than the file contents
        # add the protocol type
        rowList[[counter]][2] <- str_sub(fileN, 1,3)
        # add file name for tracking purposes 
        rowList[[counter]][3] <- fileN
      }else if (fileType == "xlsx"){
        t <- loadWorkbook(filePath)
        file_x <- readWorksheet(t, sheet = 1, header = TRUE)
        ## **MODIFY HERE** TO GRAB FULL CONTENTS OF FILE
        rowList[counter][1] <-nrow(file_x) # this is just storing the row count, rather than the file contents
        # add the protocol type
        rowList[[counter]][2] <- str_sub(fileN, 1,3)
        # add file name for tracking
        rowList[[counter]][3] <- fileN
    }
    })
  }
}
# }

# execute function
# rowListfileParse()

# munging the list into a data frame
# takes each list element and returns a dataframe
rowsProtocol <- plyr::ldply(rowList) # list to dataframe
colnames(rowsProtocol) <- c("rows", "protocol", "fileName")
write.csv(rowsProtocol, file = "C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/report_outputs/allDropboxFiles_2015.csv")

## write a csv with ALL files, not pared down by protocol abbreviation
#write.csv(x = rowsProtocol, file = "C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/allDropboxFiles_2015.csv")

# grab the uniques
unique(rowsProtocol$protocol)

# convert to numeric
rowsProtocol$rows <- as.numeric(rowsProtocol$rows)

# specifically looking at files with soils data
dplyr::filter(rowsProtocol, protocol %in% c("soi", "sls"))

## test grep
#x  <- c("yo", "yo", "ma", "da", "pa")
## a reverse grep on the row index
#x[-grep(pattern = "yo", x)]
library(stringr)
prot_str <- c("tck", "cdw", "dhp", "ltr", "mos", "vst", "sls", "soi")

# return non-WebUI data files
access_csv <- rowsProtocol[grep(pattern = paste(prot_str, collapse="|"), x = rowsProtocol$fileName),]

# drop the error rate files
access_out <- access_csv[-grep(pattern = "errorRate|ErrorRate|errorrate", x = access_csv$fileName),]

# append the domainID
domain_pat <- "(D[0-9]{1,2})"
access_out$domainID <- str_extract(string = access_out$fileName, pattern = domain_pat)

write.csv(access_out, file = "C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/accessData_2015.csv")

###################################################################################################################################
############################################# THIS IS SPECIFIC TO PHENOLOGY 2014 DATA #############################################
###################################################################################################################################

# # http://stackoverflow.com/questions/27903890/summarize-rows-grouped-by-id-and-preserve-other-non-grouping-variables
# filter out the crap e.g. csv files from the WebUI, oddly named files etc.
# ## VARIABLE INPUT ## 
# row_summary <- dplyr::filter(rowsProtocol, protocol %in% prot_str) %>% 
#   group_by(protocol) %>% 
#   summarize(meanRows_perFile = mean(rows), minRows_perFile = min(rows), maxRow_perFiles = max(rows), totalRows_allFiles = sum(rows), nFiles=length(rows)) 
# 
# # print it out
# row_summary
#   
# # how the data would be summarized
# ddply(rowsProtocol, ~protocol, summarize, meanRows = mean(rows))
# 
# determine how many files were not parsed
# sapply() takes the first list element of the group | ldply() turns the output into a data.frame | table() summarizes the output 
# "== 0" tests the condition that a file has zero rows (i.e. a NULL)
# sapply() is accessing list elements via "[[", the third argument ("1") tells it to process the first list element
table(ldply(sapply(rowList, "[[" ,1)) == 0)
# 
# phe2014_only <- dplyr::filter(rowsProtocol, protocol == "phe")
# 
# write.csv(phe2014_only, file = "phen2014_rowCounts.csv")
