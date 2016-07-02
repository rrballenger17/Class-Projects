
# Ryan Ballenger
# Math 156 - HW#7


######
# 1.

# 1.a

N<-10000; 
means <-numeric(N); 

# find the mean of samples of exponential dist.
for (i in 1:N) {
  means[i] <- mean(rexp(50, 1/5))
}

k <- 6; mu <- 5; sigma <- sd(means) 

# sample the means, which are normally distributed
N<-10000; 
sumsq <- numeric(N); 
for (i in 1:N) {
  x <- sample(means, k)
  sumsq[i] <- sum((x-mu)^2)/sigma^2 
}

# sumsq is chi-square distribution with 6 degrees of freedom
hist(sumsq, xlim = c(0,4*k), breaks= "FD", probability = TRUE)
curve(dchisq(x,6), col = "red", add = TRUE)

# 1.b

N<-10000; 
xbars <-numeric(N); 

# the mean of 50 samples from unif[0,1]
for (i in 1:N) {
  x <- runif(50, 0, 1)
  x.bar <- mean(x)
  xbars[i] <- x.bar 
}

hist(xbars, xlim = c(0,4*k), breaks= "FD", probability = TRUE)

# t distribution: Numerator is the sample means subtracted by the actual mean and divided by the sd.
# Denominator is the re-scaled square root of the chi-square
newRV = ((xbars - .5)/sd(xbars))/sqrt(sumsq/6)

hist(newRV, 100, probability=TRUE)
curve(dt(x,6), col = "red", add = TRUE)


#####
# 2.


func =  function(k,t){
	(factorial((k + 1)/2 - 1))/
	(sqrt(pi * k) * factorial(k/2 - 1) *(1 + (t^2)/k)^((k+1)/2))
}

# 4 degrees of freedom
four =  function(t){
	(factorial((4 + 1)/2 - 1))/
	(sqrt(pi * 4) * factorial(4/2 - 1) *(1 + (t^2)/4)^((4+1)/2))
}
#explicit formula, df = 4
curve(four(x), col="blue", xlim=c(-2, 2))

# built-in dt() with df=4
curve(dt(x, 4), lty=2, col="red", xlim=c(-2, 2), add=TRUE)

# the lines match - blue solid and red dashed.

# 50,000 trials for 4 degrees of freedom
N<-50000; 
vars <-numeric(N); 
M4s <-numeric(N); 
for (i in 1:N) {
  x <- rt(100, 4)
  vars[i] = var(x)
  M4s[i] <- mean(x^4);
}
mean(vars) # near 2 which is 4/(4-2)
mean(M4s)    #fourth moment


# 5 degrees of freedom
five =  function(t){
	(factorial((5 + 1)/2 - 1))/
	(sqrt(pi * 5) * factorial(5/2 - 1) *(1 + (t^2)/5)^((5+1)/2))
}
# explicit formula, df=5
curve(five(x), col="blue", xlim=c(-2, 2))

# built-in dt() with df=5
curve(dt(x, 5), lty=2, col="red", xlim=c(-2, 2), add=TRUE)

N<-50000; 
vars <-numeric(N); 
M4s <-numeric(N); 
for (i in 1:N) {
  x <- rt(100, 5)
  vars[i] = var(x)
  M4s[i] <- mean(x^4);
}
mean(vars) # near 5/3 as expected, 5/(5-2)
mean(M4s) 



#####
# 3. 
N = 5000
mean <- numeric(N); 
var <- numeric(N); 
for (i in 1:N) {
	x = runif(6, -1, 1)
	mean[i] = mean(x)
	var[i] = var(x)
}


plot(var, mean^2)
cor(var, mean^2)

# the correlation in negative 
# A large variance occurs when the numbers are spread out. In this case, the + and - values cancel
# each other out and the mean is near 0. Secondly, when the mean^2 is large, the numbers are skewed
# to one side of unif[-1,1], causing the variance to be small. 


#####
# 4. 
#setwd("/Users/Ryan/Desktop")
ncb = read.csv("NCBirths2004.csv")

weights = ncb$Weight

mean = mean(weights)
sd = sd(weights)

N = 10000
means <- numeric(N);
sumOfSq <- numeric(N); 
vars <- numeric(N); 
for (i in 1:N) {
	sixSample = sample(weights, 6)
	six = (sixSample - mean)/sd;
	
	means[i] = mean(six)

	sumOfSq[i] = sum(six * six)

	vars[i] = var(six)
}

# 4.a Yes, 6*mean^2 is chi-square with df=1 
hist(means^2 * 6, breaks= "FD", probability = TRUE)
curve(dchisq(x,1), col = "red", add = TRUE)

# 4.b Yes
hist(sumOfSq, breaks= "FD", probability = TRUE)
curve(dchisq(x,6), col = "red", add = TRUE)

# 4.c Yes
newVars = vars * (5)
hist(newVars, breaks= "FD", probability = TRUE)
curve(dchisq(x,5), col = "red", add = TRUE)

# 4.d Yes
cor(means^2, vars)

# 4.e Yes 
possibleT = means / sqrt(vars/6)
hist(possibleT, breaks= "FD", probability = TRUE)
curve(dt(x,5), col = "red", add = TRUE)


#####
# 5.

mean = 18.05
sd = 5

# normal with unknown population mean and sd
# use sample mean and sd and a t confidence interval 


lower = mean - qt(.95, 20 - 1) * sd /  sqrt(20)
upper = mean + qt(.95, 20 - 1) * sd /  sqrt(20)
lower; upper;

#rnorm(1000, 18.05, 5)

counter <- 0
plot(x =c(14,22), y = c(1,100), type = "n", xlab = "", ylab = "") #blank plot
for (i in 1:1000) {
  x <-rnorm(20, mean, sd) #random sample
  L <- mean(x) + qt(0.05, 19) * sd(x)/sqrt(20) #usually less than the true mean
  U <- mean(x) + qt(0.95, 19) * sd(x)/sqrt(20) #usually greater than the true mean


  if (L < mean && U > mean) counter <- counter + 1 #count +1 if we were correct
  if(i <= 100) segments(L, i, U, i)
}
abline (v = mean, col = "red") 
counter/1000 # 0.901 as expected


#####
# 6. 

# 500 samples
mean = 5.29
sd = 3.52

lowerBound = mean - qt(.75, 500 - 1) * sd / sqrt(500)
lowerBound
# interval: [5.18, Inf.)

count = 0

for (i in 1:10000) {
	samples = rgamma(500, 2.040815, .408163)

	lowerBound = 5 - qt(.75, 500 - 1) * 3.5 / sqrt(500)
	lowerBound

	if(mean(samples) >= lowerBound) count = count + 1  
}

count / 10000
# 0.7496, it holds up well











