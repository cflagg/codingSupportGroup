
# data as data frame and column
x <- data.frame('str'=rep("CPER_001_21_M_6_39_20140101", 100))

# data as character vector
xa <- rep("CPER_001_21_M_6_39_20140101", 100)
x_sp <- stringr::str_split(xa, "_")
plyr::ldply(x_sp)[5:6]

stringr::str_split(x,"_")
x$x <- plyr::ldply(x_sp)[5]
x$y 

# if the input is a column or data frame, this is vectorized over the entire object (returns all)
x$x <- str_split(x$str,'_')[[1]][5]
x$y <- str_split(x$str,'_')[[1]][6]

head(x)

# if the input is a character vector, this is not vectorized over the entire object (returns first element)
stringr::str_split(xa, "_")[[1]][5]

