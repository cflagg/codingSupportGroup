# data checker script

# 1) load data
file1 <- read.csv("//10.100.128.37/dropbox/2015data/D02/vst_other_D02.csv", header=T) # D06 file labeled as D02 file?
file2 <- read.csv("//10.100.128.37/dropbox/2015data/D06/sls_moisture_D06.csv", header=T) 
file3 <- read.csv("//10.100.128.37/dropbox/2015data/D02/vst_mapping_D02.csv", header=T) # D06 file labeled as D02 file?
file4 <- read.csv("//10.100.128.37/dropbox/2015data/D06/sls_soilcorecollection_D06.csv", header=T)

# 2) compare the same columns from each data frame
checkList1 <- list() # create an empty list to store results
checkList2 <- list() # create an empty list to store results

# first two files
for (column in colnames(file1)){
  #print(column) # test the loop
  print(table(file1[,column] %in% file2[,column])) # print if all values from file1 are in file2's columns
  checkList2[column] <- list(data.frame(file1 = file1[,column], file2 = file2[,column])) # store values from each file in the same list element, for checking
}

# second set of files
for (column in colnames(file3)){
  #print(column) # test the loop
  print(table(file3[,column] %in% file4[,column])) # print if all values from file3 are in file4's columns
  checkList2[column] <- list(data.frame(file3 = file3[,column], file4 = file4[,column])) # store values from each file in the same list element, for checking
}

# 3) what are the results?
erer::write.list(checkList1)
erer::write.list(checkList2)
