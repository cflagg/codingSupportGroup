## stem check
library(plyr)
library(dplyr)

app <- read.csv("Z:/2015data/D02/vst_apparentindividual_D02.csv")


nm <- names(app)

nm

table(app$tagID)


app2 <- ddply(app, ~tagID, mutate, stemCount = length(tagID))

write.csv(x = app2, file = paste(getwd(),"D02_vst_appInd_stemCount.csv", sep=""))
