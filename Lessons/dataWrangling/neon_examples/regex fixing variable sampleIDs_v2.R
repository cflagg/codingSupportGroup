# read
library(stringr)

microbes <- read.csv("C:/Users/cflagg/Documents/R_Scripts/Soil microbes sample inventory 04222015.csv")

names(microbes)

pat3 = "(^.+_)([0-9]{1,2})(_)([0-9]{1,2})(_.+$)" # structure: TRUE TRUE / TRUE FALSE
pat4 = "(^.+[a-zA-Z]_)([0-9]{1,2})(_ )([0-9]{1,2})" # structure: FALSE TRUE
# pattern for detecting coordinates at end of string
pat5 = "(^.+_)([0-9]{1,2})(_)([0-9]{1,2})"

# check and append duplicates
z <- duplicated(microbes$sampleID) # check dupes
table(z) # summarize
microbes$dupe <- z # add to data frame

###################################################### Grab Coords WITH ENTIRE DATASET ###################################################### 
###  Incomplete - there are some other patterns to adjust the sub() function to, but this is a nice start

# additional string formats that need to be "classified": 
# BART_028_39_15_33_Mineral 21040520
# BART_006_ 21(1_7_Mineral_20140619
# CPER_001_41_Mineral_35_ 29_20131120
# CPER_001_21_M_14_ 7
# DSNY_016_16_20141022 
# HARV_001_O_SW1 20131206_Organic_10_ 6

# trim whitespace to increase pattern recognition
microbes$sampleID <- str_replace(microbes$sampleID," ","")

# year pattern
year_pat = c("2013|2014|2015")

# is the year present?
microbes$yearP <- grepl(year_pat, x = microbes$sampleID)

# is it spelled Mineral, Minera, or Organic?
horz_pat = c("Mineral|Minera|Organic")
microbes$horzFull = grepl(horz_pat, x = microbes$sampleID)

# does the end of the string have an underscore with digits?
microbes$end_coord <- str_detect(str_sub(microbes$sampleID,-3,-1), "_[0-9]{1,2}")

# create empty vector
microbes$xCoord <- NA
microbes$yCoord <- NA

# add additional data
microbes$plotID <- str_sub(microbes$sampleID,1,8)
#microbes$subplotID <- str_sub(microbes$sampleID,10,11) # some of these will be wrong
#microbes$subplotID_flag <-ifelse(str_detect(microbes$subplotID,"_") == TRUE, "BAD","OK")

## Try with whole dataset
for (i in seq_along(microbes$yearP)){
  if (microbes$yearP[i] == TRUE & microbes$horzFull[i] == TRUE){
    microbes$xCoord[i] = sub(pat3, "\\2", microbes$sampleID[i])
    microbes$yCoord[i] = sub(pat3, "\\4", microbes$sampleID[i])
  }else if (microbes$yearP[i] == FALSE | microbes$end_coord == TRUE){
    microbes$xCoord[i] = sub(pat5, "\\2", microbes$sampleID[i])
    microbes$yCoord[i] = sub(pat5, "\\4", microbes$sampleID[i])
  }else {
    microbes$xCoord[i] = sub(pat3, "\\2", microbes$sampleID[i])
    microbes$yCoord[i] = sub(pat3, "\\4", microbes$sampleID[i])
  }  
}

microbes[,c("xCoord","yCoord")]

# for some reason this is still not picking out the coordinates in these rows
xd<-microbes[c(813:835),]
xd

# paste them out and hack the csv together
cbind(as.numeric(sub(pat5, "\\2", xd$sampleID)), as.numeric(sub(pat5, "\\4", xd$sampleID)))

write.csv(microbes, file = "C:/Users/cflagg/Documents/R_Scripts/soil microbe sample inventory_string_cleaning.csv")


