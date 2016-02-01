library(plyr)
library(stringr)
library(XLConnect)

# the directory
dirs <- "Z:/2015data/D02"

# list files with full path: 
fileList <- list.files(dirs, full.names = TRUE)
# now just grab the file name so we can name each list member:
names(fileList) <- list.files(dirs) 

# function accepts a file list, reads the file, and returns a list of data frames -- works for .csv, .xls, and .xlsx
stuff <- llply(fileList, function(x){
  file_type <- stringr::str_sub(x, -4, -1)
  print(file_type) # print the file type
  # if it's a csv:
  if (file_type == ".csv"){
  read.csv(x, header = T)
  # if it's an xls file
  } else if (file_type == "xlsx" | file_type == ".xls"){
  readWorksheet(loadWorkbook(x), sheet = 1, header = TRUE)}
})

# parse the list and dump everything that isn't prefix = 'vst'
vst_stuff <- stuff[grep(x = names(stuff), pattern = "vst")]

# more parsing by suffix = 'apparent_ind'
# vst_apparent_stuff <- vst_stuff[grep()]

# now ldply it together
# apparent_ind_merge <- ldply(vst_apparent_stuff)

# each list member is a data frame via indexing with DOUBLE BRACKETS [[]] e.g. : 
str(stuff[3]) # is a list with one member, our data frame

str(stuff[[3]]) # is an actual data frame
