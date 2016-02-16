# Ryan Ballenger
# Math 156 HW1 R Script

# 1. Download and install R
# credit for submitting r Script 

#setwd("/Users/Ryan/Desktop")


#####
# 2. load flight delays CSV 
FD <- read.csv("FlightDelays.csv")

# 2. tapply finds the median flight delay by day
tapply(FD$Delay, FD$Day, median) 

# 2. mean flight delay for flights on AA on Wednesday 
# the subset delays of AA flights on Wed. is found and the mean is taken
mean(subset(FD$Delay, FD$Carrier=="AA" & FD$Day=="Wed"))

# 2. histogram of all flight lengths
# a histogram of all flight lengths is produced
hist(FD$FlightLength, breaks="FD", main="All Flight Lengths", xlab="Flight Length in Minutes", ylab="Frequency" )

# 2. histogram of all flight lengths to Den
# the subset of flight lengths going to Denver is found and posted into a histogram
hist(subset(FD$FlightLength, FD$Destination=="DEN"), breaks="FD", xlim=c(225, 325), main="Flights to Denver", xlab="Flight Lengths", ylab="Frequency")





##### 
# 3.
# load Dice CSV
Dice <- read.csv("Dice3.csv")

# twoMatch function takes Dice as a parameter and finds the subset of rolls with two matching dice values
twoMatch <- function(d){ 
	subset(d, (d$Red3 == d$Green3 | d$Green3 == d$White3 | d$Red3 == d$White3)
		& (d$Red3 != d$Green3 | d$Green3 != d$White3)
	)
}

# noMatch function takes Dice as a parameter and finds the subset of rolls with no matching dice values
noMatch <- function(d){
	subset(d, d$Red3 != d$Green3 & d$Green3 != d$White3 & d$Red3 != d$White3)
}

# probability all dice match. The subset of rolls with all matching dice values is counted
# and divided by the total number of possible dice rolls
P1 = nrow(subset(Dice, Dice$Red3==Dice$Green3 & Dice$Green3 ==Dice$White3))/nrow(Dice)
P1

# probability two and only two dice match. The subset of rolls with two matching dice is counted
# and divided by the total number of possible dice rolls
P2 = nrow(twoMatch(Dice))/nrow(Dice)
P2

# probability no dice match. The subset of rolls with no matching dice is counted
# and divided by the total number of possible dice rolls
P3 = nrow(noMatch(Dice))/nrow(Dice)
P3





#####
#4. 
# quiz scores can be manually entered by the user
QEdit = data.frame(Q1=numeric(),Q2=numeric())
QEdit = edit(QEdit) 
QEdit

# the rep() function is used to produce quiz score data frame
# Q1 is produced using 100% on the first 4 quizes and 0's on the next 12
# Q2 is produced using a repeating 0%,0%,0%, 100% four times
# lastly, the quiz scores are inputted into the QRep data.frame
Q1<-c(rep(1, 4), rep(0, 12)); Q1
Q2<-rep(c(0,0,0,1),4); Q2
QRep<-data.frame(Q1=Q1, Q2=Q2); QRep

# expand.grid is used to create all the possible quiz outcomes 
# where each quiz has 1/4 probability of 100% and 3/4 probability of 0%
QGrid <- data.frame(expand.grid(Q1=c(0, 0, 0, 1), Q2=c(0, 0, 0, 1)))
QGrid

# 4.2
# random variable for the average quiz score which ranges from 0% to 100%
X <- data.frame(value = (QGrid$Q1 + QGrid$Q2)/2.0*100.0)

# random variable for improvement with 0 being worse, 1 being the same, and 2 being improvement
# on the second quiz
Y <- data.frame(value = (-1*QGrid$Q1 + QGrid$Q2 + 1))

# E[X*Y] - E[X]*E[Y] = 0
colMeans(X * Y) - colMeans(X)*colMeans(Y)

# E[X^2*Y^2] - E[X^2]*E[Y^2] != 0
colMeans(X^2 * Y^2) - colMeans(X^2)*colMeans(Y^2)

#event A: 1 if X > 50 and 0 otherwise
#event B: 1 if Y >= 1 and 0 otherwise

# P[A intersect B] by counting rows
product = data.frame(value = (X > 50)*(Y >= 1))
nrow(subset(product, value > 0))/nrow(product); 
# P[A intersect B] by mean (only for verification)
# mean((X > 50)*(Y >= 1)); 


# P[A] * P[B] found by counting rows
nrow(subset(X, value > 50))/nrow(X)*nrow(subset(Y, value >= 1))/nrow(Y); 
# P[A] * P[B] found with mean (only for verification)
#mean(X > 50)*mean(Y >= 1);





######
# 5.a 
# the probability of 8 red and 7 blue balls being chosen
# from 30 red and 20 blue balls total. The total number of ways to get 8 red balls
# multiplied by the total ways to get 7 blue balls divided by the number of ways 
# to chose 15 of 50 balls
probability <- choose(30, 8) * choose(20, 7) / choose(50, 15)
probability 

# 5.b
# each possible value of red balls from 0 to 15 is multiplied by the probability of 
# chosing that many red balls, which is found the same way as in 5.a
redballs <- 0
draws = 15
for(x in 0:draws){
	redballs = redballs +   x * choose(30, x)*choose(20, draws - x) / choose(50, draws)
}
redballs

#5.c
# a vector for the 50 balls is made with 1 being a red and 0 being a blue ball.
# 1000 samples of 15 balls from 50 balls are taken without replacement. The number
# of red balls is summed for each sample of 15 balls. The probability of 8 red balls and the
# expected number of red balls is outputted. 
vector <- c(rep(1, 30), rep(0, 20))
results = rep(-1, 10000)
for(i in 1:10000){
	results[i] = sum(sample(vector, 15, replace = FALSE))
}

# fraction of time you get 8 red balls
sum(results == 8)/10000

# mean number of red balls 
sum(results)/10000





#####
#6
cereals = read.csv("Cereals.csv")

#6.a
# a barplot showing the number of cereals per shelf is displayed
barplot(table(cereals$Shelf), ylim=c(0, 25), xlab="Shelf", ylab="Total", main="Cereals Counts")

#6.b
# a histogram showing the amount of sodium in each box of cereal is displayed
hist(cereals$Sodiumgram, xlab="Grams of Sodium", ylab="Number of Cereals", main="Sodium in Cereals")

#6.c
# a table shows the number of cereals on each shelf by the age for each cereal
table(cereals$Age, cereals$Shelf)

#6.d
# the average amount of protein is determined by the age-group of the cereals
tapply(cereals$Proteingram, cereals$Age, mean)

#6.e 
# Extract a subset of one numeric variable (Proteingram) for one factor (cereals$Shelf == "bottom").
# the protein grams for all cereals that are on the bottom shelf are extracted 
cereals$Proteingram[which(cereals$Shelf == "bottom")]
















