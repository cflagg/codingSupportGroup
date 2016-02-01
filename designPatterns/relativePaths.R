rm(list=ls())
if (file.exists('C:/spatialDataLookup')) {
  mypathtorepo <- 'C:/spatialDataLookup/'
}

if (file.exists(
  'C:/Users/selmendorf/Documents/ATBDS/ATBDgit/organismalIPT')){
  myPathtoIPTrepo<-'C:/Users/selmendorf/Documents/ATBDS/ATBDgit/organismalIPT/'
}

if (file.exists(
  'C:/Users/kthibault/Documents/GitHub/organismalIPT')){
  myPathtoIPTrepo<-'C:/Users/kthibault/Documents/GitHub/organismalIPT/'
}

if (file.exists(
  'C:/Users/nrobinson/Desktop/MyDocuments/NEON_Git/organismalIPT/')){
  myPathtoIPTrepo<-'C:/Users/nrobinson/Desktop/MyDocuments/NEON_Git/organismalIPT/'
}

if (file.exists(
  'C:/Users/cflagg/Documents/GitHub/organismalIPT')){
  myPathtoIPTrepo<-'C:/Users/cflagg/Desktop/Documents/GitHub/organismalIPT/'
}

getwd()

myPathtoIPTrepo

# https://stat.ethz.ch/R-manual/R-patched/library/base/html/list.files.html
# http://astrostatistics.psu.edu/su07/R/html/base/html/files.html
# http://stackoverflow.com/questions/21582402/knitr-how-to-set-a-figure-path-in-knit2html-without-using-setwd
# http://stackoverflow.com/questions/10300769/how-to-load-packages-in-r-automatically?rq=1