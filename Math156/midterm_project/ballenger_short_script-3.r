
# Ryan Ballenger
# City of Chicago Schools Data
# Midterm Project Short Script

# Load data
datafull = read.csv("data_full.csv")

datafull$College.Enrollment.Rate.Percentage.2013 = as.numeric(sub("%", "", datafull$College.Enrollment.Rate.Percentage.2013))

chicago = read.csv("data_edited.csv")

chicago$College.Enrollment.Rate.Percentage.2013 = as.numeric(sub("%", "", chicago$College.Enrollment.Rate.Percentage.2013))





# The histogram illustrates college enrollment rates for all the City of Chicago schools. It shows most schools have a college 
# enrollment rate around 50% while some schools have enrollment rates as little as 20% and some have rates as high as 90%. 
hist(chicago$College.Enrollment.Rate.Percentage.2013, main="College Enrollment Rates", xlab="Rate %", ylab= "Frequency")





# Probability density graph overlaid on a histrogram 
# The enrollment rates are again displayed as a histogram with more columns shown to give a more precise perspective on the data. I 
# then calculate the mean and standard deviation of the enrollmenet rates to create a normal distribution. The probability density 
# graph for a normal distribution with the corresponding mean and standard deviation is overlaid on the histrogram. 
hist(chicago$College.Enrollment.Rate.Percentage.2013, probability=TRUE, 20)
enrollMean = mean(chicago$College.Enrollment.Rate.Percentage.2013)
enrollSD = sd(chicago$College.Enrollment.Rate.Percentage.2013)
curve(dnorm(x, mean = enrollMean, sd = enrollSD), col ='blue', add=TRUE)





# A permutation test
# For the permutation test, the relationship between family involvement ratings and college enrollment rates is analzed. The highest 
# ratings for family involvement are STRONG and VERY STRONG and the index for schools with these ratings are determined. The observed
# statistic is the difference between means of college enrollment rates for schools with the above mentioned family involvement ratings and
# the those with other possible ratings NEUTRAL, WEAK, VERY WEAK, and NOT ENOUGH DATA. The observed difference in means is 10.892 which is
# relatively high but the permutation test reveals if it is significant. Next, samples of college enrollment rates, of the corresponding size,
# are taken and the difference between the mean for this group and the remaining schools is saved in result. The number of results 
# greater than or equal to the observed difference is determined and divided by the total number of results to find the p-value. The permutation test
# shows that there is a significant difference with a p-value of 0.00146. A STRONG or VERY STRONG rating for family involvement at a school
# corresponds to higher college enrollment rates. 
index<-which(chicago$Involved.Family == 'STRONG' | chicago$Involved.Family == 'VERY STRONG')

observed<-mean(chicago$College.Enrollment.Rate.Percentage.2013[index])-mean(chicago$College.Enrollment.Rate.Percentage.2013[-index])
N=10^5-1; result<-numeric(N) 
for (i in 1:N) {
  # A sample of the same size as the index
  index = sample(nrow(chicago), size=length(index), replace = FALSE)
  result[i]=mean(chicago$College.Enrollment.Rate.Percentage.2013[index])-mean(chicago$College.Enrollment.Rate.Percentage.2013[-index])
}
hist(result, breaks = "FD", xlab="Difference of Means")
abline(v = observed, col = "red")
scoreWell<-which(result >= observed)
pVal<-(length(scoreWell)+1)/(length(result)+1) 
pVal # .00139, which is significant 





# CHI-SQUARE and Simulation 
# For this analysis, the college enrollment rates are compared with a normal distribution. 
# First the mean and standard deviation for the enrollment rates are determined. The qnorm function
# is used to determine 5 equal enrollment ranges that should include 20% of the enrollment rates if
# it is a normal distribution. The number of enrollment rates in each range is determined and saved in 
# Counts. A chi-square test with the Counts and the expected number of rates shows a p-value of .565, meaning
# the enrollment rates could have come from the normal distribution. 
mean = mean(chicago$College.Enrollment.Rate.Percentage.2013)
sd = sd(chicago$College.Enrollment.Rate.Percentage.2013)
enrollment = chicago$College.Enrollment.Rate.Percentage.2013

# Five ranges are found with the quantile function. 
p = c(.2, .4, .6, .8)
qnorm(p, mean, sd)
# 43.23278 52.87487 61.17983 70.82192

# Enrollment rates in each range are counted 
Counts = numeric(5)
Counts[1] = sum(enrollment <= 43.23278)
Counts[2] = sum((enrollment > 43.23278) & (enrollment <= 52.87487))
Counts[3] = sum((enrollment > 52.87487) & (enrollment <= 61.17983))
Counts[4] = sum((enrollment > 61.17983) & (enrollment <= 70.82192))
Counts[5] = sum(enrollment > 70.82192)
Counts

chisquare <- function(Obs, Exp){
  sum((Obs-Exp)^2/Exp)
}
Expected <- length(enrollment) * c(.2, .2, .2, .2, .2)
chiStat <- chisquare(Counts, Expected)
Pvalue <- pchisq(chiStat, 4, lower.tail = FALSE)
Pvalue





# For this test, I consider a scenario where 10 students from another district must be reassigned 
# to City of Chicago schools because of overcrowding. As their previous administrator, I want to 
# determine the probability that 5 or 6 of them are assigned to city schools that are rated STRONG 
# or VERY STRONG for safety. First the pbinom functin is used to determine the exact chance of this 
# occurring which is .0555243. It is low because only ~23% are rated well for safety. 
#    The CLT approximation is done with continuity correction. The mean and standard deviation 
# are found for the normal distribution of 10 kids assigned to city schools. The CLT approximation 
# reveals that there is 0.04911265 chance of the previously mentioned event. The continuity correction
# improves the accuracy of this measurement. CLT performs well because .049113 is similar to the actual 
# value of .0555243.
#   Lastly a simulation is done. 10 City of Chicago schools are repeated selected the number of schools 
# with strong safety ratings are determined. The probability of 5 or 6 schools being rated well for safety
# is .0523. The simulation also finds a probility that is near the actual percent chance determined by 
# the pbinom function. In this case the simulation finds a slighly more accurate percentage than the 
# CLT approximation but both methods approximate the chance of this event well. 

safeRate = mean(chicago$Safe == "VERY STRONG" | chicago$Safe == "STRONG")
pbinom(6, 10, safeRate) - pbinom(4, 10, safeRate)
#  0.0555243

mean = 10 * safeRate
sd = sqrt(safeRate * (1-safeRate) * 10)
pnorm(6.5, mean, sd) - pnorm(4.5, mean, sd)
# CLT with continuity correction 
# 0.04911265, almost precisely correct whereas without continuity correction, it was over-estimating at 0.09922008

# simulation
N = 10000; my.sums = numeric(N)
for (i in 1:N) {
  sample = sample(chicago$Safe, 10, replace=TRUE)
  my.sums[i] = sum(sample == "VERY STRONG" | sample == "STRONG")
}
mean(my.sums > 4 & my.sums <=6)
# 0.0523





# A graphical display that is different from those in the textbook or in the class scripts.
pie(table(chicago$Safe), main="Safe")
# This graph gives insight into how people vote overall. 
# ~40% neutral, interestingly weak is larger than strong. Perhaps Chicago's neighborhoods are unsafe
# or people are generally converned about safety leading to an interpratoin of WEAK safety. 



