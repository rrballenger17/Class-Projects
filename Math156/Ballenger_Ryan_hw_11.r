
setwd("/Users/Ryan/Desktop")



#####
# 1.

# Exercise 12 on page 202. Also find a 95% t confidence interval, as in exercise 11 (the first section problem).

### 1.a)
girls = read.csv("Girls2004.csv")

smokeWeight = subset(girls$Weight, girls$Smoker=="Yes")

noWeight = subset(girls$Weight, girls$Smoker=="No")


plot(noWeight , col="blue", ylim=c(1500, 5000), ylab="Baby Weight", main="Smoke(Red), Non-smoke(Blue)")
par(new=T)
plot(smokeWeight, col="red", ylim=c(1500, 5000), ylab="Baby Weight", xlab="", xaxt='n')

abline(h=mean(noWeight), col="blue") 
abline(h=mean(smokeWeight), col="red") 


mean(noWeight) # 3401.58
mean(smokeWeight) # # 3114.636

sd(noWeight) # 526.1256
sd(smokeWeight) # 467.9971





### 1.b)
treated <- noWeight
control <- smokeWeight
M1<-mean(treated); 
M2<-mean(control); 
n1 <- length(treated); 
n2 <- length(control); 

S1<- sd(treated); 
S2<- sd(control); 

SE <- sqrt(S1^2/n1 + S2^2/n2)

#Welch's approximation (equation 7.11)
ndf <- (S1^2/n1 + S2^2/n2)^2/(S1^4/(n1^2*(n1-1)) + S2^4/(n2^2*(n2-1)));


tqnt<- qt(c(.05),ndf); tqnt


bound<- (M1-M2)+ SE*tqnt; 
bound # 14.99055 

# The bound shows that non-smoker babies outweight smoker babies
# by at least a mean difference of 14.99 95% of the time. Smoking is 
# hard on babies and stunts growth.


#####
# 2. Exercise 20 on page 205.

prop.test(459, 980, conf.level= .95)$conf
# 0.4368038 0.5001819

prop.test(426, 759, conf.level= .95)$conf
# 0.5250797 0.5968214

# It can be concluded that men vote for Bush more often or at a higher rate than women.



prop.test(c(426, 459), c(759, 980), correct=FALSE, conf.level= .95)$conf
#  0.04575569 0.14003926

# Again men vote for Bush at a higher rate, specifically
# it's 95% likely they vote with a higher rate between .05 and .14


# 

### permutation test


men = c(rep(1, 426), rep(0, 759-426))
women = c(rep(1, 459), rep(0, 980-459))
combine = c(men, women)
observed = mean(men) - mean(women)
counter <- 0; 
N = 10000;
result = numeric(N)
for (i in 1:N) {
	index = sample(length(combine), size=length(men), replace = FALSE) 
	result[i]=mean(combine[index])-mean(combine[-index])
}
pVal = (sum(result > observed) + 1)/length(result)
# 1e-04 Yes the permutation test indicates the difference is significant


### bootstrap t CI for men
voters <- men
xbar <- mean(voters); xbar  #sample mean
S <- sd(voters); S          #sample standard deviation
n <- length(voters)
SE <- S/(sqrt(n)) ; SE       #sample standard error


N = 10^4; Tstar = numeric(N) #vector of t statistics
for (i in 1:N) {
  x <-sample(voters, size = n, replace = TRUE)
  Tstar[i] <-(mean(x) - xbar)/(sd(x)/sqrt(n))
}

q<-quantile(Tstar, c(.025, .975), names = FALSE); q 

L <- xbar - q[2]*SE; U <- xbar - q[1]*SE; L; U
#[1] 0.5252784
#[1] 0.5966166 


### bootstrap t CI for women
voters <- women
xbar <- mean(voters); xbar  #sample mean
S <- sd(voters); S          #sample standard deviation
n <- length(voters)
SE <- S/(sqrt(n)) ; SE       #sample standard error

N = 10^4; Tstar = numeric(N) #vector of t statistics
for (i in 1:N) {
  x <-sample(voters, size = n, replace = TRUE)
  Tstar[i] <-(mean(x) - xbar)/(sd(x)/sqrt(n))
}

q<-quantile(Tstar, c(.025, .975), names = FALSE); q 

L <- xbar - q[2]*SE; U <- xbar - q[1]*SE; L; U
#[1] 0.4378164
#[1] 0.5001924


## bootstrap difference of means
xbar2 <- mean(women); 
xbar <- mean(men); 

n2 <- length(women)
n <- length(men)

N = 10^4; 
Tstar3 = numeric(N)


for (i in 1:N) {
  x <-sample(men, size = n, replace = TRUE)
  x2 <-sample(women, size = n2, replace = TRUE)
  Tstar3[i] = (mean(x) - mean(x2) - (xbar - xbar2))/sqrt(sd(x2)^2/n2  + sd(x)^2/n)
}

q<-quantile(Tstar3, c(.025, .975), names = FALSE); q 

SE = sqrt(sd(women)^2/length(women)  + sd(men)^2/length(men))

L <- xbar - xbar2 - q[2]*SE; 
U <- xbar -xbar2 - q[1]*SE; 
L; U
#[1] 0.04665965
#[1] 0.1399377

# which is near #  0.04575569 0.14003926





#####
# 3. 
# Exercise 36 on page 208. This problem will encourage you to read section 7.5 carefully!





#####
# 4.

cereal = c(560, 568, 580, 550, 581, 581, 562, 550)

quants = qchisq(c(.05, .95), df=8-1)

((8-1)*var(cereal)/quants[1])
((8-1)*var(cereal)/quants[2])

# 86.15824
# 559.2083

N(560,10^2)
N = 10^4
count = 0

for (i in 1:N) {
  x <-rnorm(100, 560, 10)
  quants = qchisq(c(.05, .95), df=100-1)
  one = ((100-1)*var(x)/quants[1])
  two = ((100-1)*var(x)/quants[2])

  if(100 < one & 100 > two) {
  	count = count + 1
  }
}

count/ N
# 0.8999 as expected for a 90% confidence interval


#####
# 5.
N = 3000

count =0
countTwo = 0
countThree = 0

for (i in 1:N) {
  x <-rnorm(2, 5, 2)
  
  low = mean(x)  - qcauchy(2/3) * sd(x)/sqrt(2) 
  high = mean(x)  - qcauchy(1/3) * sd(x)/sqrt(2) 

  if(5<low) count = count + 1
  else if(5< high) countTwo = countTwo + 1
  else countThree = countThree + 1
}

count/N
countTwo/N
countThree/N

# 0.3353333
# 0.333
# 0.3316667















