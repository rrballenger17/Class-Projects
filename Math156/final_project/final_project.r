# Ryan Ballenger
# Math 156 Final Project

setwd("/Users/Ryan/Desktop")

combine = read.csv("combine.csv")


##### 
# Required technical elements – the dataset

# The dataset is NFL Combine player statistics from 1999-2015.
# It was downloaded from nflsavant.com which is created and run by
# Daren William, the Director of Baseball Research and Development for
# Major League Baseball(MLB).

# 1. a dataframe 
head(combine)

# 2. At least two categorical or logical columns (ie factors)
head(combine$position)
head(combine$college)

# 3. At least two numeric columns
head(combine$fortyyd)
head(combine$heightinchestotal)

# 4. At least 20 rows, preferably more, but real-world data may be limited
nrow(combine) #4947

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


### 2. Student t confidence interval
  # (also, 3. A display illustrating confidence intervals)

# The student t confidence interval at 99% and 90% are found. Fans and 
# the media tend to exaggerate players strength and its useful to see
# the mean bench score, the number of times a player benches 225 lb. First
# the subset of players who participated in the bench press is found. 
# The 99% student t confidence interval is found manually and the automated
# t.test is used to verify the 99% confidence interval and also find one
# for 90%. The histogram of bench scores is created and overlaid with the
# confidence intervals. The mean of all bench scores is also displayed.


bench = subset(combine$bench, combine$bench >0)
count = length(bench)

L <- mean(bench) + qt(0.005, count-1) * sd(bench)/sqrt(count)
U <- mean(bench) + qt(0.995, count-1) * sd(bench)/sqrt(count) 
# 21.02844    21.57069

t.test(bench, conf.level = .99) # 21.02844 21.57069
t.test(bench, conf.level = .90) # 21.12648 21.47265

hist(bench,10, xlim=c(18, 26), ylim=c(0,500), breaks=20, main="Bench Press", xlab="225lb. Repetitions")

abline(v=c(L,U), col="red")
abline(v=c(21.12648, 21.47265), col="blue")

meanTotal = mean(subset(combine$bench, combine$bench >0)) # 21.29956
abline(v=meanTotal, col ="green")


# t confidence interval continued. Some populations may not 
# be approximated well with a t-confidence interval. 30 samples are
# repeatedly taken from the bench press scores and used to make 
# a 95% t-confidence interval. It turns out 95.9% of the CIs 
# contain the actual mean of the population showing the student
# t confidence interval does well in this case.

counter <- 0
allBench = subset(combine$bench, combine$bench >0)
plot(x =c(16,26), y = c(1,100), type = "n", xlab = "Bench", ylab = "Iterations") 
for (i in 1:1000) {
  x <-sample(allBench, 30)
  L <- mean(x) + qt(0.025, 29) * sd(x)/sqrt(30) 
  U <- mean(x) + qt(0.975, 29) * sd(x)/sqrt(30) 
  if (L < meanTotal && U > meanTotal) counter <- counter + 1 
  if(i <= 100) segments(L, i, U, i)
}
abline (v = meanTotal, col = "red") 
counter/1000 
#0.959



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

# 1. Use all three required analysis technical elements (2 points)

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

#6. A dataset with many (10+) columns, allowing comparison of many variables

# The dataset contains 26 columns such as weight and vertical jump which appear 
# to be negatively correlated as expected. Note: Some players did not participate in 
# the vertical giving a value of 0. 

length(combine) #26

plot(combine$weight, combine$vertical, main="Weight and Vertical Jump")


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


### 

# 9. Appropriate use of bootstrap techniques (2 points)

# Exploring this data reveals that CBs at the NFL combine tend to get drafted
# more often than RBs. This could be because teams need two cornerbacks and only one 
# runningback. However most teams play more than one runningback. Also cornerbacks 
# tend to be a harder position to recruit as someone who is light, can guard wide 
# receivers, and still make tackles.
#   This analysis bootstraps the relative chance of being drafted as a CB compared
# to being a RB at the combine. The set of all runningbacks and cornerbacks is 
# selected. To boostrap, 35 samples are taken from each population, representing
# approximately how many will be at the combine. The number of samples drafted 
# is calculated and the proportion of drafted CBs to RBs is found. The histogram
# illustrates the results and with an average relative chance of 1.391526 of
# being drafted as a CB. This may mean millions of dollars worth of contract 
# money as a cornerback compared to being an undrafted and possibly unemployed
# runningback.

# Bootstrap ratio of CBs drafted

RB = subset(combine$picktotal, combine$position == "RB")
CB = subset(combine$picktotal, combine$position == "CB")
nRB<-length(RB); 
nCB <-length(CB)

N <- 10^4; 
ratio <- numeric(N); 
prop1 <-numeric(N); 
prop2 <- numeric(N)

# adjusted the sample size to 35
for (i in 1:N) {
  sample1 <-sample(CB,35, replace = TRUE)
  sample2 <-sample(RB,35, replace = TRUE)
  prop1[i] <- mean(sample1!= 0)
  prop2[i] <- mean(sample2!= 0)
  ratio[i] <-prop1[i]/prop2[i]
}

hist(ratio, xlab = "Relative Chance")
abline(v = mean(ratio), col = "red")
mean(ratio)

#Calculate the bootstrap percentile confidence interval
CI = quantile(ratio, c(0.025, 0.975)); CI
abline(v = CI[1], col = "green")
abline(v = CI[2], col = "green")


# Bootstrap continued: mean NFL rookie weight 

# Another simpler bootstrap calculation is the mean weight for an NFL prospect.
# A health study may be comparing professional athletes and need to determine
# the average weight for an NFL rookie. The NFL combine is ideal population
# to use for a boostrap population. Also the player weights are very skewed
# with a steep slope followed by a slow decline into the heavier weights. A 
# CLT approximation is ineffive in this case and the boostrap method can be 
# used with the skewed, unknown distribution.
#   The weights are sampled with replacement and the mean is taken. This is 
# repeated 10^4 times. The results are normal with an average weight of 245.58.

N<-10^4; 
weight.mean <- numeric(N)
n<-length(combine$weight);n

for (i in 1:N) {
  weight.mean[i]<-mean(sample(combine$weight, n, replace = TRUE))
}
hist(weight.mean, breaks= "FD",main = ("Bootstrap distribution of means"), probability = TRUE)

mean(weight.mean)
# 245.5852

#We can use the bootstrap distribution to get a 95% "bootstrap percentile 
# confidence interval" for the true mean
quantile(weight.mean, c(.025, .975)) #244.3095 246.8872 


### 10. A convincing demonstration of an unexpected statistically significant relationship

# It is well-known that great quarterbacks tend to get selected in the 1st round
# of the draft. Other positions however do not have a reputation for being more 
# popular than others in the first round. 
#    Cornerbacks are more likely to get drafted than RBs, as shown earlier, but they are 
# not in the top 3 paid positions. As a former NCAA football player and fan, I would not 
# assume the first round is made up of a significant amount of cornerbacks.
#   Here the chi-square test is used to determine the likelihood of the given number
# of cornerbacks in the first round. The cornerbacks are selected, the
# first round drafts are selected, and the chi-square test is run by creating a table
# from these lists.
#   It turns out CBs are signficantly more often selected in the first round with a 
# p-value of 0.042. Considering other important positions TEs, WRs, RBs, and the 
# position salaries, it was unlikely cornerbacks were taken in the first round 
# by a significant margin but they are.


CBs = combine$position == "CB" 
first = combine$round == 1

table(CBs, first)

chisq.test(table(CBs, first))$p.value


### 11. A convincing demonstration that a relationship expected to be significant is not

# Runningbacks drafted in the first round are typically very athletic. A mean comparison
# shows that first round runningbacks have a mean vertical jump that is 
# 2 inches higher than the vertical of the rest of the runningbacks. This difference 
# is probably significant because 2 inches is a large difference in vertical jumps and first
# round runningbacks are likely more athletic since they are selected sooner.
#   Samples of the same size are taken from the runningback population. The mean
# vertical is compared to the that of the rest. This process is repeated 10^5 - 1 times
# and the observed difference is compared to the permutated difference of means. The pvalue 
# is .141 meaning the 2 in. difference is not significant and could be by chance. This
# result suggests all NFL prospects are athletic, with the ability to jump high, and 
# other factors make the difference in the first round picks. 

RB = subset(combine, combine$position == "RB" & combine$vertical != 0)

index<-which(RB$round == 1)

observed<-mean(RB$vertical[index])-mean(RB$vertical[-index]); observed

N=10^5-1; 
result<-numeric(N)  #99999 random subsets should be enough
for (i in 1:N) {
  index = sample(nrow(RB), size=length(index), replace = FALSE) #random subset
  result[i]=mean(RB$bench[index])-mean(RB$bench[-index])
}

scoreBetter<-which(result >= observed)
pVal<-(length(scoreBetter)+1)/(length(result)+1); pVal # .141 


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

# The second maximum likelihood calculation is done to model the bench
# press performance. It appears normally distributed and the mean
# and standard deviation are calculated with the maximum likelihood
# estimate. The data and the normal distribution are displayed to
# illustrate how well they match. With a known distribution, a coach
# can quickly assess how strong a player is relative to his peers.

benches = subset(combine$bench, combine$bench != 0)

MLL <-function(mu, sigma) -sum(dnorm(benches, mu, sigma, log = TRUE))

mle(MLL,start = list(mu = 25, sigma = 3)) 
# 21.299544  6.356729 

hist(benches, breaks=20, probability = TRUE)
curve(dnorm(x, 21.299544,6.356729 ), col = "red", add=TRUE)





