# source: http://www.biostat.jhsph.edu/~rpeng/docs/R-debug-tools.pdf
# vectorized  sum of squared differences
# mu = single number; x = a vector of numbers
SS <- function(mu, x){
  d <- x - mu
  d2 <- d^2
  ss <- sum(d2)
  ss
}

# 
SS(1,rnorm(100))


# but what does this do?
SS(c(1), rnorm(100))
debug(SS)
SS(c(1,2), rnorm(100))
undebug(SS)


