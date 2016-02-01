# a recursive function
f <- function(x, ...)
{
  # browser()
  dots <- list(...)                   #1
  if(length(dots) == 0) return(NULL) 
  cat("The arguments in ... are\n")
  print(dots)
  f(...)                              #2
}

f(1,2,3,"a", list("monkey"))
