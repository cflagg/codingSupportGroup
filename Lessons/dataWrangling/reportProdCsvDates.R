#code to summarize min/max dates per OS product on portal by site
library (dplyr)
#download all the OS data from the portal: data.neoninc.org
#choose all OS data, from all sites

#and unzip it in a directory here

myDataDir<-'C:/Users/selmendorf/Desktop/dataDump3252015'
fileList<-list.files(myDataDir)

#figure out one base file that should have all the dates per protocol
#there are multiple files for each but this one will be primary enough
mamfiles<-fileList[grepl('mam_perplotnight', fileList)]
divfiles<-fileList[grepl('div_400m2Data', fileList)]
phefiles<-fileList[grepl('phe_statusintensity', fileList)]
hpbfiles<-fileList[grepl('hbp_perbout', fileList)]
betfiles<-fileList[grepl('bet_fielddata', fileList)]

#define function
stackfiles<-function(files){
  out<-NULL
  for (i in files){
    out<-rbind(out, read.csv(paste(myDataDir, i, sep='/')))  
  }
  names(out)[names(out)=='collectDate']<-'date'
  out$date<-as.Date(out$date)
  return(out)
}

sumDates<-function(df){
  require(dplyr)
  out<-as.data.frame(df%>%
                       group_by(siteID) %>%
                       summarise(start = min(date),end=max(date)))
}

sumDates<-function(df){
  require(dplyr)
  out<-as.data.frame(df%>%
                       group_by(siteID) %>%
                       summarise(start = min(date),end=max(date)))
}

mamSum<-stackfiles(mamfiles)%>%sumDates
divSum<-stackfiles(divfiles)%>%sumDates
pheSum<-stackfiles(phefiles)%>%sumDates
hpbSum<-stackfiles(hpbfiles)%>%sumDates
betSum<-stackfiles(betfiles)%>%sumDates

#write out somewhere
write.csv(mamSum, paste('C:/Users/selmendorf/Desktop/', 'mamSum.csv', sep=''), row.names=F)
write.csv(betSum, paste('C:/Users/selmendorf/Desktop/', 'betSum.csv', sep=''), row.names=F)
write.csv(pheSum, paste('C:/Users/selmendorf/Desktop/', 'pheSum.csv', sep=''), row.names=F)
write.csv(hpbSum, paste('C:/Users/selmendorf/Desktop/', 'hpbSum.csv', sep=''), row.names=F)
write.csv(divSum, paste('C:/Users/selmendorf/Desktop/', 'divSum.csv', sep=''), row.names=F)
