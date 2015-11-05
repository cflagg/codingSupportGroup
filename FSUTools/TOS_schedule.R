########### TO DO ###########

# 1) exception handling for empty sheets e.g. "sheet1" throws an error -- probably embed everything in tryCatch()??

# 2) put data files in github and point file checker to that directory

# 2) way to access excel file on sharepoint directly?
# sharepoint location: https://neoninc.sharepoint.com/sites/fieldops/private/documents/_layouts/15/WopiFrame.aspx?sourcedoc=%7b6BE35F35-785F-4F20-A7FE-2498E0480591%7d&file=TOS%20Protocol%20Implementation%20April%202015.xlsx&action=default

#############################


# this script lays out an example for combining multiple Excel files or multiple sheets within a single Excel file
# Cody Flagg - 6/17/2015

library(XLConnect)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lazyeval)

# source() this file in the checker

# Set working directory and file path
setwd('C:/Users/cflagg/Documents/Test/fopsCalendar')

#set this to the prefix for the sheets in your module; make specific to file name batch
prefix<-'.xlsx'

# load and inspect files
files <- list.files(getwd(), full.names=TRUE) # list all the files, full.names=TRUE is necessary for ldplay/lapply to work below

xlsGrab <- files[grep(prefix,files)] # subset to just the ones in your module, using prefix

# create a function to pull all of the worksheets together into a single data frame
scheduler <- function(input){
    # loading excel workbook
    #output <- data.frame()
    #browser()
    # create an empty object to fill
    output <- NULL
    t <- loadWorkbook(input)
    # variable to pass sheet names
    sheets_list <- getSheets(t)
    # iterate through every sheet, load workbook 't' and worksheet 's'
    for (sh in unique(sheets_list)){
      w <- readWorksheet(t, sheet = sh, header = TRUE)
      # fix herbaceous clip column names
      colNum <- grep("Herb", names(w)) # figure out what column number is
      colnames(w)[colNum] <- "HerbClip" # give it a more generic name
      # add the date
      w$date <- sh
      # print(head(t2))
      # append the names from the worksheet to the data.frame
      output <- rbind.fill(w, output)
    }
    return(output)
}

# run the function
sched <- scheduler(xlsGrab)
# remove whitespace from site so that spacing is uniform
sched$Site <- str_trim(sched$Site)
# create a nice siteID
sched$siteID <- str_sub(sched$Site,-4,-1)

# replace X's with 1's and everything else with 0's
sched2 <- apply(sched[,c(1:16)], 2, function(x) ifelse(grepl(pattern ="[a-zA-z]", x=x), TRUE, FALSE))

# rejoin with sched, leave out siteID and date
sched <- cbind(sched[c("siteID","date")], sched2)

# create a real date ('rDate')
sched$rDate <- paste(str_sub(sched$date, 5,6),"/",str_sub(sched$date, -2,-1),"/",str_sub(sched$date,1,4),sep="")

# turn it into a date format that R recognizes, tell it what the input form is with 'format = '
sched$rDate <- as.Date(sched$rDate,format = '%m/%d/%Y')
# solution adapted from:
# http://stackoverflow.com/questions/27968853/making-a-presence-absence-timeline-in-r-for-multiple-y-objects

# creating a 'consecutive' field allows ggplot to determine if the line should be draw from endpoint to endpoint, or if there
# are 'gaps' between sampling dates, i.e. if the sampling was not continuous throughout the year

# now we need a gantt chart...

#################################################################################################################################
################################################# PLOTTING FUNCTION #############################################################
#################################################################################################################################
# test out on Veg.Structure
sched_vis <- function(data, prot, gap = 15){
  
    # re-order the siteID levels   
    # site_levels <- data$siteID[order(data$siteID)]
    #  data$siteID <- factor(data$siteID, levels = site_levels)
    
    # dplyr requires useage of standard evaluation functions_() in order to work inside of other functions such as this
    # the structure and handling of the dplyr verbs are thus slightly different, starting with the interp() function, which is used to pass 
    # the string variable 'prot' from above
    # source: http://stackoverflow.com/questions/26492280/non-standard-evaluation-nse-in-dplyrs-filter-pulling-data-from-mysql
    criteria <- interp(~ prot == TRUE, prot = as.name(prot))
    data <- data %>% select_("rDate", "siteID", prot)
    
    # arrange dates into ascending order, so the lag is calculated correctly  --- MUST DO THIS ---
    data <- arrange_(data, "siteID", "rDate")
    
    # THIS WORKS - consecutive = less than or equal to a 14 day gap between sampling dates
    data <- data %>% select_("siteID", "rDate", prot) %>% group_by_("siteID", prot) %>% mutate(consecutive=c(diff(rDate),gap)<=(gap-1))
    
    # THIS WORKS -- filter() limits the graph to just sites that have had the sampling, else the plot becomes cluttered
    # filter_ needs the statement to be crafted as per above for object 'criteria'
    data %>% filter_(criteria) %>% ggplot(aes(rDate, siteID)) + 
      geom_line(aes(alpha=consecutive, group=siteID),size=2,color="blue")+ geom_point(aes(group=siteID),size=3.5, color = c("red"))  + theme_bw() +
      scale_alpha_manual(values=c(0, 1), breaks=c(FALSE, TRUE), guide='none') + ggtitle(prot)
}

sched_vis(sched, "Veg..Characterization")
names(sched)
sched_vis(sched, "Coarse.Downed.Wood")
#################################################################################################################################
#################################################################################################################################


#################################################### VESTIGIAL ####################################################


## Min/Max VC sampling dates for KJ ## 
# only include dates where sampling occurred
# sched4b %>% filter(Veg..Characterization == TRUE) %>% select(-consecutive) -> vc_dates
# 
# # calculate first and last dates of sampling by site
# vc_dates_sum <- ddply(vc_dates, .(siteID), summarize, firstDate = min(rDate), lastDate = max(rDate))
# 
# # siteID/domainID hash table
# siteDomain <- read.csv("N:/Science/FSU/FOPSDataEntry/2015/plotID_siteID_tables/plotIDs_2015_09052015.csv")
# 
# siteDomain_hash <- siteDomain %>% select(domainID, siteID, stateProvince)
# 
# siteDomain_hash <- unique(siteDomain_hash)
# 
# sd_out <- left_join(vc_dates_sum, siteDomain_hash, by = "siteID")
# 
# write.csv(sd_out, file = "C:/Users/cflagg/Documents/Test/vc_dates.csv")
# 
# vc_dates_out <- arrange(vc_dates)
# 
# write.csv(vc_dates_out, file = "C:/Users/cflagg/Documents/Test/vc_dates_all.csv")
# 
# write.csv(sched, file = "C:/Users/cflagg/Documents/Test/TOS_implementation_compiled.csv")

# sched4c <- sched4 %>% select(siteID,rDate,Veg.Structure)


# # what happens when they are ordered correctly? --- THIS WORKS --- this is less than or equal to am 8 day sampling gap
# sched4 %>% group_by(siteID,Veg.Structure)  %>% mutate(consecutive=c(diff(rDate),9)<=8) %>% 
#   filter(siteID == "JERC",Veg.Structure==TRUE) %>% ggplot(aes(rDate,siteID)) + geom_point(aes(group=siteID),size=3) + 
#   geom_line(aes(alpha=consecutive,group=siteID))
# 
# # just points, no lines
# sched4 %>% filter(Veg.Structure == TRUE) %>% ggplot(aes(rDate, siteID)) + 
#   geom_point(aes(group=siteID),size=2, color = c("red")) + theme_bw() 
# 
# # how to understand consecutive dating of sampling dates, for visualization purposes:
# # if the lagged difference in dates is less than or equal to a value, then give it the value TRUE
# 
# # group_by, mutate, diff, consecutive test
# m  <- data.frame(a = c(1,3,5,7,12,14), b = c(rep("a",3),rep("b",3))) # supply the data
# # need to concatenate, c(), with diff() because it returns a vector of n-1, thus adding another value to complete the vector
# m %>% group_by(b) %>% mutate(consecutive=c(diff(a),1)<=2)
# 
# # other potentially useful bind functions
# # rbind.fill
# 
# # rbindList
# 
# # smartbind
