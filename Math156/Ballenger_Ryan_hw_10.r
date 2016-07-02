
#####
# 1.
winProb = c(.1, .3, .6, .7, .8)
creatures = c(1, 2, 3, 3, 1)
creatures = creatures/sum(creatures)
prior = creatures

# win 2, lose #3
# posterior distribution for prob of selecting each type 

likelihood <- winProb^2 * (1-winProb)^3; likelihood 

P2W3L<-sum(prior* likelihood); 
P2W3L

posterior <-prior * likelihood/ P2W3L; 
posterior
#0.03984477 0.33745081 0.37778749 0.21693266 0.02798426


### 1.b
prior = posterior
likelihood <- winProb^3 * (1-winProb)^7; likelihood

P3W7L<-sum(prior* likelihood); 
P3W7L

posterior <-prior * likelihood/ P3W7L; 
posterior
#  0.0207248400 0.8159861026 0.1453930050 0.0176966106 0.0001994417


### 1.c
winProb = c(.1, .3, .6, .7, .8)
creatures = c(1, 2, 3, 3, 1)
creatures = creatures/sum(creatures)
prior = creatures


likelihood <- winProb^5 * (1-winProb)^10; likelihood
P5W10L<-sum(prior* likelihood); 
P5W10L
posterior <-prior * likelihood/ P5W10L; 
posterior
#  0.0207248400 0.8159861026 0.1453930050 0.0176966106 0.0001994417





#####
# 2.

# score confidence interval 
# from ch. 7.4
prop.test(160, 178, conf.level=.95)
# 0.8425626 0.9372989

# confidence interval - option 2
# also from ch. 7.4 
success = 160
total = 178
theta = success/total
theta_tilda = (success + 2) / (total + 4)
n_tilda = total + 4

theta_tilda + qnorm(.975)* sqrt(theta_tilda * (1-theta_tilda)/n_tilda)
theta_tilda - qnorm(.975) * sqrt(theta_tilda * (1-theta_tilda)/n_tilda)
# 0.8446725 to  0.9355473

### 2. b, c, d.

## Statistician #1
# beta, mean .85, var .0025
E <- 0.85; 
V <- 0.0025 
alpha <- (E^2 - E^3)/V - E
beta <- alpha/E - alpha

curve(dbeta(x, alpha, beta), ylim=c(0, 20))

alpha = alpha + 160
beta = beta + 18

curve(dbeta(x, alpha, beta), add=TRUE)
# posterior mean 
mu <-alpha/(alpha+beta); 
mu 
# 0.8881579

#95% credible interval
qbeta(c(.025, .975), alpha, beta)
# 0.844250 0.925627

# probability theta is > 90
1- pbeta(.9, alpha, beta)


## Statistician #2
# flat prior 
alpha = 1
beta = 1
curve(dbeta(x, alpha, beta), ylim=c(0, 20))

alpha = alpha + 160
beta = beta + 18
curve(dbeta(x, alpha, beta), add=TRUE)

mu <-alpha/(alpha+beta); 
mu
#0.8944444

qbeta(c(.025, .975), alpha, beta)
#0.8457338 0.9348730

# probability theta is > 90
1- pbeta(.9, alpha, beta)


## Statistician #3
# beta 6, 4
alpha = 6
beta = 4
curve(dbeta(x, alpha, beta), ylim=c(0, 20))

alpha = alpha + 160
beta = beta + 18
curve(dbeta(x, alpha, beta), add=TRUE)

mu <-alpha/(alpha+beta); 
mu 
#0.8829787
qbeta(c(.025, .975), alpha, beta)
# 0.8334713 0.9247833

# probability theta is > 90
1- pbeta(.9, alpha, beta)





#####
# 3.
# p. 324, ex. 8

sampleSize = 60
sampleVar = 116^2
sampleMean = 538

priorVar = 25^2
priorMean = 600


A<- sampleSize/sampleVar 
A0<- 1/priorVar
A1<- A0 + A 
SD = sqrt(1/A1) 
SD
# 12.84696

# the posterior mean
M<- sampleMean 
M0 <- priorMean 
M1 <- (A0*M0 + A*M)/(A0 + A)
M1
# 554.3724

### 3.b
qnorm(c(.025, .975), M1, SD)
# 529.1928 579.5520

### 3.c
1-pnorm(600, M1, SD)
# 0.0001914289





#####
# 4.

### 4.a) likelihood 
#		theta^(N * summation Xi) * e ^(-N * theta) / product (Xi!)

### 4.b) write out the posterior density
#		theta^(N * summation Xi) * e ^(-N * theta) / product (Xi!)
#			* (lamda ^ r / gamma(r))^N * product(Xi ^(r-1)) * e^(lambda * summation Xi) 

### 4.c) gamma distribution with (sum xi + r, n + lambda)

### 4.d) 
r = 15 + 6 + 7 + 9 + 9 + 16
lambda =  3 + 5

# posterior density => gamma(r=62, lambda=8)


### 4.e)
# 95% confidence interval 
qgamma(c(.025, .975), r, lambda)
# 5.941881 9.794631


### 4.f)
# r/lamda
# r/lamda^2
r = 16
lambda = 2

# same observed values -> find posterior
r = r + 6 + 7 + 9 + 9 + 16
lambda = lambda + 5
# posterior gamma(r=63, lambda=7)

#plot prior and posterior and 95% interval for each
curve(dgamma(x, 16, 2), xlim=c(0,20), ylim=c(0, .4))
curve(dgamma(x, 63, 7), add=TRUE, col="green")

abline(v=qgamma(c(.025,.975),  16, 2))
abline(v=qgamma(c(.025,.975),  63, 7), col="green")





#####
# 5.
n<-c(551, 602, 623, 496, 588, 589) 
X<-c(176,182,188,145,173,190) 

alpha<- X 
beta<- n-X 


N <- 10^5  
theta<- matrix(0,0, nrow = N, ncol = 6) 
for (j in 1:6) {
  theta[ ,j] <- rbeta(N, alpha[j], beta[j]) 
}
head(theta)


probBest <- numeric(6) 
best <- apply(theta, 1, max) 
for (j in 1:6) {
  probBest[j] = mean(theta[ ,j] == best)
}
probBest

# 0.33477 0.08764 0.08132 0.04353 0.04122 0.41152

# Salvador Perez and Jean Segura both have a <5% chance of being
# the best top hitter.

### 5.b


p<-X/n 

N <- 10^5  
sales<- matrix(0,0, nrow = N, ncol = 6) 
for (j in 1:6) {
  sales[ ,j] <- rbinom(N, 600, p[j])
}
head(sales)


numTop <- numeric(6)
best <- apply(sales, 1, max) 

for (j in 1:6) {
  numTop[j] = mean(sales[ ,j] == best) 
}
numTop; sum(numTop)  
probTop<-numTop/sum(numTop); 
round(probTop,5)
# 0.33397 0.09277 0.08617 0.03549 0.04169 0.40990

# Salvador Perez and Jean Segura both have a <5% chance of being
# the best top hitter.












