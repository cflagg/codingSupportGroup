## for matching multiple key values between two tables
# in file: clip_soil_align_concept.Rmd


# function source:  http://stackoverflow.com/questions/24766104/checking-if-value-in-vector-is-in-range-of-values-in-different-length-vector 
# apply loop source:  http://stackoverflow.com/questions/15059076/call-apply-like-function-on-each-row-of-dataframe-with-multiple-arguments-from-e
# this works for one column
getClipID2 <- function(xCoord, yCoord,lookup){
  # for each piece
  tmp <- lookup %>% 
    # find a single row that matches this condition for each input row
    # IF <= then results sometimes return 2 clipIDs; see stackexchange link for fixing this
    dplyr::filter(topEasting > xCoord, bottomEasting < xCoord, topNorthing > yCoord, bottomNorthing < yCoord)
  # dplyr::filter(topEasting >= xCoord, bottomEasting <= xCoord)
  # return the clipID number
  return(tmp$clipCellNumber)
}

## will this work for two columns?
##this: http://stackoverflow.com/questions/15059076/call-apply-like-function-on-each-row-of-dataframe-with-multiple-arguments-from-e
## apply(input_data, 1 = perform function on each input row, function(x) run this function)
## apply getClipID2 function to every input row; X = input data ARRAY/MATRIX
s2 <- apply(X = s1[,c(2,3)], 1, function(x) getClipID2(x["X21x"], x["X21y"], lookup = clipCoord21))
