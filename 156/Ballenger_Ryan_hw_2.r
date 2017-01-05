


#1
#setwd("/Users/Ryan/Desktop/math156")

# load states data
states <- read.csv("States03.csv")

# scatter plot teachers pay and HS graduation rates
plot(states$HSGrad ~ states$TeachersPay, main="HS Grad Rates and Teachers Pay", xlab="Teachers' Pay", ylab="HS Grad. %")

# add a red vertical line at the mean teachers' pay
abline(v = mean(states$TeachersPay), col="red")

# add a blue horizontal line at the mean HS graduatio rate
abline(h = mean(states$HSGrad), lty = 2, col="blue")





#####
#2 (#6 on pg. 31)
spruce <- read.csv("Spruce.csv")
	
#2a) numeric summares include the center, spread, and shape
# the center - mean and median
# pg. 17 of the text: Two statistics commonly used to describe the center include the mean and median.
heightChangeMean = mean(spruce$Ht.change)
heightChangeMean
heightChangeMedian = median(spruce$Ht.change)
heightChangeMedian

# spread - standard deviation
# to describe the spread I use the standard deviation which the text says is a common choice 
heightChangeSD = sd(spruce$Ht.change)
heightChangeSD 

# shape - 5-number summary which includes the min., 1st quartile, median, 3nd quartile, and max. value
# the text also suggests this to describe the shape, over using the skewness and kurtosis (pg.19)
heightChangeSummary = quantile(spruce$Ht.change)
heightChangeSummary

#2b)
# histogram and normal quantile plot for the height changes
hist(spruce$Ht.change)
qqnorm(spruce$Ht.change)
# Is the distribution approximately normal?
# Yes, it is approx. normally distributed because a near straight line is formed in the normal quantile 
# plot that follows the qqline(), if plotted, of that data set

#2c)
# diameter change of spruces in a boxplot grouped by fertilizer or no fertilizer
boxplot(spruce$Di.change ~ spruce$Fertilizer, ylab="Diameter Change", xlab="Fertilizer", main="Fertilizer and Diameter")

#2d)
# numeric summaries are center, spread, shape
# center - mean and median for the reason explained in #2a
tapply(spruce$Di.change, spruce$Fertilizer, FUN=mean)
tapply(spruce$Di.change, spruce$Fertilizer, FUN=median)

# spread which is described by the  standard deviation
tapply(spruce$Di.change, spruce$Fertilizer, FUN=sd)

# shape which is described by the 5-number summary
tapply(spruce$Di.change, spruce$Fertilizer, FUN=quantile)

#2e)
# plot of height changes against diameter changes
plot(spruce$Ht.change, spruce$Di.change, main="Tree Growth")
# There is a linear relationship or correlation showing that as trees grow taller, 
# they also grow wider.





#####
#3
#3a) 
# plotting the curve of the density function for Student's t 
curve(dt(x, 6), from=-3, to=3, main="Student's T and Normal Densities", ylab="Density")
# plot the curve of the density function for standard normal distribution 
curve(dnorm(x), from=-3, to=3, col="green", add=TRUE)
# add a legend to designate color
legend(1.5,.35, c("Normal","Student's t"), lwd=c(2.5,2.5),col=c("green","black")) 

#3b) 
# add vertical lines at .1 and .9 quantiles for both student's t and normal distributions
# .1 and .9 quantiles are determined with qnorm and qt respectively
abline(v=qnorm(.1), col="green")
abline(v=qnorm(.9), col="green")
abline(v=qt(.1, 6))
abline(v=qt(.9, 6))

#3c)
# student t's and normal distributions plotted with .1 and .9 hornizontal lines
# to estimate the quantiles
curve(pt(x, 6), from=-3, to=3, main="Student's T and Normal Distributions")
curve(pnorm(x), from=-3, to=3, col="green", add=TRUE)
abline(h=.1, col="green")
abline(h=.9, col="green")
abline(h=.1)
abline(h=.9)
legend(1.5,.35, c("Normal","Student's t"), lwd=c(2.5,2.5),col=c("green","black")) 
# estimate of .1 and .9 quantile
# student t: -1.5 and 1.5
# normal: -1.3 and 1.3

#3d)
# plot the quantile function for student's t and normal distributions
curve(qt(x, 6), from=0, to=1, ylim=c(-3,3), main="Quantile Functions", xlab="Quantiles")
curve(qnorm(x), from=0, to=1, col="green", add=TRUE)
# straight lines are added at the .1 and .9 quantiles
abline(v=.1, col="green")
abline(v=.9, col="green")
abline(v=.1)
abline(v=.9)
legend(.2,3.5, c("Normal","Student's t"), lwd=c(2.5,2.5),col=c("green","black")) 
# estimates of .1 and .9 quantiles
# student's t: -1.5 and 1.5
# normal: -1.3 and 1.3

#3e)
# a sample of 1000 deviates is found
sample = rt(1000,6)
# a sequence of 200 equally spaced intervals
p200 = seq(0.005, 0.995, by = 0.005)
# qqnorm is found using the 200 equally spaced quantiles from the sample of 1000
qqnorm(quantile(sample,p200))
# lastly the qqline is added to the above plot 
qqline(quantile(sample,p200))

# the student's t distribution is similar to the normal distribution. The qqplot shows
# the points are near the qqline. Some variation shows the distributions differ though, as
# the student's t has heavier tails than the normal distribution. This is shown by the 
# sample quantiles reaching further away from center than the qqline.





#####
#4

FD <- read.csv("FlightDelays.csv")

#4a) determine the skewness of delays
# calculate the 1st moment, the variance, the standard deviation, 
# the 3rd central moment, and finally the skewness as in script 2c.
mu<-mean(FD$Delay); mu 
MC2 <- mean((FD$Delay-mu)^2); MC2
sigma<- sqrt(MC2); sigma
MC3 <- mean((FD$Delay-mu)^3); MC3
skewness <-MC3/sigma^3; skewness 

#b
# confirm the kurtosis of student's t with 6 degrees of freedom is 3.
# use the integrate function to find the 2nd and 4th moments 
# which are then used to solve for the kurtosis
	integ<-integrate(function(x) x*dt(x,6), -Inf, Inf); integ
	mu<-integ$value; mu
	MC2<-integrate(function(x) (x-mu)^2*dt(x,6), -Inf, Inf); MC2
	sigma<- sqrt(MC2$value); sigma
	MC4<-integrate(function(x) (x-mu)^4*dt(x,6), -Inf, Inf); MC4
	kurtosis <- MC4$value/sigma^4-3; kurtosis





#####
#5
#setwd("/Users/Ryan/Desktop")
NCB= read.csv("NCBirths2004.csv")

# solve for the kurtosis of NC birth wieghts
# find the mean, 2nd and 4th centrol moments, and sigma which are used to solve for kurtosis
X = NCB$Weight
mu <- mean(X); mu
MC2 <- mean((X-mu)^2); MC2 
MC4 <- mean((X-mu)^4); MC4
sigma<- sqrt(MC2); sigma
kurtosis <- MC4/sigma^4-3; kurtosis 

# solve for kurtosis of a normal disribution with the same mean and variance
# as the student's t distribution from part a: mean: 3448.26 and car.: 487.4943
integ<-integrate(function(x) x*dnorm(x, 3448.26, 487.4943), -Inf, Inf); integ
mu<-integ$value; mu
MC2<-integrate(function(x) (x-mu)^2*dnorm(x, 3448.26, 487.4943), -Inf, Inf); MC2
sigma<- sqrt(MC2$value); sigma
MC4<-integrate(function(x) (x-mu)^4*dnorm(x, 3448.26, 487.4943), -Inf, Inf); MC4
kurtosis <- MC4$value/sigma^4-3; kurtosis 

# the data has fatter tails because it has a higher kurtosis value. The kurtosis
# measures the heaviness of the tails, and NC weights higher kurtosis value(.17 vs. -1.92)
# means it has fatter tails than the normal distribution does.





#####
#6
#6a)
# load flight delay data and subset UA and AA flight delays 
FD = read.csv("FlightDelays.csv")	
UADelays = subset(FD$Delay, FD$Carrier == "UA")
AADelays = subset(FD$Delay, FD$Carrier == "AA")
par(mfrow = c(2, 2)) 

# ecdf's for UA and AA lengths of flight delays 
plot.ecdf(UADelays, xlim=c(0,500), main="ECDF of UA Delays", xlab="Delay Length")  
plot.ecdf(AADelays, xlim=c(0,500), main="ECDF of AA Delays", xlab="Delay Length")  

#Comparison: The ecdf plots show that AA has a steaper slope and reaches near 1.0 sooner.
# This means that AA has shorter flight delays that UA. All of AA's flight delays are contained
# in a space closer to 0 than UA's flight delays. This result is verified by simply taking the 
# mean of both: AADelay - 10.1 and UADelay - 16.0. This extra test also shows that AA has 
# shorter flight delays, overall, than UA.

# plot 100 quantiles for .01 to .99. Same as above with the axes changed.
p100 = seq(0.01, 0.99, by = 0.01)
plot(p100,quantile(UADelays,p100), main="Quantiles of UA Delays", xlab="Quantiles", ylab="Delay Length")	
plot(p100,quantile(AADelays,p100), main="Quantiles of AA Delays", xlab="Quantiles", ylab="Delay Length")






















