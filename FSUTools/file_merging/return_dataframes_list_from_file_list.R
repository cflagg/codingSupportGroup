library(plyr)
library(stringr)
library(XLConnect)

# the directory
dirs <- "Z:/2015data/D02"

# list files with full path
fileList <- list.files(dirs, full.names = TRUE)

# go from list to list -- only works if they're a .csv
stuff <- llply(fileList, function(x){
  file_type <- stringr::str_sub(x, -3, -1)
  print(file_type)
  if (file_type == "csv"){
  t <- read.csv(x, header = T)
  } else if (file_type == "lsx"){
  t <- readWorksheet(loadWorkbook(x), sheet = 1, header = TRUE)}
})

# each list member is a data frame via indexing with DOUBLE BRACKETS [[]] :
str(stuff[3]) # is a list with one member, our data frame

str(stuff[[3]]) # is a data frame
