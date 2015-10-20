library(plyr)
library(dplyr)
setwd("/Users/lstanish/Documents/R_code/")

# Read in data and keep only dates after Julian date 269.
#After reading in file, convert date field to readable Date
year1 <- read.csv("NRCS_SCAN_DATA_AirTemp_2010_SERC.csv")[270:365,]
year1$julianDate <- c(270:365)
year1$Date = 2010

year2 <- read.csv("NRCS_SCAN_DATA_AirTemp_2011_SERC.csv")[270:365,]
year2$julianDate <- c(270:365)
year2$Date = 2011

year3 <- read.csv("NRCS_SCAN_DATA_AirTemp_2012_SERC.csv")[270:365,]
year3$julianDate <- c(270:365)
year3$Date = 2012

year4 <- read.csv("NRCS_SCAN_DATA_AirTemp_2013_SERC.csv")[270:365,]
year4$julianDate <- c(270:365)
year4$Date = 2013

year5 <- read.csv("NRCS_SCAN_DATA_AirTemp_2014_SERC.csv")[270:365,]
year5$julianDate <- c(270:365)
year5$Date = 2014

###### INCOMPLETE test <- merge(year1, year2, by=********)
temps <- data.frame(cbind("x2010"=year1$TAVG.D.1_C, "x2011"=year2$TAVG.D.1_C, 
                "x2012"=year3$TAVG.D.1_C, "x2013"=year4$TAVG.D.1_C, "x2014"=year5$TAVG.D.1_C) )

# There's gotta be a better way to do this, but I can't figure it out now
week <- vector(mode="numeric", length=0)
ct <- 1
wk <- 39
while (ct < nrow(temps)) {
  week[ct:(ct+6)] <- rep(wk, times=7)
  ct <- ct+7
  wk <- wk+1
}

temps$Week <- week[1:nrow(temps)]

# Replace -99.9 values as "NA" 
temps$x2010[which(temps$x2010 ==-99.9)] <- "NA"
temps$x2011[which(temps$x2011 ==-99.9)] <- "NA"
temps$x2012[which(temps$x2012 ==-99.9)] <- "NA"
temps$x2013[temps$x2013 ==-99.9] <- "NA"
temps$x2014[temps$x2014 ==-99.9] <- "NA"

rns <- rownames(temps)
plot(rns,temps$x2010)
lines(rns, temps$x2011, col="green")
lines(rns, temps$x2012, col="blue")
lines(rns, temps$x2013, col="red")
lines(rns, temps$x2014, col="violet")

summarize(group_by(temps, Week))

test <- ldply(temps, mean())
for (i in 1:nrow(temps)) {
  
}