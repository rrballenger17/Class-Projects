
# Ryan Ballenger
# MATH156 HW#3 


#####
#1a
	# setwd("/Users/Ryan/Desktop")

	Phil = read.csv("Phillies2009.csv")

	# Away Strikeouts (ASO)
	ASO = subset(Phil$StrikeOuts, Phil$Location=="Away")

	# Home Strikeouts 
	HSO = subset(Phil$StrikeOuts, Phil$Location=="Home")

	plot.ecdf(ASO)
	plot.ecdf(HSO, col="blue", add = T)

	# Comparison: Home strikeouts has a steeper incline from .2 to .8 of Fn(x).
	# This means that there are generally less strikeouts at home games. At the peak of 
	# the CDF, the home strikeouts flattens further right than away strikeouts, which means
	# homegames have a few very high strikeout games, that are greater than away games. 
	# However, as mentioned first, the majority of the home games' CDF is to the left of 
	# the away game's CDF at the  same height, meaning homegames generally have the lower 
	# strikeout counts.

#1b
	#home
	mean(HSO)

	#away
	mean(ASO)

#1c
	
	index = which(Phil$Location == "Home")
	
	# observed is mean strikeouts away minus mean strikeouts at home
	observed<-mean(Phil$StrikeOuts[-index])-mean(Phil$StrikeOuts[index]); observed
	# observed = .358

	N=10^5-1; result<-numeric(N) 
	for (i in 1:N) {
    	index = sample(length(Phil$StrikeOuts), size=length(index), replace = FALSE)
    	result[i]=mean(Phil$StrikeOuts[-index])-mean(Phil$StrikeOuts[index])
	}
	
	hist(result, breaks = "FD")
	abline(v = observed, col = "red")

	more<-which(result >= observed)
	pVal<-(length(more)+1)/(length(result)+1)
	pVal
	# pVal = .21
	# The permutation test reveals a p-value of .21 which is not significant. Therefore
	# the difference could have occurred by chance.

	
#####
#2 
	cereals = read.csv("Cereals.csv")
#12a 
	# summarizes relationship between age of consumer and shelf location
	CATable = table(cereals$Age, cereals$Shelf)
	CATable

#12b
	chisq.test(CATable)

#12c
	Obs = CATable
	Expected <- outer(rowSums(Obs), colSums(Obs))/sum(Obs);
	Expected
	# The expected counts for each cell are much different than the actual values. 
	# The expected values are evenly distributed whereas the actual values aren't (e.g. 18, 1, etc.).
	# This implies there's a non-random factor in the placement of the cereals which 
	# the chi-squared test detects and warns about.

#12d
	observed = chisq.test(CATable)$statistic
	observed 

	N<- 10^4 - 1
	result <- numeric(N)

	for(i in 1:N){
    	age.permuted = sample(cereals$Age)
    	newTable = table(age.permuted, cereals$Shelf)
    	result[i] = chisq.test(newTable)$statistic
 	}

 	hist(result, xlab = "chi-square statistic", main="Distribution of chi-square statistic")
 	abline(v=observed, col = "blue")

 	pVal = (sum(result >= observed) + 1)/(N+1)
 	pVal

 	# p-value = 1*10-4
 	# The p-value from the permutation test is 1*10-4 which is very significant. The two factors
 	# age and shelf are not independent. Of course, the relationshp is adult cereals towards the 
 	# top shelves and children's towards the bottom.


#####
#3#a
	# setwd("/Users/Ryan/Desktop")
	FD = read.csv("FlightDelays.csv")

	JuneDelays = subset(FD$Delay, FD$Month == "June")
	MayDelays = subset(FD$Delay, FD$Month == "May")

	# proportion of June delays greater than 20 mins.
	mean(JuneDelays > 20) 

	# proportion of May delays greater than 20 mins.
	mean(MayDelays>20)

	observed <- mean(JuneDelays > 20) - mean(MayDelays>20); observed 

	# find length of two delays data sets
	lMay = length(MayDelays)
	lJune = length(JuneDelays)

	N = 10^4 -1 ; result <- numeric(N)
	for (i in 1:N) {
    	index <- sample(lMay+lJune, size = lMay, replace = FALSE)

    	# May sample - proportion greater than 20 mins.
    	MSM = mean(FD$Delay[index] > 20);

    	# June sample - proportion greater than 20 mins.
    	JSM = mean(FD$Delay[-index] > 20);

    	result[i]<- JSM - MSM
	}
	hist(result, breaks = "FD") 
	abline(v = observed, col = "red") 
	pVal <-(sum ( result >= observed) +1)/(N+1); 2*pVal 
	# 0.0188

	# for two-sided p-test, conduct test again sampling for June this time 
	# also reverse the the difference measured to May proportion - June proportion
	observed <- mean(MayDelays>20) - mean(JuneDelays > 20); observed 

	N = 10^4 -1 ; result <- numeric(N)
	for (i in 1:N) {
    	# sample for June delays
    	index <- sample(lMay+lJune, size = lJune, replace = FALSE)

    	# May sample - proportion greater than 20 mins.
    	MSM = mean(FD$Delay[-index] > 20);
    	# June sample - proportion greater than 20 mins.
    	JSM = mean(FD$Delay[index] > 20);
    	result[i]<- MSM - JSM
	}
	hist(result, breaks = "FD") 
	abline(v = observed, col = "red") 
	pVal <-(sum ( result <= observed) +1)/(N+1); 2*pVal 
	# 0.0162


	# the 2nd p-value is smaller. 2*pVal is approximately 0.0162.
	# The two-sided test reveals that the difference between months is significant, since 
	# the p-value is .0162. 


#3b
	var(JuneDelays)
	var(MayDelays)

	# find the ratio of variances of delays in June and May
	observed = var(JuneDelays)/var(MayDelays); observed  

	# subtract the mean from both sets of data
	x.zero = JuneDelays - mean(JuneDelays)
	y.zero = MayDelays - mean(MayDelays)
	delays = c(x.zero, y.zero)
	
	N=10^4-1 ; result<-numeric(N)
	for (i in 1:N) {
  		index <- sample(length(delays), size=length(MayDelays), replace = FALSE) #random large subset
  		result[i]<- var(delays[-index])/var(delays[index])
	}
	hist(result, breaks = "FD", prob = TRUE)

	abline(v = observed, col = "red")
	pValue = (sum (result >= observed) + 1)/(N+1); 2*pValue 
	# ~.0328

	# second test for the other side of 2-sided test
	# flip the ratio to May variance over June variance and sample for June delays directly
	# the same mean-subtracted data is used for this test
	observed = var(MayDelays)/var(JuneDelays); observed  
	N=10^4-1 ; result<-numeric(N)
	for (i in 1:N) {
  		index <- sample(length(delays), size=length(JuneDelays), replace = FALSE) #random large subset
  		result[i]<- var(delays[-index])/var(delays[index])
	}
	hist(result, breaks = "FD", prob = TRUE)

	abline(v = observed, col = "red")
	pValue = (sum (result <= observed) + 1)/(N+1); 2*pValue 
	# ~.0348

	# smaller 2*p-value is .0328 which is significant.

	# Yes, the the Fratio is significantly different than 1, because the 
	# p-value for the two-sided test is .0328. This is a significant p-value. 
	# This is because June's delays have much greater variance than May's.

#####
#4a
	# exact permutation test - last four games include 4 or more wins
	Season = c("L", "W", "L", "W", "L", "W", "W", "L", "L", "L", "W", "L", "W", "W", "W", "W")

	AllSubsets<-combn(1:16,6) 
	NPerm<-ncol(AllSubsets); NPerm;  
	wins <-numeric(NPerm);

	for (i in 1:NPerm) {
		index=AllSubsets[,i]
		wins[i]=sum(Season[index] == "W")
	}

	barplot(table(wins), xlab = "Wins", ylab="Frequency", main = "Last Six Games Test")
	prob = mean(wins >= 4); prob
	# 45.1% chance 
	# This is an incredibly high probability and suggests the last 4 wins were by chance.

#4b

	# my phyper function means there are 7 losses, 9 wins, 6 new attempts, and find the probability 
	# of 2 or less losses in total. Similarly, I could have found 1 - phyper(3,9,7,6) to emphasize wins but this
	# way is simpler without subtracting from 1. 
	hyperProb = phyper(2,7,9,6); hyperProb
	# exactly the same probability as 4a. is found: 0.451049
	# meaning 45.1049 % chance of 4 or more wins, suggesting the 4 wins in the last 6 games was by chance.

#4c
	# I find the number of successes in 6 trials with a 9/16 chance of success.
	# 10^4 of random deviates are created and the mean of those greater than or equal to 4 is found.
	# That mean is the probability of 4 or more wins in the last 6 games.
	wins = rbinom(10^4, 6, 9/16)	
	mean(wins >= 4)
	# .4606 or 46.06 % chance of winning 4 of 6 games

	# I used rbinom because an approximation is requested. Similarly, the distribution could be used
	# to make an estimate. 
	binomProb = 1 - pbinom(3, 6, 9/16); binomProb;
	# 0.4669329
	# this finds the probability of 3 or less wins and substracts it from 1. That's equivalent to p(4 or more wins)	

#4d 
	N = 10000
	for (i in 1:N) {
		index=sample(16, 6, replace = FALSE)
		wins[i]=sum(Season[index] == "W")
	}
	barplot(table(wins), xlab="Wins", ylab="Frequency", main="10,000 Samples of 6 Games")
	prob = mean(wins >= 4); prob
	# .4488 or 44.88% chance of 4 or more wins 

#####
# 5.
	#Hypothesis: Yes, more women tend to try low-fat diets than men. Gender and diet aren't independent.

	G = c(rep("M", 105), rep("W", 181))
	D = c(rep("Y", 8), rep("N", 97), rep("Y", 35), rep("N", 146))
	GDTable = table(G, D)


	chisq.test(GDTable)
	# p-value = 0.01239 
	# This p-value is significant which means there is a relationship between gender and diet

	observed = chisq.test(GDTable)$statistic; observed

	dataFrame = data.frame(G, D)
	N = 10^4-1; result<- numeric(N)
	for (i in 1:N) {
  		# permute the diet data of "Y" and "N" 
  		diet.permuted <- sample(D, replace=FALSE)

  		# the new table is the same gender data and the permuted diet data
  		newTable <- table(G, diet.permuted)

  		# save the chisq statistic of the resulting table
  		result[i]= chisq.test(newTable)$statistic
	}

	hist(result, probability = TRUE, xlab="Chi-squared Statistic")

	abline(v = observed, col="red")
	
	Pvalue <- (sum(result >= observed) +1)/(N+1); Pvalue
 	# approx. .0098
 	# This is statistically significant 

 	# The .0098 p-value is agreeable to the .01239 p-value. Both show that the data is not independent
 	# and that diet and gender are related. The relationship is that more women try low-fat diets than men.














