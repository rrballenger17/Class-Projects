# Ryan Ballenger
# Math 156

#####
# 1.

# exact
pbinom(230,800,0.286) - pbinom(219, 800, 0.286) 
# 0.3208302

mean = .286 * 800

# variance = p*(1-p)*n
sd = sqrt(.286 * (1-.286) * 800)

# CLT with continuity correction
pnorm(230.5, mean, sd) - pnorm(219.5, mean, sd) 
#0.3194833

# Comparison: The CLT approximation is a good estimate of and very to close 
# to the exact value of the probability. The approximation gives .319 while the 
# the exact value is .320 which shows the approximation is very good. 





#####
# 2. 
# mean: 7 - 10 = -3, var: 3^2/9 + 5^2/12 = 3.083    sd: 1.755942
# Therefore, N(-3, 3.083)

#b
W <- numeric(1000)
for (i in 1:1000)
{
	x <- rnorm(9, 7, 3)
	y <- rnorm(12, 10, 5)
	W[i] <- mean(x) - mean(y)
}

hist(W, ylim=c(0,400))
abline(v=mean(W), col="red")
abline(v=mean(W) - sqrt(var(W)), col="blue")
abline(v=mean(W) + sqrt(var(W)), col="blue")
mean = paste("Mean: ", mean(W))
variance = paste("SD: ", sqrt(var(W)))
legend("topright", legend=c(mean, variance), pch = 0, inset = .02, col=c("red", "blue"))

# Check: Yes, the mean and standard deviation are very close to the 
# expected values. The mean -2.986 is almost the same as expected -3.0 
# and the standard deviation 1.754 is near the expected value of 1.756.

#c
mean(W< -1.5) #.80357
# exact 
pnorm(-1.5, -3, 1.755942) # 0.8035146

# Check: Yes, the probability of W < -1.5 is very near the expected value of .8035146.


#####
# 3.

# a.
expVal = (60+40)/2 + (80+45)/2; expVal # 112.5
varVal = (60-40)^2/12 + (80-45)^2/12; varVal  # 135.4167

# b.
X <- runif(1000, 40, 60)
Y <- runif(1000, 45, 80)

total <- X + Y
hist(total)
mean(total) # 112.9501
var(total) # 135.401

# The graph of the distribution is as expected, with a mean of approx. 112.5 and a 
# standard deviation near 135.4167. It appears to have normal-like curvature with 
# most values occuring in the middle and less so as the x-value moves away from the mean. 

# The mean and the variance are very near the expected values. It's clear from running the 
# test that the mean and variance are aligned with the expected values. They only differ slightly.

#c
mean(total<90) # .019% chance

# It is very unlikly. From the simulation, only .019% of the sums are <= 90 minutes.





#####
# 4.

#a)
# How the theoretical expectation of Xmin was found:

# f(x) = λ * exp(−λ*x)  => pdf for exponential dist.
# F(x) = 1 − exp(−λ*x)  => cdf for exponential dist.
# pdf for Xmin = n(1-F(x))^(n-1) * f(x)    => formula from the textbook
# expected Xmin = integrate(function(x){x*Xmin(x)}, lower=0, upper=Inf)
# 0.0057142860

# I found the pdf of the Xmin with the formula from the textbook, using the expon. dist.'s pdf and cdf. 
# I filled in the n and lambda values and integrated the pdf*x from x=0 to infinity. This is the common
# method for finding the expected value from the pdf.

f = function(x){7* exp(-7*x)}
F = function(x){1 - exp(-7*x) }
Xmin = function(x){25*(1-F(x))^(25-1)*f(x)}
integrate(function(x){x*Xmin(x)}, lower=0, upper=Inf)
# 0.005714286

#b. 
W <- numeric(1000)
for (i in 1:1000)
{
	W[i] = min(rexp(25, 7))
}
hist(W)
mean(W)
abline(v=mean(W), col="red")

# The simulated value is 0.005763458 which is very close, and almost identical, 
# to the expected value.


#####
# 5.
diceProb = c(1/6, 1/6, 1/6, 1/6, 1/6, 1/6)
diceVals = c(1, 2, 3, 4, 5, 6)

Y <-outer(diceVals,diceVals,"+"); Y
pr <- outer(diceProb, diceProb,"*"); pr

mgf <- function(x, Y, pr)  {
  sum(pr*(exp(x*Y)))
}

mgfD <- Vectorize(function(x) mgf(x, Y, pr))
curve (mgfD, from = -1, to = 1, col = "purple", lty = 2)

#5.b

Y <- matrix(c(1, 2, 3, 4, 5, 6))
pr <- matrix(c(1/6, 1/6, 1/6, 1/6, 1/6, 1/6))

mgfS <- Vectorize(function(x) mgf(x, Y, pr))
square <- function(x){mgfS(x) * mgfS(x)}
curve (square, from = -1, to = 1, col = "green", lty = 2, add=TRUE)





















