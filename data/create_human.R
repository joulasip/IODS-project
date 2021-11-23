# Joula Siponen -- 22.11.2021 -- Week 4: Data wrangling (for the next week's data)


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

#saving the data to the 'data' folder
setwd("~/Documents/IODS/IODS-project")
write.csv(human, "data/human")

