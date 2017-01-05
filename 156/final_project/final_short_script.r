# Ryan Ballenger
# Math 156 Final Project - Short Script

setwd("/Users/Ryan/Desktop")

combine = read.csv("combine.csv")


#####
# Required technical elements – analysis and graphical display

### 1. Linear regression
  # (also, A scatter plot with regression line)

# Forty yard dash times and vertical jumps are related. However some athletes
# can jump high, such as defensive lineman, but cannot run quickly. A linear
# regression line is made for the forty and vertical plot. The slop shows
# that people with short forty times tend to have high verticals.  

# The 2012 players who participated in the forty yard dash 
# and in the vertical jump are analyzed. The least squares regression
# technique is used for the linear regresssion.
set = subset(combine, combine$fortyyd != 0 & combine$vertical != 0 & combine$year == 2012)

# The slope of the line is found. 
b <- sum( (set$vertical-mean(set$vertical)) * (set$fortyyd-mean(set$fortyyd)) / sum((set$vertical-mean(set$vertical))^2));b #equation 9.4

# intercept
a <- mean(set$fortyyd) - b*mean(set$vertical);a   #equation 9.5

plot(set$vertical, set$fortyyd, main="Forty and Vertical", xlab="inches", ylab="seconds")

# regression line
abline(a, b, col = "red")


### 3. Bayesian prior updated by data
  # (also, 2. A plot showing Bayesian prior and posterior distributions)

# The SEC conference has won several national championships lately 
# but that does not mean its player are better than others in college
# football. There are complaints that there are too many SEC players
# invited to the combine and a beta distribution will model this probability. 
# A prior is calculated from the percent of SEC combine players from 1999-2009
# during which time the SEC did not have as much momentum. The prior is then 
# updated with the data from 2010 - 2015 since the complaints are regarding 
# recent years. There are 166 players from the SEC and 936 total which is added
# to the beta parameters below. The update does increase the probability 
# beyond the prior rates. The percentage of SEC schools in the FBS is 
# also displayed as a vertical line to represent if all the top schools got
# equal amounts of combine invitees.

rateSEC = numeric(11)

for (i in 1999:2009) {
  SEC = nrow(subset(combine, (combine$college=="Florida" | combine$college=="Georgia" | combine$college=="Kentucky" | combine$college=="Missouri" | combine$college=="South Carolina" | combine$college=="Tennessee" | combine$college=="Vanderbilt" | combine$college=="Alabama" | combine$college=="Arkansas" | combine$college=="Auburn" | combine$college=="LSU" | combine$college=="Mississippi" | combine$college=="Mississippi State" | combine$college=="Texas A&M") & combine$year == i))
  total = nrow(subset(combine, combine$year == i))
  rateSEC[i-1998] = SEC/total
}

E <- mean(rateSEC); V <- var(rateSEC)
alpha <- (E^2 - E^3)/V - E
beta <- alpha/E - alpha

#a Bayesian prior with a given mean and variance
curve(dbeta(theta, alpha, beta), from = 0, to = 1, xname = "theta", ylab = "Beta density", xlab="% SEC",xlim=c(0,.3), ylim=c(0,65), main="SEC Probability")

SEC = nrow(subset(combine, (combine$college=="Florida" | combine$college=="Georgia" | combine$college=="Kentucky" | combine$college=="Missouri" | combine$college=="South Carolina" | combine$college=="Tennessee" | combine$college=="Vanderbilt" | combine$college=="Alabama" | combine$college=="Arkansas" | combine$college=="Auburn" | combine$college=="LSU" | combine$college=="Mississippi" | combine$college=="Mississippi State" | combine$college=="Texas A&M") & combine$year >= 2010 & combine$year <= 2015))
# 309

total = nrow(subset(combine, combine$year >= 2010 & combine$year <=2015))
# 1851

alphaNew = alpha + SEC
betaNew = beta + (total - SEC)

curve(dbeta(x, alphaNew, betaNew), col = "blue", add = TRUE) 
abline(v=(14/128), col="red")



###

# 5. Calculation and display of a logistic regression curve

# NFL grade is a score based on a player's athleticism, success in college football, 
# potential in the NFL, and more. The logistic regression line illustrates the relationship
# between the NFL grade and whether or not a player was drafted. The graded players are found. 
# Of the graded players, the ones who were drafted, $picktotal not equal to 0, are determined.
# The logistic regression line then captures the relationship between increasing NFL grades
# and increasing likelihood of being drafted. This analysis could be very helpful to a 
# an NFL prospect or an agent who is determining if a player will be selected in the draft 
# and therefore possibly receive a signing bonus and gauranteed money. This analysis also 
# confirms that the NFL grade correctly reflects a players draft status and is not a mostly
# media-used statistic that only serves to highlight stars in the draft.


library(stats4)

graded = subset(combine, combine$nflgrade !=0)

drafted = graded$picktotal != 0

plot(graded$nflgrade, drafted, xlim=c(0, 8), main="NFL Grade and Draft Status", ylab="1=Drafted, 0=Undrafted")

MLL<- function(alpha, beta)
  -sum( log( exp(alpha+beta*graded$nflgrade)/(1+exp(alpha+beta*graded$nflgrade)) )*drafted+ log(1/(1+exp(alpha+beta*graded$nflgrade)))*(1-drafted) )
results<-mle(MLL,start = list(alpha = -0.1, beta = -0.02))
results@coef
curve( exp(results@coef[1]+results@coef[2]*x)/ (1+exp(results@coef[1]+results@coef[2]*x)),col = "blue", add=TRUE)


###

#7. A graphical display unlike one presented in the textbook or course scripts

# The vioplot is similar to the box plot but additionally illustrates the density. The violet
# shows how many instances of each value are contained in the collection. This plot shows 
# the long tail towards 380 lb. guards that does not occur amongst centers. Also
# it shows the increased variability among guards including the skew towards the
# heavier players that leads to the long tail mentioned earlier.
#   This display is useful if a coach is considering switching a guard to center or vice
# versa. They are similar positions but centers tend to smaller and quicker and guards
# tend to be larger and better blockers. From the plot, a coach can tell a small guard 
# around 305 lbs. is the typical size for a center and may do well there. Similarly, 
# a heavy center at 330 lb. is actually heavier than most guards and may be better
# fit to play that position. 

install.packages("vioplot")

library(vioplot)

vioplot(subset(combine, combine$position=="OG")$weight,subset(combine, combine$position=="OC")$weight)


### 16. Maximum-likelihood estimation of parameters (2 points)

# Distributions in the NFL combine can be modeled to better predict
# players' athetic ability. For example the vertical jumps distribution
# has a shallower incline followed by a steep descent which fits
# well with the Weibull distribution. The two parameters for the 
# Weibull distribution are determined with maximum-likelihood estimation.
# The mle function is used with the vertical jumps data and the log sum of 
# densities to determine the Weibull k and lambda parameters. The histogram
# of vertical jumps data and the Weibull distribution with the calculated
# parameters are displayed showing it is a good fit.

verts = subset(combine$vertical, combine$vertical != 0)

MLL <-function(lambda, k) -sum(dweibull(verts, k, lambda, log = TRUE))

mle(MLL,start = list(lambda = 1, k=1)) 

hist(verts, breaks= , probability = TRUE)

curve(dweibull(x, 8.731466, 34.710721), col = "red", add=TRUE)
