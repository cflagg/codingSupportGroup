## list recursion
# recursively loop through nested lists: https://stackoverflow.com/questions/29818918/looping-nested-lists-in-r

# go through list
# if length of nested element is greater than 1...
# Recursive function that goes through a nested list, for each unique element within the list, just return the values of that element...if it's another list, go down a level
foo <- function(i){
    lapply(i, function(x) {
        if (is.list(x)){
            foo(x) # if you hit another list, re-use this function!
        } else {
            return(x) # if it's not a list, return the object values
        }
    })
}

## list with 3 levels
x <- list(a = c(1,2,3), b = c(4,5,6), 
          c = list(x = c(9,8,7), y = c("a", "b"), 
                   z = list(zztop = "PlayBoyCarti")))

## add a fourth nested layer WITHOUT HAVING TO MODIFY FUNCTION
xx <- x <- list(a = c(1,2,3), b = c(4,5,6), 
                c = list(x = c(9,8,7), y = c("a", "b"), 
                         z = list(zztop = "PlayBoyCarti", yet_another_list=list(blah= c(7,7,7)))))


# try it out
foo(x)

foo(xx)


## a real example, what if an lapply() or mapply() returns a mix of NULLs, server fail requests (as a vector), and data.frames?
## 

## 3 level list, only want to return data.frames
y <- list(list("404 - Server Not Found", NULL, data.frame(a = c(1,2,3), b = c("a", "b", "c"))), 
          list(data.frame(a = c(1,98,99), b = c("x", "y", "z")), 
               list(data.frame(zz = 1:10, top = 1:10), "301 - Request Rejected Fool!")))

bar <- function(i){
    lapply(i, function(x) {
        if (is.data.frame(x)){
            return(x)
        } else if (is.list(x)) {
            bar(x)
        } 
    })
}

bar(y)
