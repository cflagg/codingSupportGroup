# for summarizing reported webUI errors
library(plyr)
library(dplyr)

# webUI error report -- GitHub NeonInc Folder:: organismalIPT > scienceDev/dataEntryErrorLog
weberr <- read.csv("C:/Users/cflagg/Documents/GitHub/organismalIPT/scienceDev/dataEntryErrorLog/Known data entry errors (Responses) - Form Responses 1.csv",header=T)

# domain to siteID mapping
d_look <- read.csv("C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/reporting_scripts/DomainID_SiteID_lookup.csv", header=T)

# join with domainID codes
weberr <- left_join(weberr, d_look, by = c("SiteCode" = "siteID"))

# domain level errors
ddply(weberr, .(domainID, SiteCode), summarize, n_err = length(SiteCode))

# protocol-level errors
ddply(weberr, .(Protocol), summarize, n_err = length(SiteCode))

# protocol by siteID
ddply(weberr, .(domainID, SiteCode, Protocol), summarize, n_err = length(SiteCode))

# 
write.csv(x = , file = "C:/Users/cflagg/Documents/GitHub/codingSupportGroup/FSUTools/report_outputs")