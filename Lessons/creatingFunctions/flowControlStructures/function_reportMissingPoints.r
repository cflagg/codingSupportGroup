#Set path to files (you could set the working directory here too, if you want outputs to go to the same location)
setwd('C:/Users/nrobinson/Desktop/MyDocuments/NEON_Git/codingSupportGroup/creatingFunctions/flowControlStructures')


#Load data files
plotfile <- read.csv('plotSpatialData_batch2.csv',stringsAsFactors=F)
pointfile <- read.csv('pointSpatialData_batch2.csv',stringsAsFactors=F)
modsPerPlot<-read.csv('applicableModules_30mar2015.csv',stringsAsFactors=F)


#Function to report missing points by plot, as filtered by module.
#  This function uses the 'modsPerPlot' table to find which plotIDs are associated with a specified module,
#  then assesses whether the pointfile table contains the correct point data for these plots 
#  Inputs = appModsData: table of applicable modules by plotID
#           mod: module of interest when you run the function
#           pointData: table of point spatial data
#           pointList: list of points that should be in each plot, for the specified module

reportPlots<-function(appModsData, mod, pointData, pointList){
  #Make list of plotIDs where sampling of the mod is occurring (the mod is in the applicableModules list)
  plts<-unique(appModsData$plotID[which(grepl(mod,appModsData$applicableModules))]) 
  
  #Initiate empty vectors to hold results of missing points checks
  missingPlts<- vector(); missingPts<-vector()
  
  #For each plotID in the list created above, subset the data by that plotID and see if all of the 
  #  points in the pointList are in the subset. If not, report the plotID and the missing point(s)
  for (p in plts){  
    sub<-pointData[which(pointData$plotID == p & grepl(mod,pointData$applicableModules)),]
    if (nrow(sub)>1){  #only proceed if the plotID is in the point table (not all plots are in this table)
      for (i in pointList){
        if (i %in% sub$pointID == FALSE){
          missingPts<-c(missingPts,i); missingPlts<-c(missingPlts,p)
        }
      }
    }
  }
  return (cbind(missingPlts,missingPts))  #Return a dataframe as the output
}



#Run the function for bet and div
#Identify lists of expected points per module
betLst<-c('N','E','W','S')
divLst<-c('31.1.1','31.1.10','31.4.1','31.4.10','32.2.1','32.2.10','32.4.1','32.4.10','40.1.1','40.1.10',
          '40.3.1','40.3.10','41.1.1','41.1.10','41.4.1','41.4.10',31,41,40,32)

#Call function, once for each module
missingBetPts<-reportPlots(modsPerPlot, 'bet', pointfile, betLst)
missingBetPts  #No missing points found
missingDivPts<-reportPlots(modsPerPlot, 'div', pointfile, divLst)
missingDivPts  #Several missing points found
