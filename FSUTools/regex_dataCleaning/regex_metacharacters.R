# regex functions can be pretty nuanced if you use metacharacters
# http://stackoverflow.com/questions/2969315/rhow-to-get-grep-to-return-the-match-rather-than-the-whole-string?rq=1

alice <- c("T.8EFF.SP.OT1.D5.VSVOVA#4",   
"T.8EFF.SP.OT1.D6.LISOVA#1",  
"T.8EFF.SP.OT1.D6.LISOVA#2",   
"T.8EFF.SP.OT1.D6.LISOVA#3",  
"T.8EFF.SP.OT1.D6.VSVOVA#4",    
"T.8EFF.SP.OT1.D8.VSVOVA#3",  
"T.8EFF.SP.OT1.D8.VSVOVA#4",   
"T.8MEM.SP#1",                
"T.8MEM.SP#3",                      
"T.8MEM.SP.OT1.D106.VSVOVA#2", 
"T.8MEM.SP.OT1.D45.LISOVA#1",  
"T.8MEM.SP.OT1.D45.LISOVA#3")

######## GOAL: extract the numeric value after the "D" from each string, only if it also contains the string "LIS" 

#### Method 1) using base R sub()
# create the pattern to match
pat <- ".*\\.D([0-9]+)\\.LIS.*" ## 1st: whatever precedes .*\\2nd: "D#" \\ 3rd: ".LIS.*"

# This is called tagging? https://books.google.com/books?id=grfuq1twFe4C&lpg=PP1&pg=PA99#v=onepage&q=unescaped&f=false
# sub(pattern, replacement string, input)
sub(pat, "\\1", alice)

# only return the subset that contains the numeric value
sub(pat, "\\1", alice[grepl(pat, alice)])

# return the entire string that contains the specific pattern
alice[grepl(pat, alice)]


#### Method 2) stringr
library(stringr)
str_match(alice, pat)[, 2]



# http://stackoverflow.com/questions/14146362/regex-extract-string-between
# how to grab values after "D" only
mystrings <- c("X2_D2_F4",
               "X10_D9_F4",
               "X3_D22_F4",
               "X9_D22_F9")

gsub("(^.+_[A-Z]+)(\\d+)(_.+$)", "\\2", mystrings)





# meta-character approach
test <- c("l_22_2_20130709", "l_2_22_2013","l_22_22_20130709","l_2_2_20130709")

".*\\.D([0-9]+)\\.LIS.*"

pat = "_*\\._([0-9]_+)\\*"


# will collapse the underscores - "\\1" returns first group of regex matches, "\\2" returns the second group and so on
# groups are separated by parentheses
sub(pat, "\\1", test)

test[grepl(pat,test)]

# a simpler example
test2 <- c ("l_22_x3", "l_23_x3","l_24_x3")

# this works, use the parentheses to describe how the values are "encapsulated"
# 1) the value is preceded by a bunch of values and an underscore, the second piece is just numbers, the third piece begins with an underscores 
# and ends after that
pat2 = "(^.+_)(\\d+)(_.+$)" 
sub(pat2, "\\2", test2) # return the second piece, i.e. what's in the second parenthesis set


sub(pat2, "\\2", test) # this returns the second set of numbers in the underscores, not the first

# define full pattern for test dataset
pat3 = "(^.+_)(\\d+)(_)(\\d+)(_.+$)" 
sub(pat3, "\\2", test) # take the second chunk
sub(pat3, "\\4", test) # take the fourth chunk



