x = c(rep("HARV", 4), rep("HARV", 5), rep("HARV", 6), rep("HARV", 3))
y = c(1,1,1,0, 1,1,1,1,0, 1,1,1,1,1,0, 1, 1, 0)

## fake data frame
df = data.frame(site = x, down = y)

## fake group identifier value
groups = LETTERS

## need to start forloop at index 1 ("A")
group_index = 1

## an object to store output data from the for loop
newvec = vector(mode = "character", length = nrow(df))
for (row in 1:nrow(df)){
  
  if (df[row,"down"] == 1){
    # assign, at row, the group_index variable
    newvec[row] = groups[group_index]
    print(groups[group_index])
    
  } else {
    # if it's not, bump the group_index up one
    newvec[row] = NA
    group_index = group_index + 1
    print(group_index)
    ## assign NA and move out of the if
    
  }
}

## do an analysis of frequencies of downtime length
df_count <- data.frame(group = newvec) %>% group_by(group) %>% summarize(hours_down = n())

## should have two bars after filtering out "NA" which equals uptime rows
df_plot <- dplyr::filter(df_count, !is.na(group))
hist(df_plot$hours_down)

df_hist <- df_count %>% group_by(hours_down) %>% summarize(count = n())

hist(as.integer(df_hist$count))
     
