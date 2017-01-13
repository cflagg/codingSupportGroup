# http://adv-r.had.co.nz/Exceptions-Debugging.html

# setup a vector of values to be assessed by if(), 
# NA is not a valid input for if(), so it will abort the if() evaluations at the NA
# which ends up skipping evaluation of the last three values of vector x
x <- c(TRUE, TRUE, FALSE, NA, TRUE, TRUE, FALSE)

# Situation 1: no try() means the loop is aborted
# try this, the entire 
for (i in x){
  # print(paste('iterator:', i))
  if (i == TRUE){
    print('TRUE!')
  }  else {
    print('FALSE!')
  } # if closer
} # for closer


# Situation 2:
# with try() function, embed the if() code within the try({...}); 
# failure to eval the if() will 'continue' the loop rather than aborting
  for (i in x){
    # print(paste('iterator:', i))
      try({
          if (i == TRUE){
          print('TRUE!')
        }  else {
          print('FALSE!')
        } # if closer
      }) # try closer
  } # for closer


# Situation 3: since the try is now directed towards the for loop, 
# the if() eval failure still aborts the entire loop
try({
  for (i in x){
    # print(paste('iterator:', i))
    if (i == TRUE){
      print('TRUE!')
    }  else {
      print('FALSE!')
    } # if closer
  } # for closer
})

is.error <- function(x) inherits(x, "try-error")
