# Ryan Ballenger
# Math 156, HW#6

#####
# 1. 

# 95% interval for the mean of 20 exp(lambda=1) random variables from the gamma distribution
X.add <- 1-qgamma(0.025,shape = 20,rate = 20); X.add 
X.sub <- qgamma(0.975,shape = 20,rate = 20)-1; X.sub

qgamma(c(.025, 0.975),shape = 20,rate = 20)
# The interval is (0.610826 to 1.483543) for average lifetime of 20 pets (exp, lambda=1)

# testing the gamma-derived confidence interval
tooBig = 0
tooSmall = 0
counter <- 0
for (i in 1:1000) {
  x <-rexp(20, 1) 
  L <- mean(x) - X.sub 
  U <- mean(x) + X.add 
  if (L < 1 && 1 < U) counter <- counter + 1
  if(L>=1) tooBig = tooBig + 1
  if(U<=1) tooSmall = tooSmall + 1
}
counter/1000 # 0.956 as expected
tooBig # 20
tooSmall # 24


# 95% confidence interval from the bootstrap method. A sample of 20 exp. random variables is created.
# 20 samples are taken from the initial sample with replacement 10^4 times and the mean is saved
# in my.boot. The 95% CI is the quantile(my.boot, c(.025, .975))

my.sample = rexp(20, 1)  
N=10^4; 
my.boot<-numeric(N)

for (i in 1:N) {
  my.boot[i] = mean(sample(my.sample, replace = TRUE))
}

# bootstrap-derived 95% confidence interval 
X.add <- mean(my.boot)-quantile(my.boot,0.025); X.add 
X.sub <- quantile(my.boot,0.975)-mean(my.boot); X.sub 

# The confidence interval is the .025 and .975 quantiles of the bootstrap sample mean
quantile(my.boot, c(.025, .975))
# 0.562758 to 1.554067 
# 0.5843222 to 1.4717226 


# Create a graphical display of 100 confidence intervals
# Same process as above expect ab-lines are added to the plot
# The bootstrap CI's are blue and red, and the gamma-derived CI is black for comparison
plot(c(), c(), xlim=c(0,3), ylim=c(0,5), main="Bootstrap Confidence Intervals: Cyberpets", xlab="Lifetime")
for (j in 1:100) {
  my.sample = rexp(20, 1); N=10^4; my.boot<-numeric(N)
  for (i in 1:N) {
    my.boot[i] = mean(sample(my.sample, replace = TRUE))
  }
  abline(v=quantile(my.boot, c(.025, .975))[1],  col="blue")
  abline(v=quantile(my.boot, c(.025, .975))[2], col="red")
}
abline(v=qgamma(c(.025, 0.975),shape = 20,rate = 20)[1], lwd=3)
abline(v=qgamma(c(.025, 0.975),shape = 20,rate = 20)[2], lwd=3)


# testing the bootstrap-derived confidence interval - same test as earlier
tooBig = 0
tooSmall = 0
counter <- 0
for (i in 1:1000) {
  x <-rexp(20, 1) 
  L <- mean(x) - X.sub 
  U <- mean(x) + X.add 
  if (L < 1 && 1 < U) counter <- counter + 1
  if(L>=1) tooBig = tooBig + 1
  if(U<=1) tooSmall = tooSmall + 1
}
counter/1000 # 0.976
tooBig # 22
tooSmall # 22

# Comparison: The gamma-derived interval and the bootstrap interval are similar. The bootstrap interval is 
# usually around the gamma CI of (0.610826 to 1.483543). The bootstrap interval is less consistent though. 
# Sometimes the interval will be too small and testing shows only 92%, for example, of the random deviates
# are within the range. The inconsistency is from the fact that the bootstrap interval is found from a small 
# sample of 20 exponential random varibles. The gamma CI does well and testing shows approximately 95% of the 
# random means are within its range. The bootstrap interval is far more likely to miss random means that are too 
# large and out of its range.





#####
# 2. 
#setwd("/Users/Ryan/Desktop")

fish = read.csv("FishMercury.csv")$Mercury

boxplot(fish, main="Boxpot: Minnesota Fish Mercury Levels", ylab="Mercury")
# What do you observe? 
# All levels are near .1 +/- .05 except one value which is 1.87 and later referred 
# to as the outlier. The bar graph illustrates this by showing how concentrated the values
# are around .1 and then showing the outlier with a circle far away from the others.

# bootstrap the mean and record the bootstrap standard error and 95% interval
N=10^4; 
my.boot<-numeric(N)
for (i in 1:N) {
  my.boot[i] = mean(sample(fish, 30, replace = TRUE))
}

# bootstrap mean
mean(my.boot) #0.1828887

# bootstrap 95% confidence interval
quantile(my.boot, c(.025, .975)) # 0.1123658 0.3059033 

# bootstrap standard error
sd(my.boot) # 0.05771903


# remove the outlier
newfish = fish[2:30]
N=10^4; my.boot<-numeric(N)
for (i in 1:N) {
  my.boot[i] = mean(sample(newfish, 29, replace = TRUE))
}

# bootstrap mean without outlier
mean(my.boot) # 0.1236003

# new bootstrap CI
quantile(my.boot, c(.025, .975)) # 0.1080345 0.1388621 

# new bootstrap standard error
sd(my.boot) # 0.007865295

# d. Removing the outlier decreased the standard error (from .0577 to .0078) and narrowed the 
# 95% confidence interval. Without the outlier, the dataset is consistent with all values around .1.
# As expected, removing an outlier from a dataset makes the confidence interval much smaller because a smaller
# range is needed to capture the values. Likewise, the standard error of a dataset is smaller without an outlier.





#####
# 3. 

prices = read.csv("BookPrices.csv")

math = subset(prices$Price, prices$Area=="Math & Science")
social = subset(prices$Price, prices$Area=="Social Sciences")

#a. exploratory analysis
#   The math and natural science books, named math, are generally higher priced. Few of these type of books are priced
# below $100. The mean is ~156.7 and the standard deviation is 39.1. From my class experience, these books tend to be bigger and 
# always cost more. Clearly there is a trend that the math books are the more expensive type. There are also 27 math book prices
# in the dataset and only 15 social science book prices. 
#   The social science books are more varied in terms of price. Some of them are equally as expensive as the math books with 
# prices above $150. There are also about 30% of the books that are priced <$20 which is very affordable for a college textbook. 
# The mean is 98.9 and the standard deviation is 71.9. There are some expensive books that bring up the mean to $98 but there is 
# a very large standard deviation of 71.9 needed to capture the large range of book prices. 

#b. bootstrap the mean separately and describe the distributions
N<-10^4; 
math.sample <- numeric(N); 
social.sample <- numeric(N)
for (i in 1:N) {
  math.sample[i] <- mean(sample(math, length(math), replace = TRUE))
  social.sample[i] <- mean(sample(social, length(social), replace = TRUE))
}

mean(math.sample) # 156.7051
quantile(math.sample, c(.025, .5, .975)) # 142.1413, 156.8065, 171.1147 

mean(social.sample) # 99.11637
quantile(social.sample, c(.025, .5, .975)) # 66.45176, 98.96853, 131.80596 

# The mean price of each book type from the bootstrap distribution is $156.7051 for math and $99.11637 for social science.
# The means are very near the mean values of the initial sample of math and social science books. I also found the 95% CI
# which shows that social science books vary more than the math books. The CI stretches around +/- 15 for math and +/- 30 
# for social.  


# c. bootstrap the ratio of means
N = 10^5; 
ratio.mean <- numeric(N)

for (i in 1:N) {
  one <- sample(math, length(math), replace = TRUE)
  two <- sample(social, length(social), replace = TRUE)
  ratio.mean[i] <- mean(one)/mean(two)
}

mean(ratio.mean) # 1.633892

# 3 types of plots/histograms for the bootstrap ratio of means results

# A Histogram with bootstrap mean ratios, actual mean ratio, and mean bootstrap mean ratio.
# The bootstrap and the actual ratio of means are very close at ~1.6. The bootstrap ratio of means
# is steeper on the left as it nears 0 and has a longer tail on the right as it increases. This is because it
# is possible to get large math book prices and mostly the <$20 prices for social sciences which creates
# a large ratio value. 
hist(ratio.mean, main = "Bootstrap distribution of ratio of means")
abline(v=mean(math)/mean(social), col = "red", lty = 2)
abline(v=mean(ratio.mean, col = "blue", lty = 4))

# a simple plot of all the bootstrapped mean ratios
plot(ratio.mean)

# plot of ratio of means quantiles
plot(mean(social), mean(math), xlim=c(0,200), ylim = c(0,200),
     xlab = "Social Science Prices",
     ylab = "Math & Science Prices")
abline(v=mean(social), col = "red")
abline(h=mean(math), col = "red")
abline(0, quantile(ratio.mean, .025), col = "blue", lty = 2)
abline(0, quantile(ratio.mean, .975), col = "blue", lty = 2)
abline(0, quantile(ratio.mean, .5), col = "green", lty = 4)


# d. 
quantile(ratio.mean, c(.025, .975))
#   2.5%   97.5% 
# 1.169239 2.399626 
# I ran a test and 1.17 to 2.22 as the back of the book states is a 92.5% CI whereas the one 
# listed above is correct and a 95% CI.

# The lower 2.5% quantile of 1.17 shows that math books are almost always more expensive
# than social science books, even if only by ~15%. The 97.5% quantile at 2.41 shows that 
# if the average math book is high and the social science book has a lower price, the ratio
# can be large, specifically with the math & natural science book being approx. 2.5x larger.

# e.
bias = mean(ratio.mean) - mean(math)/mean(social)
bias # 0.05148137

bias/sd(ratio.mean) # 0.1605414







#####
# 4.
men <- c(rep(1,41), rep(0,819-41))
women <- c(rep(1,23), rep(0,756-23))

mean(men)/mean(women)

N = 10^4; 
ratio.mean <- numeric(N)
men.sample <- numeric(N)
women.sample <- numeric(N)

for (i in 1:N) {
  one <- sample(men, replace = TRUE)
  two <- sample(women, replace = TRUE)
  ratio.mean[i] <- mean(one)/mean(two)

  men.sample[i] = mean(one)
  women.sample[i] = mean(two)
}

# bootstrap relative risk
mean(ratio.mean) # 1.719671

# 95% confidence interval on the relative risk 
quantile(ratio.mean, c(.025, .975)) # 1.015310 2.826923 

# bias 
bias = mean(ratio.mean) - mean(men)/mean(women)
bias # 0.0741859

# bias / Standard error
bias / sd(ratio.mean) # 0.1570925

# The relative risk for guys is 1.72 according to the bootstrap method. There is a bias that is 
# about .157 of the standard error of the bootstrap relative risks. The 95% confidence interval is 1.01 to 2.83
# which shows that boys almost always have a higher risk than girls, that reaches as high as a 2.8 relative risk. 

plot(women.sample, men.sample, add=TRUE, main="Failing to Graduate in 5 Years", xlab = "Proportion of women", ylab = "Proportion of men")

abline(v=mean(women), col = "red")
abline(h=mean(men), col = "red")
abline(0, quantile(ratio.mean, .025), col = "blue")
abline(0, quantile(ratio.mean, .975), col = "blue")
abline(0, quantile(ratio.mean, .5), col = "green")












