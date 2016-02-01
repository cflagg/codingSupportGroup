### CFlagg, 09/08/2015
### This script loads and formats a plotID table for the 2015 Access databases used for manual data entry. 
# load libraries
library(dplyr)
library(RODBC)

# read data
plot_df <- read.csv("C:/Users/cflagg/Documents/GitHub/devTOS/spatialData/supportingDocs/applicableModules.csv")

# check number of rows, has it changed?
nrow(plot_df)

# add columns to match L_plotIDs table
plot_df$domainID <- ""

# add unique ID to plotID list
plot_df$ID <- seq(1, nrow(plot_df), by = 1)

# select columns for output to plotID table for databases
plot_df %>% select(ID, domainID, plotID, plotType, subtype, plotSize, siteID) -> plotID_out

# # make plotIDs for ticks and mosquitos
# plotID_tick <- filter(plotID_out, subtype == "tickPlot")
# plotID_mosquito <- filter(plotID_out, subtype == "mosquitoPoint")


## write csv file for importing
# write.csv(file = plotID_out, "N:/Science/FSU/FOPSDataEntry/2015/plotID_siteID_tables/plotID_09082015.csv")

# grab the files
setwd("C:/Users/cflagg/Documents/Test/db_test")
dbList <- list.files(full.names=FALSE)
dbList <- dbList[grep(pattern = ".accdb", x = dbList)]
#dbList2 <- dbList[grep(pattern = ".accdb", x = dbList)]
#dbList2 <- dbList2[-3]

# FOR EACH FILE IN FILELIST, DO THE FOLLOWING: 
# 1) Establish ODBC Connection
# connect to the related Access DB
for (db in dbList){
  # browser()
  db_file <- paste(getwd(),"/",db,sep="")
  dd <- paste("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db_file, sep="") # the syntax for ODBC access
  db_channel <-  odbcDriverConnect(dd) # open a channel to the DB
  plotList <- sqlQuery(db_channel, paste("select * from L_plotIDs_2015")) # 
  print(paste(nrow(plotList), db))
  # 2) clear plotID table of target DB
  sqlDrop(db_channel, "L_plotIDs_2015") # delete the table
  # 3) update table with plotID_out 
  sqlSave(db_channel, plotID_out, tablename = "L_plotIDs_2015",rownames = FALSE) # replace it with the new table
  # print(db_channel)
  odbcClose(db_channel) # close connection 
}

# dd <- paste("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:/Users/cflagg/Documents/Test/db_test/sls_dataIngest_2015_v2.accdb", sep="") # the syntax for ODBC access
# db_channel <-  odbcDriverConnect(dd)
# 
# sqlDrop(db_channel, "L_plotIDs_2015") # delete the table
# 
# sqlSave(db_channel, plotID_out, tablename = "L_plotIDs_2015",rownames = FALSE)
# getwd()



