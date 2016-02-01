### The function "sampleNum" calculates sample sizes "n" required to estimate a variable to within 10% (±5%), 20% (±10%), and 30% (±15%) of the mean, at 80%, 90%, and 95% confidence for a 2-tailed distribution. The user must supply "stdev" and "average" for a sampled population, and the single-sided "plot.size" in meters used to obtain the "stdev" and "average" values, if known and relevant. If a "plot.size" variable is provided, the function calculates the total area that must be sampled.

###	NB: The equations used here assume the variable of interest is normally distributed. Sample-size estimates can be significantly influenced if this assumption is not met.


sampleNum = function(stdev, average, plot.size=NA){

## Calculate the coefficient of variation from the standard deviation and mean
CV = stdev/average


##	Calculate plot.area in hectares from plot.size in meters
plot.area = plot.size^2/10000


## Create vector of t-statistics associated with 2-tailed cumulative probabilities that equal 80%, 90%, and 95%, and assuming df=infinity. Values were taken from http://en.wikipedia.org/wiki/Student's_t-distribution
t.2tail = c("80%"=1.282, "90%"=1.645, "95%"=1.960)


##	Define levels of error "E" for which sample-size "n" is desired
E = c(0.1, 0.2, 0.3)


## Define an empty matrix to hold sample number "n" values and "total area sampled" corresponding to range of errors contained in "E" above, for each value of "t.2tail" vector.
n.mat = matrix(data=NA, nrow=length(E)*length(t.2tail), ncol=2)
colnames(n.mat) = c("n","tot.ha")


##	Define "error", "CI.2tail", and "t.stat" vectors, and combine into a data.frame with n.mat above.
error = rep(E, times=length(t.2tail))
CI.2tail = rep(names(t.2tail), each=length(E))
t.stat = as.numeric(rep(t.2tail, each=length(E)))
temp.df = data.frame(error, CI.2tail, t.stat, n.mat, stringsAsFactors=FALSE)


##	Calculate sample-size "n" required for defined levels of "error" and associated values of "t.stat"; use "n" values to calculate total area sampled with user-defined "plot.size".
temp.df$n = temp.df$t.stat^2*CV^2/temp.df$error^2

#	Employ "if/else" statement to inform user if plot.size was not supplied; if plot.size is supplied, then calculate total area sampled in hectares.
if (is.na(plot.size)){
print("A value for plot.size was not entered, so total area sampled cannot be calculated.")

} else {
temp.df$tot.ha = temp.df$n*plot.area

#	End of "if/else" statement bracket
}


##	Plot curves showing sample size "n" as a function of acceptable error, with a separate curve for each level of confidence specified in "t.2tail"

#	Create empty plot to contain curves
plot(temp.df$error, temp.df$n, type="n", xlab="Error (proportion of mean)", ylab="Sample size (n)", xlim=c(0.05, max(temp.df$error)), ylim=c(0, max(temp.df$n)+5), main="Relationship between error and sample size\nat various levels of confidence")

#	Employ "for" loop to plot curves for each value of "t.2tail"
for (i in 1:length(t.2tail)){
curve(t.2tail[i]^2*CV^2/x^2, 0.05, max(E), col=i, add=TRUE)
#	End of "for" loop
}

# Add lines to the plot that illustrate the location of the "n" value associated with acceptable error = 20% at a 95% confidence level.
v.x = c(0.2,0.2)
v.y = c(-1, temp.df[which(temp.df$error==0.2 & temp.df$CI.2tail=="95%"),"n"])
lines(v.x, v.y, col="gray60", lty=1)
h.x = c(0,0.2)
h.y = c(temp.df[which(temp.df$error==0.2 & temp.df$CI.2tail=="95%"),"n"], temp.df[which(temp.df$error==0.2 & temp.df$CI.2tail=="95%"),"n"])
lines(h.x, h.y, col="gray60", lty=1)

# Add a point to the plot that illustrates the location of the "n" value for acceptable error = 20% of the mean at a 95% confidence level.
points(0.2, temp.df[which(temp.df$error==0.2 & temp.df$CI.2tail=="95%"),"n"], pch=21, bg="gray80")

# Create legend based on confidence levels contained in "t.2tail"
legend("topright", c("95% conf (alpha/2=0.025)", "90% conf (alpha/2=0.05)", "80% conf (alpha/2=0.10)"), col=c("green", "red", "black"), title="Confidence level (2-tail)", lty=1, cex=0.8)


##	Clean up "temp.df" to return to user
temp.df$n = ceiling(temp.df$n)
temp.df$tot.ha = round(temp.df$tot.ha, digits=2)
return(temp.df)

#	End of function bracket
}






#=========================================================================================
#Code testing
#=========================================================================================
#average = 0.8245893
#stdev = 0.2568533
#plot.size = 20


