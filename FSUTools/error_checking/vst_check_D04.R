### Checking to make sure that D04 uploaded two "batches" of unique VST records

library(plyr)
library(dplyr)
library(stringr)
library(atbdLibrary)

# D04 VST files
vst1 <- read.csv("Z:/2015data/D04/vst_mapping_in_VC_D04_corrected.csv")
vst2 <- read.csv("Z:/2015data/D04/vst_mapping_in_D04.csv")
vst3 <- read.csv("Z:/2015data/D04/vst_shrubgroup_VC_D04_corrected.csv")
vst4 <- read.csv("Z:/2015data/D04/vst_other_in_VC_D04_corrected.csv")

names(vst1)
names(vst2)

allData <- rbind(vst1, vst2)

# 
allData <- flag_dups(df = allData, updateQFCol = TRUE, cols = c("siteID", "date", "plotID", "tagID", "taxonID"), qfColName = "dupeRecords")
table(allData$dupeRecords)

# spatial data
plotData <- read.csv("C:/Users/cflagg/Documents/GitHub/devTOS/spatialData/supportingDocs/pointSpatialData_20151014.csv")
plotData$siteID <-  str_sub(plotData$plotID, 1,4)

# each plotID still has a duplicate row because of sub-plots
guanData <- filter(plotData, siteID == "GUAN")

# grab only the first row for each plotID
unqGuanData <- guanData[!duplicated(guanData$plotID),]

filter(allData, dupeRecords == 2)


# tagID check
vst1$tagID %in% vst2$tagID
vst2$tagID %in% vst1$tagID

# check the dates
vst1$date %in% vst2$date
vst2$date %in% vst1$date

# toupper since not all are capitalized
vst1_plots <- toupper(vst1$plotID)
vst2_plots <- toupper(vst2$plotID)

# merge the character vectors, turn into data frame so it can be merged
allvst <- data.frame(plotID = c(vst1_plots,vst2_plots))

# check merged file for distributed vs. tower
allvst2 <- plyr::join(x = allvst, y = unqGuanData, by = "plotID", type = "left")

# check the individual files
vst1_plotData <- plyr::join(x = vst1, y = unqGuanData, by = "plotID", type = "left")
vst2_plotData <- plyr::join(x = vst2, y = unqGuanData, by = "plotID", type = "left")
vst3_plotData <- plyr::join(x = vst3, y = unqGuanData, by = "plotID", type = "left")
vst4_plotData <- plyr::join(x = vst4, y = unqGuanData, by = "plotID", type = "left")

table(vst2_plotData$plotType)
table(vst1_plotData$plotType)
table(vst3_plotData$plotType)
table(vst4_plotData$plotType)



