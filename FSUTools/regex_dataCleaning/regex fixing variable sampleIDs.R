# read
library(stringr)

crap <- read.csv("C:/Users/cflagg/Documents/R_Scripts/Soil microbes sample inventory 04222015.csv")

names(crap)

# take a subset to test, has three different formats
xc <- crap[c(1:10,250:260,500:510),]

head(xc);tail(xc)


##################################################### string pattern classification #####################
# how to pass multiple patterns to grepl
# http://stackoverflow.com/questions/6947587/matching-a-string-with-different-possibilities-using-grep
# begin to classify different string formats by presence/absence of certain pieces of information: 
year_pat = c("2013|2014|2015")

# is the year present
xc$yearP <- grepl(year_pat, x = xc$sampleID)

# is it spelled mineral or m
horz_pat = c("Mineral|Minera|Organic")
xc$horzFull = grepl(horz_pat, x = xc$sampleID);xc

# create empty vector for coordinates
xc$xCoord <- NA
xc$yCoord <- NA

##################################################### testing if-else loop #####################
# Begin to classify different string "types" - this is a test
for (i in seq_along(xc$yearP)){
  if (xc$yearP[i] == TRUE & xc$horzFull[i] == TRUE){
    xc$check[i] = "A" # this should just be the str_split()[5:6] call
  }else if (xc$yearP[i] == FALSE & xc$horzFull[i] == TRUE){
    xc$check[i] = "B"
  }else {
    xc$check[i] = "C" 
    }  
}

######################################## regex tagging tests ######################################## 
# meta-character approach
test <- c("l_22_2_20130709", "l_2_22_2013","l_22_22_20130709","l_2_2_20130709")

# a simpler example
test2 <- c ("l_22_x3", "l_23_x3","l_24_x3")

# this works, use the parentheses to describe how the values are "encapsulated"
# 1) the value is preceded by a bunch of values and an underscore, the second piece is just numbers, the third piece begins with an underscores 
# and ends after that
pat2 = "(^.+_)(\\d+)(_.+$)" 
sub(pat2, "\\2", test2) # return the second piece, i.e. what's in the second parenthesis set


sub(pat2, "\\2", test) # this returns the second set of numbers in the underscores, not the first

# define full pattern for test dataset
pat3 = "(^.+_)(\\d+)(_)(\\d+)(_.+$)" 
sub(pat3, "\\2", test) # take the second chunk
sub(pat3, "\\4", test) # take the fourth chunk

# experiment
xcS <- xc$sampleID

pat3 = "(^.+_)([0-9]{1,2})(_)([0-9]{1,2})(_.+$)" # limit extract to sequences where there are only 1 OR 2 digits (i.e. leave out plotID,subplotID)
# try it on real data - works except for strings with blank spaces
sub(pat3, "\\2", xcS) # first coordinate
sub(pat3, "\\4", xcS) # second coordinate

# this works for the other sampleIDs that have a blank space, leverage it as a regex pattern
pat4 = "(^.+[a-z]_)([0-9]{1,2})(_ )([0-9]{1,2})"
sub(pat4,"\\2",xcS) # first coordinate
sub(pat4,"\\4",xcS) # second coordinate

pat3 = "(^.+_)([0-9]{1,2})(_)([0-9]{1,2})(_.+$)" # structure: TRUE TRUE / TRUE FALSE
pat4 = "(^.+[a-zA-Z]_)([0-9]{1,2})(_ )([0-9]{1,2})" # structure: FALSE TRUE
# Begin to classify different string "types", then use sub  and patterns to split out the coordinates
for (i in seq_along(xc$yearP)){
  if (xc$yearP[i] == TRUE & xc$horzFull[i] == TRUE){
    xc$xCoord[i] = sub(pat3, "\\2", xc$sampleID[i])
    xc$yCoord[i] = sub(pat3, "\\4", xc$sampleID[i])
  }else if (xc$yearP[i] == FALSE & xc$horzFull[i] == TRUE){
    xc$xCoord[i] = sub(pat4, "\\2", xc$sampleID[i])
    xc$yCoord[i] = sub(pat4, "\\4", xc$sampleID[i])
  }else {
    xc$xCoord[i] = sub(pat3, "\\2", xc$sampleID[i])
    xc$yCoord[i] = sub(pat3, "\\4", xc$sampleID[i])
  }  
}


###################################################### Grab Coords WITH ENTIRE DATASET ###################################################### 
###  Incomplete - there are some other patterns to adjust the sub() function to, but this is a nice start

# additional string formats that need to be "classified": 
# BART_028_39_15_33_Mineral 21040520
# BART_006_ 21(1_7_Mineral_20140619
# CPER_001_41_Mineral_35_ 29_20131120
# CPER_001_21_M_14_ 7
# DSNY_016_16_20141022 
# HARV_001_O_SW1 20131206_Organic_10_ 6

# year pattern
year_pat = c("2013|2014|2015")

# is the year present
crap$yearP <- grepl(year_pat, x = crap$sampleID)

# is it spelled mineral or m
horz_pat = c("Mineral|Minera|Organic")
crap$horzFull = grepl(horz_pat, x = crap$sampleID);crap

# create empty vector
crap$xCoord <- NA
crap$yCoord <- NA

## Try with whole dataset
for (i in seq_along(crap$yearP)){
  if (crap$yearP[i] == TRUE & crap$horzFull[i] == TRUE){
    crap$crapoord[i] = sub(pat3, "\\2", crap$sampleID[i])
    crap$yCoord[i] = sub(pat3, "\\4", crap$sampleID[i])
  }else if (crap$yearP[i] == FALSE & crap$horzFull[i] == TRUE){
    crap$crapoord[i] = sub(pat4, "\\2", crap$sampleID[i])
    crap$yCoord[i] = sub(pat4, "\\4", crap$sampleID[i])
  }else {
    crap$crapoord[i] = sub(pat3, "\\2", crap$sampleID[i])
    crap$yCoord[i] = sub(pat3, "\\4", crap$sampleID[i])
  }  
}


