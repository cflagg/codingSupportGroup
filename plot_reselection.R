##### PLOT RE-SELECTOR SUITE #####
## 1. for a single site, pull all plotIDs that are currently active 
## 2. pull in current land cover distribution for site by NLCD class
## 3. based on NLCD distribution and total number of plots inputs, determine plot selection strategy
## 4. calculate number of existing plots pler NLCD class in field under current strategy
## 5. estimate new number of plots based on selection strategy
## 6. calculate difference in number of plots between old and new sets
## 7. how many old plots exist in new sampling strategy?
## 8. how many new plots are there?

library(dplyr)

# read in existing plot data
plots <- read.csv('C:/Users/cflagg/Documents/GitHub/devTOS/spatialData/supportingDocs/applicableModules.csv', stringsAsFactors = FALSE)

# subset to site
sub <- dplyr::filter(plots, siteID=="NIWO")
View(sub)

# what are the NLCD classes present?
nlcd <- select(sub, nlcdClass) %>% filter(nlcdClass != "")

# make a proportion of the classes -- placeholder variable for real numbers
# determine percentage cover of each nlcdClass in 'nlcd'
nlcd_total <- data.frame(table(nlcd))

# calculate proportion of 'total_nlcd'
nlcd_total$proportion <- nlcd_total$Freq / sum(nlcd_total$Freq)

num_plots <- nrow(sub)
strat_plots <- sub

# random plot algorithm, based on number of plots and nlcd_total...estimate new number of plots per NLCD class
