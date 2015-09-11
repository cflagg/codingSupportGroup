# How to make a ggplot gantt chart
# http://stackoverflow.com/questions/3550341/gantt-charts-with-r
# alternative: https://nsaunders.wordpress.com/2010/04/14/plotting-time-of-day-data-using-ggplot2/
# http://stackoverflow.com/questions/28034541/plotting-presence-absence-data
# http://stackoverflow.com/questions/27968853/making-a-presence-absence-timeline-in-r-for-multiple-y-objects

# this doesn't work with multiple occurrences for the same factor level
library(reshape2)
library(ggplot2)

tasks <- c("Review literature", "Mung data", "Stats analysis", "Write Report")
dfr <- data.frame(
  name        = factor(tasks, levels = tasks),
  start.date  = as.Date(c("2010-08-24", "2010-10-01", "2010-11-01", "2011-02-14")),
  end.date    = as.Date(c("2010-10-31", "2010-12-14", "2011-02-28", "2011-04-30")),
  is.critical = c(TRUE, FALSE, FALSE, TRUE)
)

mdfr <- melt(dfr, measure.vars = c("start.date", "end.date"))

ggplot(mdfr, aes(value, name, colour = is.critical)) + 
  geom_line(size = 6) +
  xlab(NULL) + 
  ylab(NULL)

## graphing
sites <- unique(sched3$siteID)


# alternative solution: # http://stackoverflow.com/questions/27968853/making-a-presence-absence-timeline-in-r-for-multiple-y-objects
require(ggplot2)
require(dplyr)
# input your data (changed to 2014 dates)
dat <- structure(list(Tag = c(1L, 3L, 1L, 2L, 3L, 5L, 2L, 3L, 4L, 6L, 1L, 2L, 4L, 6L, 1L, 2L, 3L, 4L, 6L, 2L, 4L, 1L, 2L, 6L), 
                      Date = structure(c(1L, 1L, 2L, 2L, 2L, 2L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 7L, 7L, 7L), 
                                       .Label = c("1/1/2014", "1/3/2014", "1/4/2014", "1/5/2014", "1/6/2014", "1/7/2014", "1/8/2014"), 
                                       class = "factor")), 
                 .Names = c("Tag", "Date"), 
                 class = "data.frame", 
                 row.names = c(NA, -24L))

# change date to Date format
dat[, "Date"] <- as.Date(dat[, "Date"], format='%m/%d/%Y')
# adding consecutive tag for first day of cons. measurements
dat <- dat %>% group_by(Tag) %>% mutate(consecutive=c(diff(Date), 2)==1)
# plotting command

ggplot(dat, aes(Date, Tag)) + geom_point() + theme_bw() +
  geom_line(aes(alpha=consecutive, group=Tag)) +
  scale_alpha_manual(values=c(0, 1), breaks=c(FALSE, TRUE), guide='none')

