# Join real taxonIDs with Access DB numeric taxonIDs

# This script is for "correcting" veg structure files by appending character taxonIDs alongside the numeric values 
# in the taxonID field. The Access DB exports numbers instead of actual codes for reasons unknown, but the true 
# taxonIDs can simply be joined to the table since the integer values follow the row order of the plant list. 

# The loop below imports all files within the working directory, then sequentially moves through the VST files by domain,
# opening an Access DB to load the plant list, then performs a left_join() on the files to finally export a CSV that contains
# the character values for the taxonID field, which is appended as "taxonID.y". 

library(stringr) # for regex ops
library(RODBC) # for connecting to Access tables
library(dplyr) # for select

# set working directory and grep files
wd <- getwd()

wd <- paste("C:/Users/cflagg/Documents/Test/vst_fixes", sep="")

fileList <- list.files(wd, full.names=TRUE) # 

csvList <- fileList[grep(".csv", fileList)]

dbList <- fileList[grep(".accdb", fileList)]

## access DB list
## http://rprogramming.net/connect-to-ms-access-in-r/


# for each unique domain ... grab vst files, then grab plant list
domainList <- na.exclude(unique(str_match(csvList, "D[0-9]{2}"))) # find unique domains in list

# only grep files that have the domain
# then split files into vst and plant lists


# execute join for each unique domainID
for (domain in unique(domainList)){
  browser()
  # load files
  dom_files <- csvList[grep(domain, csvList)] # all csv files
  vst_files <- dom_files[grep("vst_",dom_files)] # only input vst files
  #plant_list <- dom_files[grep("_Plants_", dom_files)] # matching domain plant list
  # connect to the related Access DB
  db_file <- dbList[grep(paste(domain,"_vst_dataIngest",sep=""), dbList)] # the name of the DB file
  dd <- paste("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db_file, sep="") # the syntax for ODBC access
  print(db_file)
  db_channel <-  odbcDriverConnect(dd) # open a channel to the DB
  plant_list <- sqlQuery(db_channel, paste("select * from USDA_plantList_2015")) # query the table and store it
  plant_list$ID <- seq(1,nrow(plant_list)) # add ID values sequentially
  #now join the plant_list with the vst_files that have taxonID
  for (files in unique(vst_files)){
    vst_dat <- read.csv(files,header=T,stringsAsFactors = FALSE) # read in the files sequentially
    # don't attempt the join if there is not a taxonID field in the file 
    if ("taxonID" %in% colnames(vst_dat)){
      # join vst file with Access DB plant list
      dat <- left_join(vst_dat, plant_list, by = c("taxonID" = "ID"))
      # trim columns - select() works off of column integers, not names
      colNums <- match(colnames(vst_dat),names(vst_dat)) # determine numeric positions of columns
      out_dat <- select(dat, colNums, taxonID.y) # include the character-taxonID e.g. "taxonID.y"
      # print file
      name_out <- str_split_fixed(files,"/",7)[7] # grab the name of the file, e.g. the 6th element in this list
      write.csv(out_dat, file = paste(name_out,"_corrected.csv", sep="")) ########################################## this needs to be adjusted to name_out, else the file name is incorrect
    }
    # if there is no taxonID field, skip the file
  }
  #odbcClose() - close the Access DB connections before starting the next batch
  odbcCloseAll()
}


