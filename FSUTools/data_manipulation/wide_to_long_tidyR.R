# tidyR tutorial from Garrett Groleman
library(tidyr)
library(devtools)
# devtools::install_github("garrettgman/DSR")
library(DSR)

# grammar: spread(), gather(), separate(), unite()

# easily calculate TB rates with already tidy data
table1$rates <- with(table1, 10000*(cases/population))

# spread - turns key:value columns into set of tidy columns
# returns dataset that has key:value columns removed, distributing unique valued
# columns in their place. 
spread(table2, key, value)

# gather - does the opposite of spread()
# turns key and value columns into key:value pairs

names(table4)
gather(table4, "year", "cases", 2:3) # collapses columns 2:3 into single "value" column

gather(table5, "year", "population", 2:3)

# separate() multiple values in the same column
separate(table3, rate, into=c("cases", "population"))

# how to split stupid soccer data
xc <- data.frame(scores = c("1-1", "2-1", "1-2"))
separate(xc, scores, into = c("Home", "Away"), sep = "-")


# unite() multiple columns into one column
unite(table6, "new", century, year, sep = "")


# gather the columns into a new format, defining columns 5:60 as containing data values
who2 <- gather(who, "code","value",5:60)

# PASS 1 - split the code column into three new columns 
who2 <- separate(who2, code, c("new", "var","sexage"))

# PASS 2 - split sexage into two columns
who2<- separate(who2, sexage, c("sex", "age"), sep = 1)

# split var (key column) into new columns with individual values
who2 <- spread(who2, var, value)
