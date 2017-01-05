
# Ryan Ballenger
# Math 156
# HW 4

#setwd("/Users/Ryan/Desktop")

#####
# 1.

#setwd("/Users/Ryan/Desktop")
Lot = read.csv("Lottery.csv")

# Chi-square goodness of fit test 
Numbers<-Lot$Win
Obs<-table(Numbers);Obs

chisq1 <-function(Obs){
  Expected <- rep(sum(Obs)/length(Obs),length(Obs))
  sum((Obs-Expected)^2/Expected)
}
observed <-chisq1(Obs);observed # chi-square statistic is 33.676

Pvalue <-chisq.test(Obs); Pvalue 
# p-value is .67 suggesting they are randomly drawn.
# Using the Chi-square goodness of fit test, the numbers 
# are shown to have been selected randomly. The .67 p-value 
# shows this is a typical random draw. 


# drawing samples of 500 numbers from 1 to 39 
nums=c(1:39); nums

N =10^4 -1; result<-numeric(N)
for (i in 1:N){
  nums.sim<-sample(nums, length(Numbers), replace= TRUE)
  result[i]<-chisq1(table(nums.sim))
}
hist(result, xlab="Chi-Square Statistic")
abline(v = observed, col = "red") 
Pvalue <- (sum(result >= observed)+1)/(N+1); Pvalue   
# P-value is .67, which suggests numbers are randomly chosen 
# Like the first test, this sampling test shows the numbers are
# randomly drawn effectively by California. The .67 p-value shows 
# the data is typical for a random draw. 


#####
# 2. 

# install.packages("VGAM")
# library("VGAM")

# intervals are 
# 1 - 1.5 , 1.5 - 2 , 2 - 3 , 3 - 5, 5 +  

# determine pareto distribution for each interval 
Expected<-c(ppareto(1.5, 1, 2),ppareto(2.0, 1, 2)-ppareto(1.5, 1, 2),ppareto(3.0, 1, 2)-ppareto(2.0, 1, 2),ppareto(5.0, 1, 2)-ppareto(3.0, 1, 2),1 - ppareto(5.0, 1, 2)); Expected

# sample of 70 random numbers in the ranges from the handout
sample = c(30, 18, 9, 10, 3)

chisquare <-function(Obs,Exp){
  sum((Obs-Exp)^2/Exp)
}

# chi-square of the table of the 70 random numbers and the distribution from the pareto function with scale = 1 and shape = 2
sampleChi = chisquare(sample, Expected*70)

Pvalue<- pchisq(sampleChi,4,lower.tail = FALSE); Pvalue #.07244 
# the .07244 p-value suggests the random numbers could be from a pdf f(x) = 2/x^3 for x >= 1.

# a second test with random samples from rpareto is done
N = 10^4-1; result = numeric(N)
for (i in 1:N){
  expData = rpareto(70, 1, 2)
  Counts=numeric(5) 
  Counts[1] = sum(expData < 1.5) 
  Counts[2] = sum((expData >= 1.5) & (expData < 2.0))
  Counts[3] = sum((expData >= 2.0) & (expData < 3.0))
  Counts[4] = sum((expData >= 3.0) & (expData < 5.0))
  Counts[5] = sum(expData >= 5.0)
  result[i] = chisquare(Counts, Expected *70)
}

hist(result, xlim = c(0,30), breaks = "FD",probability =TRUE)
curve(dchisq(x, df=4), col = "blue", add= TRUE)     #nearly perfect fit, as expectet
abline(v = sampleChi, col = "red")

Pvalue=(sum(result >= sampleChi)+1)/(N+1); Pvalue #.0716
# a similar p-value of .0716 is found which suggests this could be from the pdf f(x) = 2/x^3 for x >= 1.



#####
# 3.

# 14a. A test of homogeneity because we are determining if feelings are equally distributed 
# across two different populations

# replicate table from exercise 14 on pg. 71
Survey = c(rep("Like Very Much", 180), rep("Like", 260), rep("Neither", 137), rep("Dislike", 96), rep("Dislike Very Much", 52), rep("Like Very Much", 210), rep("Like", 266), rep("Neither", 145), rep("Dislike", 85), rep("Dislike Very Much", 49))
Gender = c(rep("Boys", 725), rep("Girls", 755))

table(Survey, Gender)

# built-in chi-square test
chisq.test(table(Survey, Gender)) # p=.5998


observed = chisq.test(table(Survey, Gender))$statistic

# test by permuting the sex column 
N = 10^4 -1; result <- numeric(N)
for (i in 1:N) {
  Gender.perm<-sample(Gender)
  result[i]<-chisq.test(table(Survey, Gender.perm))$statistic
}

hist(result, xlab="Chi-square Statistic")
abline(v = observed, col = "red")
pValue = (sum(result >= observed)+1)/(N+1);pValue # .592

# The test of homogeneity shows that the feelings are distributed equally across two populations (in this case, gender)
# Boys and girls do not significantly differ on their feelings towards the commercials. 


#####
# 4.

# exercise 22 on page 73

# N(22, 49) which is a mean = 22 and sd = 7

p = c(.2, .4, .6, .8)
qnorm(p, 22, 7)
# 16.10865 20.22657 23.77343 27.89135

# get data
ex22 = read.csv("Exercise22.csv")$var1

# count by interval 
Counts=numeric(5)
Counts[1] = sum(ex22 <= 16.10865) 
Counts[2] = sum((ex22 > 16.10865) & (ex22 <= 20.22657))
Counts[3] = sum((ex22 > 20.22657) & (ex22 <= 23.77343))
Counts[4] = sum((ex22 > 23.77343) & (ex22 <= 27.89135))
Counts[5] = sum(ex22 > 27.89135)
# number of values that fall in each interval 
Counts


# chi-square for comparing two vectors 
chisquare <-function(Obs,Exp){
  sum((Obs-Exp)^2/Exp)
}

Expected<-length(ex22)*c(.2, .2, .2, .2, .2);
chiStat<-chisquare(Counts,Expected);
Pvalue<- pchisq(chiStat,4,lower.tail = FALSE); Pvalue #.09 so yes it could have come from there

## or the chisq.test gives the same answer on counts, since the values should be equally distrbuted per range
chisq.test(Counts)

# p-value of .09 suggests that this set of numbers could be generated by N(22, 7^2).



#####
# 5.

# setwd("/Users/Ryan/Desktop")

Runs= read.csv("RedSox2013.csv")$R

meanRuns = mean(Runs) # 5.19 
meanRuns

# var(Runs) is 12+ so unlikely poisson is a good model 

# determine 5 ranges where the values should be equally distributed
qpois(c(.2, .4, .6, .8), meanRuns)
# the .2, .4, .6, and .8 quantiles are separated by 3, 4, 6, 7

# count the number of runs in each quantile 
Counts=numeric(5)
Counts[1] = sum(Runs <= 3) 
Counts[2] = sum((Runs > 3) & (Runs <= 4))
Counts[3] = sum((Runs > 4) & (Runs <= 6))
Counts[4] = sum((Runs > 6) & (Runs <= 7))
Counts[5] = sum((Runs > 7))

Expected<-length(Runs)*c(ppois(3.0, meanRuns, lower.tail = TRUE),ppois(4.0, meanRuns, lower.tail = TRUE)-ppois(3.0, meanRuns, lower.tail = TRUE),ppois(6.0, meanRuns, lower.tail = TRUE)-ppois(4.0, meanRuns, lower.tail = TRUE), ppois(7.0, meanRuns, lower.tail = TRUE)-ppois(6.0, meanRuns, lower.tail = TRUE),1-ppois(7, meanRuns, lower.tail = TRUE)); Expected

chisquare <-function(Obs,Exp){
  sum((Obs-Exp)^2/Exp)
}

result = chisquare(Counts, Expected)

Pvalue<- pchisq(result,4,lower.tail = FALSE); Pvalue

# The p-value is 4.333648e-06 which suggests the poisson with lamda of 5.19, the mean of the data,
# is not a good model. The variance is > 12 which means the mean and variance are not the same 
# and poisson is not a good approximation. 















