# lookup table operations

# source: http://stackoverflow.com/questions/8433523/creating-a-new-variable-from-a-lookup-table

# Original data
dat <- data.frame(
  presult = c(rep("I", 4), "SS", "ZZ"),
  aresult = c("single", "double", "triple", "home run", "strikeout", "home run"),
  stringsAsFactors=FALSE
)

# create the lookup table (lut)
lookup= data.frame( 
  base=c(0,1,2,3,4), 
  aresult=c("strikeout","single","double","triple","home run"))

########################################################################################
# data = data that you are appending to
# lookup = lookup table that contains data you want to match
# new_column = data that you want to append, from lookup table
# match_column = column that is shared by both data frames, used to match up values correctly

# 1) Use Indexing 
# use a named numeric vector
score <- c(single=1, double=2, triple=3, `home run`=4,  strikeout=0)

# Now Align data with Index:  to match data from score to dat - index by source data$column
# syntax: data$new_column <- lookup[data$match_column]
dat$base <- score[dat$aresult]

# 2a) Use Match
# syntax: data$new_column <- lookup$source_column[match(data$match_column, lookup$match_column)]
dat$base<- lookup$base[match(dat$aresult, lookup$aresult)]


# 3a) Use merge
# source, destination, matching column
merge(lookup, dat, by ='aresult')

# 3b) Join with plyr
# syntax: join(data, lookup, by = "match_column")
plyr::join(dat,lookup,by ='aresult')

# 3c) Use dplyr::left_join




