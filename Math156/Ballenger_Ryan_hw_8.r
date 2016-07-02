
# Ryan Ballenger, Math 156, HW# 8 

#####
# 1.
#setwd("/Users/Ryan/Desktop")
library(stats4)

# define the weibull functions
weibull.shape <- function(k, data)
{
  numer <- colSums(outer(data, k, "^") * log(data))
  denom <- colSums(outer(data, k, "^"))
  numer/denom - 1/k - mean(log(data))
}

weibull.scale <- function(k, data)
{
  mean(data^k)^(1/k)
}

# setwd("/Users/Ryan/Desktop")
quakes = read.csv("Quakes.csv")

# get time between quakes
time <- quakes$TimeDiff


# solve for shape paramter of the weibull model
uniroot(weibull.shape, data = time, lower = .8,upper = 1)
# 0.9172097

# solve for scale parameter of the weibull model
weibull.scale(0.9172097, time)
# 17.346

# Plot histogram with density curve overlap
hist(time, main = "Distribution of time between earthquakes", xlab = "days", prob = TRUE)
curve(dweibull(x, 0.9172097, 17.346), add = TRUE, col = "blue", lwd = 2)

# ECDF plot of times between earthquakes with the weibull distribution curve 
plot.ecdf(time,main = "ECDF of earthquake data")
curve(pweibull(x,0.9172097, 17.346), add=TRUE, col="blue",lwd=2)

# check answer with mle
observed = time
MLL <-function(shape, scale) -sum(dweibull(observed, shape, scale, log = TRUE))
mle(MLL,start = list(shape = .5, scale = 3)) 
# confirms 0.9171604 and 17.3409539 parameters





#####
# 2.

# get the service times
service = read.csv("Service.csv")
sTimes = service$Times

# calculate the first moment, second moment, and variance
M1 = mean(sTimes) 
M2 = mean(sTimes^2);
variance <- M2 - M1^2 

# calculate the parameters from the moments
rate = M1/variance; rate # = 3.84239		rate or lamda
shape = M1*M1/variance; shape # = 2.670167			shape or r
	
# Confirm rate and shape derivation by generating a random sample
#new = rgamma(10000, rate=rate, shape=shape
#sTimes = new
#M1 = mean(sTimes) 
#M2 = mean(sTimes^2);
#variance <- M2 - M1^2 
#M1/variance
#M1*M1/variance

# 2.b
# determine quantiles for the gamma distribution with the parameters from above
q <- qgamma(seq(.1, .9, by = .1), shape=shape, rate=rate)

range(sTimes)
# .1 2.2

q = c(0.0, q, 2.5)

# determine times in each range
count <- hist(sTimes, breaks=q, plot=F)$counts

expected <- length(sTimes)*.1

# calculate the chi-square statistic from the observed and expected values
chiStat = sum((count-expected)^2/expected)

#We had 10 intervals but we estimated two parameters, leaving just 7 degrees of freedom.
pchisq(chiStat, df=7, lower.tail = FALSE) # 0.9611017
# The chiStat is small, which is unusual for df=7, giving a very high p-value

#2.c
# histogram of the service times and the gamma density function
hist(sTimes, main = "Distribution of average service times",
    xlab = "mins", prob = TRUE)
curve(dgamma(x, shape=2.670167, rate=3.84239), add = TRUE, col = "blue", lwd = 2)

# plot of the ecdf for the service times and the gamma distribution function
plot.ecdf(sTimes,main = "ECDF of service time data")
curve(pgamma(x, shape=2.670167, rate=3.84239), add=TRUE, col="blue",lwd=2)



#####
# 3. 

observed = c(.855,.891,.913,.989,.943)
# create the log density function
density<-function(x, theta) log(theta * x^(theta - 1))

# create the MLL function where the variable x is theta and the observed 
# values are the other parameter
MLL <-function(x) -sum(density(observed, x))

curve(Vectorize(MLL)(x),from =1, to =20)

# solve for theta with mle()
mle(MLL,start = list(x = 2))
#11.55125

###

# use the method of moments to solve for the number of test attempts

# integrate theta * x ^(theta - 1) * x from x=0 to x=1
# the integration gives theta / theta + 1 which is the E[X]
M1 = mean(observed);
# M1 = theta / (theta + 1)
# M1 * theta + M1 = theta
# theta = M1/(1-M1)
theta = M1/(1-M1); theta
# theta = 11.2249

###

# determine the most likely integer number of test attempts
min = MLL(1) + 1
theta = 0
N= 1000
for (i in 1:N) {
  result = MLL(i)
  if(result < min){
  	min = result
  	theta = i
  }
}
theta # 12



#####
# 4. 

# a simulation to test how well x.bar estimates 1/rate of the 
# exponential function

N = 100000
estimates = numeric(4)

for (rate in c(1/2, 1/3, 1/6, 1/12)){
  x.bar = numeric(N)
  for (i in 1:N) {
    x1 <- rexp(100, rate)   #the sample
    x2 <- rexp(100, rate)
    x.bar[i] = mean((x1 + x2) / 2)
  }
  print(mean(x.bar))
}
#[1] 2.001062
#[1] 3.001395
#[1] 5.999979
#[1] 11.99792
# x.bar is a good estimator of 1/rate 

####

# Simulation to test how well sqrt(X1 * X2) * bias estimates 1/lamda

for (lamda in c(1/2, 1/3, 1/6, 1/12)){

  N = 100000
  x.bar = numeric(N)
  for (i in 1:N) {
    x1 <- rexp(100, lamda)   #the sample
    x2 <- rexp(100, lamda)
    x.bar[i] = mean(sqrt(x1 * x2)) # * (pi - 4)/(4 * (1/6)))
  }

  print(mean(x.bar) -  (pi-4)/(4 * lamda))
}
#[1] 2.000269
#[1] 2.999638
#[1] 6.000532
#[1] 11.99496
# x.bar with the bias applied is a good estimator or 1/lamda





#####
# 5.
# install.packages("actuar")
# library(actuar)

x <- rpareto(10, 1, 2)

n <- 250; 
N = 1000; 
means = numeric(N); 

curve(dpareto(x,1, 2), from = 1, to = 100)

# a histrogram of means of the pareto samples shows many outliers
for (i in 1:N){
  x <- rpareto(n, 1, 2)  
  means[i] = mean(x)
}
hist(means, breaks = 100)

epsilon = 20  

# the plot shows the mean of the pareto function is not nearing a value
plot(1, xlim= c(200, 20000), ylim = c(0, 500), log = "x", type = "n")
abline(h = c(100 + epsilon, 100- epsilon), col = "red")
N = 1000;  epsilon = 0.05
for (n in c(250, 500, 1000, 2000, 5000, 10000, 20000)){
  means = numeric(N);
  for (i in 1:N){
    x <- rpareto(n,1, 2)
    means[i] = mean(x)
  }
  points( rep(n, N), means)
}
# Increasing n accomplishes nothing -- the mean is not a consistent estimator

###
# a histrogram shows the medians are more consistent
N = 1000; 
n=10
medians = numeric(N); 
for (i in 1:N){
  x <- rpareto(n, 1, 2)  
  medians[i] = median(x)
}
hist(medians, breaks = 100) 

###

# analysis of median(x) - 2*median(x)/n as an estimator for s.
# the distribution, the expected value, and the median were analyzed. 
# Additionally the different samples sizes were tried and trial
# and error was used to determine what works well. All of these calculations
# led to the invention of median(x) - 2*median(x)/n as an estimate.
n=1000
N= 10000
medians = numeric(N); 
for (i in 1:N){
    x <- rpareto(n, 1, 2)  
    medians[i] = median(x) - 2*median(x)/n
}
hist(medians, breaks = 100) 
mean(medians)
# very good estimator of s -> 2.001398
# also it adapts to the sample size n


# the plots shows as sample sizes grow, the estimator nears the value of s
plot(1, xlim= c(200, 20000), ylim = c(0, 3), log = "x", type = "n")
N = 1000;  epsilon = 0.05
abline(h = c(2 + epsilon,2- epsilon), col = "red")

for (n in c(250, 500, 1000, 2000, 5000, 10000, 20000)){
  means = numeric(N);
  for (i in 1:N){
    x <- rpareto(n,1, 2)
    means[i] = median(x) - 2*median(x)/n
  }
  points( rep(n, N), means)
}














