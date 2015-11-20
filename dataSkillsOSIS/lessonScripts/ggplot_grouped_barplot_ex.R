raw <- read.csv("http://pastebin.com/raw.php?i=L8cEKcxS",sep=",")
raw[,2]<-factor(raw[,2],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)
raw[,3]<-factor(raw[,3],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)
raw[,4]<-factor(raw[,4],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)

raw=raw[,c(2,3,4)] # getting rid of the "people" variable as I see no use for it

freq=table(col(raw), as.matrix(raw)) # get the counts of each factor level

Names=c("Food","Music","People")     # create list of names
data=data.frame(cbind(freq),Names)   # combine them into a data frame
data=data[,c(5,3,1,2,4)]             # sort columns

library(reshape2)
# melt the data frame for plotting
data.m <- melt(data, id.vars='Names')

# plot everything
ggplot(data.m, aes(Names, value)) +   
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")

