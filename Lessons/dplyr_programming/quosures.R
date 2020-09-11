### programming functions with dplyr: bang bang and quosures
# in particular, examples of how to specify multiple column names when using dplyr functions within a custom function
#### https://www.r-bloggers.com/bang-bang-how-to-program-with-dplyr/
#### https://tidyeval.tidyverse.org/dplyr.html using vars(column_names, ...) and !!! 
##### using curly braces https://dplyr.tidyverse.org/articles/programming.html
##### more bullshit https://stackoverflow.com/questions/57007865/specifying-multiple-variables-to-group-by-via-explicit-argument-with-unquoted-el
##### https://stackoverflow.com/questions/52718604/passing-a-list-of-arguments-to-a-function-with-quasiquotation
#### http://rstudio-pubs-static.s3.amazonaws.com/328769_e8a0152e155b4163b4a54473adcea229.html

library(dplyr)
library(rlang)

#### First Method ####
## practice quosures
# group twice
fxq <- function(data, group_var, event_var = NULL){
  
  data %>% 
    dplyr::group_by(!!! group_var, !!! event_var) %>% 
    dplyr::summarise(record_count = n())
  
}

## this requires the user to encapsulate inputs inside `vars()`, which is lame and not intuitive
fxq(mtcars, group_var = vars(am, hp), event_var = vars(cyl))

#### Second Method - single column specification only ####
#### try yet another way, using curly braces (doesn't seem to work with more than one column passed to group_var)
fxq2 <- function(data, group_var, event_var = NULL){
  
  data %>% 
    dplyr::group_by({{group_var}}, {{event_var}}) %>% 
    dplyr::summarise(record_count = n())
  
}

## this method only allows for a single column to be specified, so not ideal for complex operations
fxq2(mtcars, group_var = am, event_var = cyl)

#### Alternate Second Method ####
## a lot of people make the suggest of using an ellipsis to pass multiple inputs
## I think this approach is kind of crummy/lazy because nameless/anonymous function arguments are extremely rare and/or not intuitive
#### Second method ####
#### try yet another way, using curly braces (doesn't seem to work with more than one column passed to group_var)
fxq2b <- function(data, summary_var, ...){
  
  group_var <- enquos(...)
  
  data %>% 
    dplyr::group_by(!!! group_var) %>% 
    dplyr::summarise(mean_val = mean({{summary_var}}))
  
}

## this method allows for multiple columns to be selected...but only for one operation (as the ellipsis inputs get passed to a single intermediate variable "group_var")
fxq2b(mtcars, summary_var = hp, am, cyl)


#### third way - pass character vector as input ####
#### try yet another way -- using rlang::syms and quoted column names
### https://stackoverflow.com/questions/34487641/dplyr-groupby-on-multiple-columns-using-variable-names
fxq3 <- function(data, group_var){
  
  data %>% 
    dplyr::group_by(!!!syms(group_var)) %>% 
    dplyr::summarise(record_count = n())
  
}

## here we specify multiple column names via strings in a character vector
fxq3(mtcars, group_var = c('cyl', 'am'))

#### fourth method - pass symbols ####
### https://stackoverflow.com/questions/52718604/passing-a-list-of-arguments-to-a-function-with-quasiquotation
fxq4 <- function(df, sum_var, group_var) {
  sum_var <- enquo(sum_var)
  ## "The reason why I use substitute is that it makes it easy to split the expression list(cyl, gear) in its components"
  ## the rlang:: method is to use syms()
  ## substitute essentially allows passing an unquoted variable name that doesn't exist in the global environment e.g.
  ## gvar <- substitute(c(cyl, am)) # works
  ## gvar <- c(cyl, am) # doesn't work since 'cyl' and 'am' don't exist in environment
  group_var    <- as.list(substitute(group_var))[-1L]
  return(
    df %>% 
      group_by_at(.vars = as.character(group_var)) %>% 
      summarize(sum(!! sum_var))
  )
}

## here we specify multiple column names via 'symbols'
fxq4(mtcars, sum_var = hp, group_var = c(cyl, am))

