# Joula Siponen -- 22.11.2021 & 2.12.2021 -- Week 4 & 5: Data wrangling 

library(dplyr)

# reading the data about "Human Development" and "Gender equality"
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# checking the structure and dimensions of the data (1p)
str(hd)
dim(hd) #195, 8
str(gii)
dim(gii) # 195, 10

#summaries of the variables (1p)
summary(hd)
summary(gii)

# changing the names of the variables (1p)
colnames(hd)[1] <- "HDI_rank" #human development index rank
colnames(hd)[3] <- "HDI" #human development index
colnames(hd)[4] <- "LEB" #life expectancy at birth
colnames(hd)[5] <- "EYE" #expected years of education
colnames(hd)[6] <- "MYE" #mean years of education
colnames(hd)[7] <- "GNI" #gross national income per capita
colnames(hd)[8] <- "GNI_HDI" # GNI per capita rank - HDI rank

colnames(gii)[1] <- "GII_rank" #gender inequality index rank
colnames(gii)[3] <- "GII" #gender inequality index
colnames(gii)[4] <- "MMR" #maternal mortality ratio
colnames(gii)[5] <- "ABR" #adolescent birth rate
colnames(gii)[6] <- "PRP" #percent representation in Parliament
colnames(gii)[7] <- "edu2F" #Population with secondary education, female
colnames(gii)[8] <- "edu2M" #Population with secondary education, male
colnames(gii)[9] <- "labF" #labour force participation rate, female
colnames(gii)[10] <- "labM" #labour force participation rate, male

#mutating the data (1p)
gii <- mutate(gii,
  edu2R = edu2F/edu2M,
  labR = labF/labM)

#joining the two datasets (1p)
human <- inner_join(hd,gii,by=c("Country")) #,suffix=c("",".p")
str(human) # 195 observations and 19 variables
summary(human)

#saving the data to the 'data' folder (> no need to write it again during week 5)
setwd("~/Documents/IODS/IODS-project")
# write.csv(human, "data/human.csv")

#______________________________
# NEXT WEEK (5) STARTS

# reading the data in and exploring the content (1p)
setwd("~/Documents/IODS/IODS-project")
human <- read.csv("data/human.csv", header = TRUE, stringsAsFactors = TRUE, row.names = 1)

str(human) 
# the data consists of human related indicators related to health, knowledge and empowerment
# the variables are explained above, where they are named
dim(human)
# 19 variables, 195 observations


# mutating the data (1p)
human <- mutate(human, GNI = as.numeric(GNI))


# excluding unnessary data (1p)
keep <- c("Country", "edu2R", "labR", "LEB", "EYE", "GNI", "MMR", "ABR", "PRP")
human <- select(human, one_of(keep))


# removing not-completed cases (1p)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human))


# removing observations that are not related to countries (1p)

# first checking the last ten observations
tail(human, n = 10L) # last 7 are not countries but regions
# defining last index we want to keep
last <- nrow(human) - 7 
# selecting observations we want to keep 
human <- human[c(1:last), ]


#Defining rownames as country names and removing country name column + saving data (1)
rownames(human) <- human$Country
human <- select(human, -Country)

str(human) # 155 observations, 8 variables

write.csv(human, "data/human.csv")



