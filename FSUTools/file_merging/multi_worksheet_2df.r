library(readxl)
library(data.table)

read_excel_allsheets <- function(filename) {
  sheets <- readxl::excel_sheets(filename)
  x <-    lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  names(x) <- sheets
  return(x)
}

mysheets <- read_excel_allsheets("C:/your/filepath")
#mysheets <- read_excel_allsheets("C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/file_merging/multi_worksheet_ex.xlsx")

#mysheets <- read_excel_allsheets("H:/Phenology/Species selection/task_1b_cohort_two_preliminary_selection_6Jan2016.xls")

newDF <- rbindlist(mysheets, fill=TRUE)
