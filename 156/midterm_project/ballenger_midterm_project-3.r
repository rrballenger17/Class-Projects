# Ryan Ballenger
# City of Chicago Schools Data
# Midterm Project 

#setwd("/Users/Ryan/desktop")

# The dataset is from the City of Chicago and is about the progress of students in their schools. 
# The URL for the data is https://data.cityofchicago.org/Education/Chicago-Public-Schools-High-School-Progress-Report/2m8w-izji
# It includes 97 columns and 100+ rows including data on ACT scores, attendance rates, teaching ratings, and more. 
datafull = read.csv("data_full.csv")

# Percentages are coverted to numerics to enable calculations.
datafull$College.Enrollment.Rate.Percentage.2013 = as.numeric(sub("%", "", datafull$College.Enrollment.Rate.Percentage.2013))

# For most of my calculations I am using 5 columns from the above dataset. The college enrollment rate, average ACT score, 
# ratings for the student's family involvement, ratings for supportive environment, and ratings for safety. In the edited data, 
# I extrapolate all the rows of data that provide ACT scores and college enrollment rates which are 117 of the 188 schools. 
# The categorical columns are the ratings on family involvement, supportive environment, and safety. The numeric columns are 
# ACT scores and college enrollment rates. 
chicago = read.csv("data_edited.csv")

# Percentages are coverted to numerics to enable calculations.
chicago$College.Enrollment.Rate.Percentage.2013 = as.numeric(sub("%", "", chicago$College.Enrollment.Rate.Percentage.2013))




##### 
# Required techical elements - graphical display

# 1. 
# The barplot displays how often certain responses to ratings are given. Each possible rating is not given the same amount 
# and nuetral occurs the most followed by weak and strong. This probably reflects the state of parent involvement for students
# in Chicago City Schools and parents are most likely to be either neurtral about or weakly involved with their child's education.
# First I create the table for this data and order the columns into a more logical order of very strong, strong, neurtral, and so on.
barTable = table(chicago$Involved.Family)[c(2,5,6,1, 3,4)]
barplot(barTable, main="Involved Family Rating", xlab="Rating", ylab="Frequency")

# 2.
# The histogram illustrates college enrollment rates for all the City of Chicago schools. It shows most schools have a college 
# enrollment rate around 50% while some schools have enrollment rates as little as 20% and some have rates as high as 90%. The histogram
# captures the overall occurrence of enrollment rates which is useful for further calculations in this area. I retrieve the enrollment
# rates and call the histogram function on this data.
hist(chicago$College.Enrollment.Rate.Percentage.2013, main="College Enrollment Rates", xlab="Rate %", ylab= "Frequency")

# 3. Probability density graph overlaid on a histrogram 
# The enrollment rates are again displayed as a histogram with more columns shown to give a more precise perspective on the data. I 
# then calculate the mean and standard deviation of the enrollmenet rates to create a normal distribution. The probability density 
# graph for a normal distribution with the corresponding mean and standard deviation is overlaid on the histrogram. Although not a perfect
# match, it appears that this data could be normally distributed. The most frequently occurring rates and less common rates in either 
# direction occur approximately as much as the normal distribution predicts. 
hist(chicago$College.Enrollment.Rate.Percentage.2013, probability=TRUE, 20)
enrollMean = mean(chicago$College.Enrollment.Rate.Percentage.2013)
enrollSD = sd(chicago$College.Enrollment.Rate.Percentage.2013)
curve(dnorm(x, mean = enrollMean, sd = enrollSD), col ='blue', add=TRUE)

# 4. A contingency table 
# In the contingency table, the number of responses for Neutral, Strong, and Weak are compared for the safe 
# and supportive environement categories. These two categories tend to get the same responses from a student. 
# The popular combination of responses is neutral and neutral. If a student responds that either category, safe or 
# supportive environment, is weak, they never respond that the other category is strong. Excluding neutral, the most 
# common combination is weak for both categories. 
cTable = table(chicago$Safe, chicago$Supportive.Environment)[c(1,3,6),c(1,3,6)]
rownames(cTable) <- c("S.Neutral","S.Strong","S.Weak"); 
colnames(cTable) <- c("SE.Neutral","SE.Strong","SE.Weak"); 
cTable


##### 
# Required techical elements - analysis

# 1. A permutation test
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

# Difference in means for college enrollment rates
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


# 2. A p-value or other statistic based on a distribution function 
# See CLT and Simulation #2 where the actual probability is found with pbinom()

# 3. analysis of the contingency table from earlier
# See Chi-Square section for the comparison with involved families and safey. 

# Additionally, a chi-square test can be run on the table created earlier that compares safety and supportive environments. 
# A first impression is that these two factors are correlated since a WEAK rating in either section is never paired
# with a STRONG rating in the other. Supportive environments could lead to better safety or the types of people who encourage
# supportive environments also tend to ensure safety. To further test this assumption, a chi-sqaure test is run on the table
# that shows a very small and significant p-value, which proves that these two factors, supportive environments and 
# safety are not independent on rankings on STRONG, WEAK, and NEUTRAL.
chisq.test(cTable)


# 4. Comparison of analysis by classical methods(chi-square, CLT) and simulation methods. 

# CHI-SQUARE and Simulation
# For the chi-square test, I determine if there is a relationship between involved family  
# safety categories. Specifically I remove cases where there is not enough data and analyze the
# 3 most popular responses of strong, weak, and neutral. The table shows patterns including that STRONG
# response in either category almost never includes a WEAK response in the other category. If a family is 
# strongly involved, the school is usually rated as safe and vice versa. A chisq.test shows the p-value 
# is significant 0.006644883 and the two categories are not independent. 
#   Next, a simulation is done where the safety column is permuated by sampling it. A table is made with 
# the permuated safety ratings and the involved family ratings. The chi-sqaured statistic is saved for comparison 
# in result. To determine if the observed statistic is significant, the number of statistics from the simulation
# that are larger than the result is divided by the total number of results. A p-value of .0061 is found which 
# is very similar to the 0.006644883 p-value from the initial chi-square test. The permutation simulation and the
# initial chi-square test both show that family involvement ratings and safety ratings are not independent with a 
# p-value of approximately .0061.
subset = subset(chicago, (chicago$Involved.Family!="NOT ENOUGH DATA") & (chicago$Safe != "NOT ENOUGH DATA"))

# STRONG, WEAK, and NEUTRAL responses are analyzed
table = table(subset$Involved.Family, subset$Safe)[c(1,3,6),c(1,3,6)]
table

chisq.test(table)$p.value #0.006644883 

observed <- chisq.test(table)$stat

# Simulation: Permuate the safety column and determine the chisq-stats
N = 10^4 - 1; result <- numeric(N)
for (i in 1:N){
  safe.perm <- sample(subset$Safe)
  table = table(subset$Involved.Family, safe.perm)[c(1,3,6),c(1,3,6)]
  result[i] <- chisq.test(table)$stat
}

hist(result, xlim=c(0, 40))
abline(v = observed)
pValue <- (sum(result >= observed) + 1)/ (N+1)
# .0061, which is statistically signficant and similar to the p-value from the initial test.




# CHI-SQUARE and Simulation 
# For this analysis, the college enrollment rates are compared with a normal distribution. 
# First the mean and standard deviation for the enrollment rates are determined. The qnorm function
# is used to determine 5 equal enrollment ranges that should include 20% of the enrollment rates if
# it is a normal distribution. The number of enrollment rates in each range is determined and saved in 
# Counts. A chi-square test with the Counts and the expected number of rates shows a p-value of .565, meaning
# the enrollment rates could have come from the normal distribution. 
#   A simulation is done to further analyze if the enrollment rates could have come from the normal distribution. 
# Samples from a normal distribution are taken with the same mean and standard deviation as the enrollment rates. 
# The number of samples in each range, that is the same as previously used, is determined. A chi-square statistic 
# taken for result of the range measurements. To determine if the enrollment rates could be normally distributed, the 
# number of chi-sqaured statistics that are less than the result is divided by the total number of results. Similar 
# to the initial test, the p-value for the simulation is .5774. Both tests suggests that the enrollment rates 
# are normally distributed. 
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
# 0.5650023
# Yes, it could be from the normal distribution 

# Simulation with a normal distribution 
mean = mean(chicago$College.Enrollment.Rate.Percentage.2013)
sd = sd(chicago$College.Enrollment.Rate.Percentage.2013)

N = 10^4 - 1; result <- numeric(N)
for(i in 1:N){
  # Sample from a normal distribution 
  normalSample <- rnorm(length(enrollment), mean, sd)
  Counts = numeric(5)

  # Count results in each range 
  Counts[1] = sum(normalSample <= 43.23278)
  Counts[2] = sum((normalSample > 43.23278) & (normalSample <= 52.87487))
  Counts[3] = sum((normalSample > 52.87487) & (normalSample <= 61.17983))
  Counts[4] = sum((normalSample > 61.17983) & (normalSample <= 70.82192))
  Counts[5] = sum(normalSample > 70.82192)

  result[i] <- chisq.test(Counts)$stat
}
observed = chiStat
Pvalue <- (sum(result < observed + 1) / (N+1))
Pvalue 
# 0.5774 very similar to chi-square test, suggesting this is normally distributed 







# CLT and Simulation 
# For this test, I determine if a summation of 30 schools ACT scores could exceed 515. The state of Illinois
# could arrange a contest that states if a group of 30 pre-determined City of Chicago schools have total 
# of mean ACT scores that exceeds 515, they are awarded a grant. The contest organizers could analyze the probability 
# of this occurring in order to confirm they are giving away enough grant funds but not too much. 
#   A total of mean ACT scores exceeding 515 is equivalent to each school have a mean ACT score greater than 
# or equal to 17.33333. The average mean ACT score is 16.92 meaning this could happen frequently. 
# First the CLT approximcation is used to determine the likelihood. The sum of 30 schools ACT scores is the normal 
# distribution with the mean multiplied by 30 and the standard devation multiplied by the square-root(30). The CLT 
# approximation shows that the sum score of 515 could happen by chance since the p-value is .336. Perhaps the contest
# organizers should use a larger sum score for grant funds. 
#   Next a simulation is used to determine likelihood. A sample of 30 scores is repeatedly taken from all the available 
# scores and the sum of these scores is saved in my.sums. After 10,000 simulations, the percent of scores greater than 
# 515 is found which is .303. This is a similar p-value as the CLT approximation and also shows that it would not be statistically
# signicant if a group of 30 schools exceed 515. 
mean = mean(chicago$ACT.Spring.2013.Average.Grade.11)
sd = sd(chicago$ACT.Spring.2013.Average.Grade.11)

pnorm(515, mean*30, sd*sqrt(30), lower.tail=FALSE) # CLT approximation
# 0.3360261

# Simulation by repeatedly summing 30 schools ACT scores
N = 10000; my.sums = numeric(N)
for (i in 1:N) {
  my.sums[i] = sum(sample(chicago$ACT.Spring.2013.Average.Grade.11, 30))
}
mean(my.sums >= 515) 
# 0.303





# CLT and Simulation #2 
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






##### BONUS POINTS 
# 1.
# A data set with lots of columns, allowing comparison of many different variables.  and 2. A dataset 
# that is so large that it can be used as a population from which samples are taken.

# The City of Chicago Schools dataset is very wide with 97 different columns, including additonal 
# categories such as effective leaderships and numeric ratings like college persistence rate that 
# could be further analyzed. I have used additional categories in the bonus problems including a rating
# done by the City of Chicago to determine the state of the school (Level 1, 2, or 3) that measures 
# how much assistance the school needs. There are also enough schools, over 180, to take samples from. 
allData = read.csv("data_full.csv")
# 97 columns including student attendance, suspensions, college persistance rate and more 


# 3. A graphical display that is different from those in the textbook or in the class scripts.
pie(table(chicago$Safe), main="Safe")
# This graph gives insight into how people vote overall. 
# ~40% neutral, interestingly weak is larger than strong. Perhaps Chicago's neighborhoods are unsafe
# or people are generally converned about safety leading to an interpratoin of WEAK safety. 


# 4. Appropriate use of R functions for a probability distribution other than binomial, normal, or chi-square.  
# College enrollment rates are compared to the Cauchy Distribution. A histogram of the rates is produced with 
# the cauchy distribution that matches overlaid on the rates. This particular cauchy distribution with a location
# of 55 and a scale of 10 matches well with the enrollment rates. It has a steeper slope than the normal distribution 
# with fits well as the enrollment rates trail off in either direction. To determine the likelihood, 5 equal ranges are determined
# with the quantile function and the enrollment rates in each range are counted. A chi-squared test of the range counts
# returns a p-value of .5091 which suggests the rates could come from the Cauchy distribution. 
#    To further analyze this result, random deviates are taken from the Cauchy distribution and are counted by the 
# the same range mentioned. The chisq.test is done the range counts for 10^4-1 simulations and the statistic is saved. 
# The p-value measurement is .5188 for the simulation showing again that the enrollment rates could from this distribution. 
rates= chicago$College.Enrollment.Rate.Percentage.2013

hist(rates, probability = TRUE)
curve(dcauchy(x,55, 10), col='red', add=TRUE)

quants = qcauchy(c(.2, .4, .6, .8), 55, 10)

Counts = numeric(5)
Counts[1] = sum(rates <= quants[1])
Counts[2] = sum((rates > quants[1]) & (rates <= quants[2]))
Counts[3] = sum((rates > quants[2]) & (rates <= quants[3]))
Counts[4] = sum((rates > quants[3]) & (rates <= quants[4]))
Counts[5] = sum(rates > quants[4])
Counts

stat = chisq.test(Counts)$stat
chisq.test(Counts)$p.value
# 0.5090677

# similarly the p-value can be confirmed by simulating 117 random devaites with rcauchy
N = 10^4-1; result <- numeric(N)
for (i in 1:N){
  expData = rcauchy(117,55, 10)
  Counts = numeric(5)
  Counts[1] = sum(expData <= quants[1])
  Counts[2] = sum((expData > quants[1]) & (expData <= quants[2]))
  Counts[3] = sum((expData > quants[2]) & (expData <= quants[3]))
  Counts[4] = sum((expData > quants[3]) & (expData <= quants[4]))
  Counts[5] = sum(expData > quants[4])
  result[i] = chisq.test(Counts)$stat
}
Pvalue=(sum(result >= stat)+1)/(N+1); Pvalue
# 0.5188





# 5. Appropriate use of boostrap distribution 
# Level 1 (elite) and Level 3 (needs support) classifications are used beyond Chicago City Schools. 
# In this analysis, the Boostrap distribution is used to compare the ACT scores between Level 1 and Level 3
# schools beyond the City of Chicago schools. The following test shows the difference in mean ACT scores 
# for schools in each of these categories. In other words, the Chicago data is used but the Bootstrap distribution 
# technique is giving information on Level 1 and Level 3 school's ACT scores for the whole country, or at least
# the broader population of schools that use this categorization. Boostrap distribution determines numeric summaries 
# on the difference between ACT score means.

# The schools for ranked Level 1 or Level 3 are found
level3 = subset(datafull, datafull$CPS.Performance.Policy.Level=="LEVEL 3")
level1 = subset(datafull, datafull$CPS.Performance.Policy.Level=="LEVEL 1")

# The ACT scores for each level are determined
level3ACT = level3$ACT.Spring.2013.Average.Grade.11
level1ACT = level1$ACT.Spring.2013.Average.Grade.11

# Samle 20 schools from each level and find the difference in mean ACT scores
N <- 10^4
act.diff.mean <- numeric(N)
for (i in 1:N){
  sample1 <- sample(level1ACT, 20, replace=TRUE)
  sample2 <- sample(level3ACT, 20, replace=TRUE)
  act.diff.mean[i] <- mean(sample1) - mean(sample2)
}

# Numeric summaries on the difference between mean ACT scores
mean(act.diff.mean) # bootstrap mean, 6.699277
mean(act.diff.mean) - (mean(level1ACT) - mean(level3ACT))# bias, 0.009853923
sd(act.diff.mean) # boostrap standard deviation, 0.8422075
quantile(act.diff.mean, c(0.025, 0.975)) # bootstrap spread
# 95% bootstrap percentile conﬁdence interval
# 2.5%    97.5% 
# 5.105000 8.440125 

# Bootstrap analysis shows that the 95 % percentile conﬁdence interval is 5.1 to 8.4 
# which is a large gap between average ACT scores. The level ratings do distinguish 
# between well performing and struggling schools. 


# 6. A convincing demonstration of a relationship that might not have been statistically significant but that turns out to be so. 
# LEVEL 2 shools are suppose to be in the 50th percentile or average.
# More information about the ratings can be found here: http://cps.edu/Performance/Pages/PerformancePolicy.aspx
# It is expected that their mean ACT scores would be average as well. However an analysis of Level 2 ACT scores compared
# with the other ACT scores shows that the average Level 2 ACT score is signicantly higher. After finding the observed difference
# in means in ACT scores, sampling is done of the same size as the Level 2 category. The difference is means between this sample 
# and the rest is determined. From the results, the p-value (.02) of the difference of means shows that Level 2 scores are significantly better 
# than the others. 
#   In terms of ACT scores this suggests that Level 3 is widely used to describe the poorly performing schools. Perhaps it is assigned
# even to schools nearing the 50th percentile range to encourage them to improve. Also schools in the Level 3 categorization could be 
# doing particularly badly and pull the mean ACT score down. The relationship can be further explored. This analysis shows that Level 2 schools
# although regarded as average, have a significantly better mean ACT score when compared with the others.

all = subset(datafull, datafull$ACT.Spring.2013.Average.Grade.11 != "NA" &  datafull$ACT.Spring.2013.Average.Grade.11 != "NOT ENOUGH DATA")
scores2 = subset(all$ACT.Spring.2013.Average.Grade.11, all$CPS.Performance.Policy.Level == "LEVEL 2")
otherScores = subset(all$ACT.Spring.2013.Average.Grade.11, all$CPS.Performance.Policy.Level != "LEVEL 2")

observed = mean(scores2) - mean(otherScores) 

N=10^5-1; result<-numeric(N) 
for (i in 1:N) {
  index = sample(nrow(all), size=length(scores2), replace = FALSE) 
  result[i]<-mean(all$ACT.Spring.2013.Average.Grade.11[-index])-mean(all$ACT.Spring.2013.Average.Grade.11[index])
}

pValue <- (sum(result > observed) + 1) / (length(result) + 1)



# 7. Might have been significant but turns out not to be
# Quality of facilities is one of the rating categories in the dataset. Since parental involvement and safety 
# seem to correspond to better academic performance, it seems like bigger school budgets could lead to better facilities 
# and better academic performance as well. This analysis shows that the weak quality of facilities however does not correspond
# to lower to college enrollments, which is a measure of academic performance. The schools with weak or very weak quality of 
# facilties is determined. The difference in the mean enrollment at collge for the categories is determined. Samples of the 
# same size are randomly taken and the difference between mean college enrollment for this sample and the rest are measured 
# and saved for comparison. 
#   The pVal of .176 shows that that weak quality of facilities is leading to poorer enrollment rates but it is not significant.
# That means a school poor facilities may not have lead to lesser college rates and it could have happened by chance. 
#   The underlying factor here is that many schools didn't provide data on quality of facilty ratings. Most ratings are NOT ENOUGH
# DATA. The test is designed to prove that quality of facilities lead to better college rates, which seems intuitive, but based on 
# this dataset, enrollment rates are independent of quality of facilities. This test illustrates that looking at the data is important
# because blindly running rest could lead to testing a category or value that is rarely reported and gives unexpected outcomes.  
set = subset(datafull, datafull$College.Enrollment.Rate.Percentage.2013 != "NA")

index<-which(set$Quality.of.Facilities == 'WEAK' | set$Quality.of.Facilities == 'VERY WEAK')
observed<-mean(set$College.Enrollment.Rate.Percentage.2013[index])-mean(set$College.Enrollment.Rate.Percentage.2013[-index])

N=10^5-1; result<-numeric(N)  #99999 random subsets should be enough
for (i in 1:N) {
  index = sample(117, size=25, replace = FALSE) #random subset
  result[i]=mean(set$College.Enrollment.Rate.Percentage.2013[index])-mean(set$College.Enrollment.Rate.Percentage.2013[-index])
}

hist(result, breaks = "FD")
abline(v = observed, col = "red")

scoreBetter<-which(result >= observed)
pVal<-(length(scoreBetter)+1)/(length(result)+1) #include the actual sample
pVal # .176



#10. An example where permutation tests or other computational techniques clearly work better than classical methods.
# The probability that 5 randomonly selected schools from the City of Chicago having a mean ACT score below 14.5 is analyzed.
# Consider a scenario where the Federal Government is focusing on college preparation and awards $500k support funds
# to districts that have below an average of 14.5 ACT score. Since the City Of Chicago is large, it is randomly separated into groups of 5
# high schoools. The probability is analyzed with two methods, a CLT approximation and a simulation test by repeatedly choosing 
# 5 high schools and summing their average ACT scores.
#   CLT approximates 4.4% which is too high. The issue is that the data is skewed. Average ACT scores rarely go below 14.5 while 
# they more gradually decrease to the right, as scores near 30. CLT assumes the scores are normally distributed which leads
# to a large over-approximation. Also this is a small sample, a scenario where CLT tends to do poorly.
#   The simulation test outperforms CLT and approximates a .008 percent chance of 5 schools averaging below a 14.5 ACT score. The skewness
# of ACT scores does not affect the simulation test. 10,000 samples of 5 schools are taken and the average of their average ACT scores is
# recorded, followed by finding the probabiilty that the average is less than 14.5.
#   CLT is useful in some cases but generally does poorly with small samples and skewed data, which are both true in this scenario. 

mean = mean(chicago$ACT.Spring.2013.Average.Grade.11)
sd = sd(chicago$ACT.Spring.2013.Average.Grade.11)
pnorm( 14.5*5,mean*5, sd*sqrt(5)) # 0.0440052

# sampling shows the probability closer to reality
N = 10000; my.sums <- numeric(N)
for (i in 1:N) {
     my.sums[i] = sum(sample(chicago$ACT.Spring.2013.Average.Grade.11, 5))
}
mean(my.sums < 14.5*5) #  0.008



#13. Appropriate use of quantiles to compare distributions.
# The mean attendance rate for high school students was higher in 2012 than 2013. Even a small difference in attendance rates
# represents a large number of students, which necessities more analysis of the 2013 attendance drop. Quantiles are used 
# to determine where the most variation occurs and to compare the two year's attendances overall. I solve for 20
# different quantiles from .05 to .95 by .05. I plot the results of the quantile values to visualize the 
# difference. The difference in mean attendance rates is approximately 1.3% but the use of quantiles 
# further illustrates how attendance compares at different points in the range. The 20th percentile has large variation. 
# 2012's 20th percentile is near 80.2% whereas 2013's 20th percentile is near 78.5%. Also at the 60th percentile 2012 is near 91.5%
# whereas 2013's attendance is less than 90%. The quantiles enable a comparison over the whole range of attendances from 
# the percent of schools with 70% attendance to those with 95%+ attendance. Throughout almost the whole range, 
# specifically exluding the .15 percentile and below and the .95 percentile, 2012 has higher attendance than 2013.

datafull$Student.Attendance.Percentage.2013 = as.numeric(sub("%", "", datafull$Student.Attendance.Percentage.2013))
datafull$Student.Attendance.Percentage.2012 = as.numeric(sub("%", "", datafull$Student.Attendance.Percentage.2012))

p20 = seq(0.05, 0.95, by = 0.05)
subset13 = subset(datafull, datafull$Student.Attendance.Percentage.2013 != "NA" & is.null(datafull$Student.Attendance.Percentage.2013)==FALSE)
subset12 = subset(datafull, datafull$Student.Attendance.Percentage.2012 != "NA" & is.null(datafull$Student.Attendance.Percentage.2012)==FALSE)


plot(p20,quantile(subset13$Student.Attendance.Percentage.2013,p20), pch=16, col='blue', ylab='Attendance Percentage', xlab='Percentiles',main="'12 and '13 Student Attendance\n in red and blue respectively",  ylim=c(75,96))
par(new=T)
plot(p20,quantile(subset12$Student.Attendance.Percentage.2012,p20), pch=16, col='red', ylab="", xlab='Percentiles', yaxt='n', ylim=c(75,96))
par(new=F)
abline(v=.20)
abline(v=.60)



# 16. A video of the short script is posted on YouTube and a link to it is on the course Web site.
# https://youtu.be/HnpY77cES9Q























