# http://stackoverflow.com/questions/2778510/efficiently-adding-or-removing-elements-to-a-vector-or-list-in-r
# http://rosettacode.org/wiki/Stack#R

# 1) 
# the input data set
dump <- paste(rep("a"),rep(1:14),sep="")

# grow a list by selective criteria with an initialized vector of indeterminate length (slow)
keeper <- NULL
for (i in 1:length(dump)){
  zz <- str_extract(dump[i],"[:digit:]+")
  print(zz)
  if (as.numeric(str_extract(dump[i],"[:digit:]+")) < 10){
    keeper <- c(keeper,dump[i])
  }
}

keeper

# 2)  
## grow a list with an initialized vector of known length (4x faster)
dumper <- rep(NA,9) # initialize a vector first, for storing new data
for (i in 1:length(dump)){
  zz <- str_extract(dump[i],"[:digit:]+")
  print(zz)
  if (as.numeric(str_extract(dump[i],"[:digit:]+")) < 10){
    dumper[i] <- dump[i]
  }
}


## remove an element in a list by selective criteria
## grow a list with an initialized vector
## this loop does some weird stuff if you try to remove "i" directly
# http://r.789695.n4.nabble.com/identifying-odd-or-even-number-td2275447.html
dump <- paste(rep("a"),rep(1:14),sep="")
# function(input){
dumpList <- NULL
for (i in 1:length(dump)){
  # temporarily store the number in the string
  zz <- str_extract(dump[i],"[:digit:]+")
  print(zz)
  # %% 2 == FALSE returns even values, %% == TRUE returns odd values
  if (as.numeric(zz) %% 2 == FALSE){
    #print(dump[i])
    # create a new vector of positions to remove
    dumpList <- c(dumpList,as.numeric(zz))
    # dump <- dump[-as.numeric(zz)] # doesn't work
  }
}

# now remove those positions from the input vector - this would work best iif this was all in a brief function
dump[-dumpList]
# return(dump[-dumpList])
#}


