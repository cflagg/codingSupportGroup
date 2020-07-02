
df_out <- "your L0 dataframe with too many records" #mine had 16587 rows

filesplit <- data.frame("count"=seq(1,166,by=1), "from"=seq(1, (166*100), by=100), "to"=seq(100, (166*100), by=100))

for(i in 1:nrow(filesplit)){
  write.table(df_out[filesplit$from[i]:filesplit$to[i],], paste(filepath, "_", filesplit$count[i], '.txt', sep=''), 
              sep="\t", row.names = FALSE)
  print(filesplit$count[i])
}
                        