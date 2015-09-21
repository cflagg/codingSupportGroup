file_path <- "C:/Users/cflagg/Documents/Test/plantdiversity/csv"

file_list <- list.files(file_path, full.names = TRUE)

file_list <- file_list[grep(".csv",file_list)]

library(stringr)

# this is a function with two inputs - the file list and the type of plyr operation
# the file list here should point to "fileGrab1" for this specific script
# multipleCombine <- function(input, ply = llply){
#   ply(input, function(x){
#     t <- read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE) # read the csv
#     t1 <- rbind(t) # rbind it to a temporary variable
#     return(t1) # return the full variable
#   }
#   )
# }


# modification of file stacker, this only takes the first six lines, parses the character vectors for key info
multipleCombine <- function(input, ply = llply){
  ply(input, function(x){
    t <- read.csv(x, header=TRUE, sep=",",stringsAsFactors = FALSE)[c(1:6),] # read the csv
    t1[1,1] <- str_extract(t[2], pattern = "[A-Z]{1}[0-9]{2}") # domain
    t1[1,2] <- str_extract(t[3], "[A-Z]{4}$") # site
    t1[1,3] <- str_extract(t[4], pattern = "[A-Z]{4}_[0-9]{3}") # plotID
    t1[1,4] <- str_extract(t[1], pattern = "[0-9]{4}-[0-9]{2}-[0-9]{2}$")# date
    t2 <- rbind(t1)
    names(t2) <- c("domainID", "siteID", "plotID", "date")
    return(t2) # return the full variable
  }
  )
}

t1 <- data.frame()
sav <- multipleCombine(file_list, ply = ldply)

sav %>% ddply(.(domainID), summarize, nc = length(plotID))

# D10 seems to have a lot of plot entries compared to other domains
sav %>% filter(domainID == "D10")

sav %>% filter(siteID %in% c("TREE", "UNDE")) %>% arrange(plotID) -> D5_plots

write.csv(D5_plots, file = "C:/Users/cflagg/Documents/Test/D5_diversity_plots_review.csv")

# # 1) read it in
# test1 <- read.csv(file_list[1],stringsAsFactors = FALSE)[c(1:6),]
# 
# # 2) extract the info
# # grab the dates
# str_extract(test1[1], pattern = "[0-9]{4}-[0-9]{2}-[0-9]{2}$")
# # grab the plots
# str_extract(test1[4], pattern = "[A-Z]{4}_[0-9]{3}")
# # grab the domain
# str_extract(test1[2], pattern = "[A-Z]{1}[0-9]{2}")
# # grab the site code
# str_extract(test1[3], "[A-Z]{4}$")
# 
# # 3) store as a record in a data.frame
# store <- data.frame()
# 
# store[1,1] <- str_extract(test1[2], pattern = "[A-Z]{1}[0-9]{2}") # domain
# store[1,2] <- str_extract(test1[3], "[A-Z]{4}$") # site
# store[1,3] <- str_extract(test1[4], pattern = "[A-Z]{4}_[0-9]{3}") # plotID
# store[1,4] <- str_extract(test1[1], pattern = "[0-9]{4}-[0-9]{2}-[0-9]{2}$")# date
# 
# names(store) <- c("domainID", "siteID", "plotID", "date")
# 
