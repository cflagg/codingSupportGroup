### This function randomly chooses two subplots for Plant Biomass and Productivity sampling from the four possible subplots present in a 40x40m Tower plot. The plotID is used as a set.seed so that the function output is reproducible. Subplots are not randomly chosen for 20x20m Tower plots.

### Assumptions made by the function:
##  Initial working directory is the default directory associated with the Rproj file: 'R_neonPlantSampling'

##  Lists of accepted plots with associated spatial data fields exist in a directory called "acceptedPlots" in which:
# There are .csv files providing a list of accepted plots by site, named according to the convention: "XXXX_plotSpatialData.csv", where XXXX is the 4-letter unique site code.
# There are "plotID" and "plotType" columns in these files.

##	The following variables are required as inputs:
#	siteCode = 4-letter unique NEON site code; must enter with "", e.g. "HARV"
# plotType = Identifier of the type of plot, either "distributed" or "tower"; must enter with "", e.g. "tower"

randomSubplots = function(siteCode){
  
  #  Load 'TeachingDemos' package so plotIDs may be turned into unique numeric seeds
  require(TeachingDemos)
  
  # Obtain list of accepted plotIDs from "acceptedPlots" folder, where plotType = 'tower' & subtype = 'basePlot', and return to current working directory
  setwd("acceptedPlots")
  acceptedFile = paste(siteCode,"_plotSpatialData.csv", sep="")
  acceptedPlot = read.csv(acceptedFile, header=T, stringsAsFactors=F)
  setwd("../")
  
  ### Determine the sizes of Tower plots present for given value of 'siteCode', and use if/else statement to stop code below if there are tower base plots with plotSize = 400 in 'acceptedPlot', and warn user that function was not run.
  acceptedTowerBase = acceptedPlot[which(acceptedPlot$plotType=='tower' & acceptedPlot$subtype=='basePlot'),]
  theSizes = acceptedTowerBase$plotSize
  if (400 %in% theSizes){
    print("Random subplots are not required when Tower base plotSize = 400")
  } else {  
  
  # Set working directory to 'towerSubplotLists', and obtain plotIDs for those Tower plots that have subtype = 'basePlot'
  setwd("towerSubplotLists")
  plotID = as.character(acceptedPlot$plotID[which(acceptedPlot$plotType=='tower' & acceptedPlot$subtype=='basePlot')])
  
  
  # Create a dataframe to hold function output, and insert list of desired plotIDs
  subplots.df = data.frame(matrix(data=NA, nrow=length(plotID), ncol=3))
  cNames = c("plotID","aSubplotID","bSubplotID")
  colnames(subplots.df) = cNames
  subplots.df$plotID = sort(plotID)
  
  # Create a vector of subplotIDs from which to randomly sample; currenty, subplotIDs are specific to a 40m x 40m plot
  theSubplots = c(21,23,39,41)
  
  ##  Use a "for" loop to generate two randomly selected subplots for each value of plotID
  for (i in 1:nrow(subplots.df)){
    # Use the plotID as a set.seed so that randomly selected subplots are reproducible
    randomSeed = subplots.df$plotID[i]
    char2seed(randomSeed, set=TRUE); theChosen = sort(sample(theSubplots, 2))
    
    # Store randomly chosen subplotIDs in subplots.df
    subplots.df$aSubplotID[i] = theChosen[1]
    subplots.df$bSubplotID[i] = theChosen[2]
    
  }
  
  # Write output to a .csv file, and return working directory to 'R_neonPlantSampling'
  outputName = paste(siteCode, "randomTowerSubplots.csv", sep="_")
  write.csv(subplots.df, file=outputName, row.names=FALSE)
  setwd("../")

  # End if/else
  }
  
# End function
}