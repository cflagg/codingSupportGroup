library(XLConnect)
library(plyr)

# source() this file in the checker

# Set working directory and file path
setwd('C:\\Users\\cflagg\\Documents\\GitHub\\neonPlantSampling\\vst_datacheck\\testdata\\ARCADIS_data\\Arcadis_plots')
pathToPlot<-c('C:\\Users\\cflagg\\Documents\\GitHub\\neonPlantSampling\\vst_datacheck\\testdata\\ARCADIS_data\\Arcadis_plots') #test data here for mapping/tagging, should only need vst_perindividual_Dxx csvs

#set this to the prefix for the sheets in your module; make specific to file name batch
plotPrefix<-'_Tower'

# load and inspect files
plotFiles <- list.files(pathToPlot, full.names=TRUE) # list all the files, full.names=TRUE is necessary for ldplay/lapply to work below

xlsGrab <- plotFiles[grep(plotPrefix,plotFiles)] # subset to just the ones in your module, using prefix

#############
### Need to store these as separate elements in a list, then merge by column names
#############

# read in .xlsx files, combine into a single file
plotList.NEON = ldply(xlsGrab, function(input){
          t <- loadWorkbook(input)
          t2 <- readWorksheet(t, sheet = 1, header = FALSE)[-c(1:6),]
          # append the names from the worksheet to the data.frame
          names(t2) <- readWorksheet(t, sheet = 1, header = FALSE)[6,]
          #colnames(t2) <- t2[6,]
          t3 <- rbind(data.frame(t2))
})

rm(plotPrefix, plotFiles, xlsGrab)

setwd('C:\\Users\\cflagg\\Documents\\GitHub\\neonPlantSampling\\vst_datacheck\\testdata\\ARCADIS_data')

# other potentially useful bind functions
# rbind.fill

# rbindList

# smartbind
