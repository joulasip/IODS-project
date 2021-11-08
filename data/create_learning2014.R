# Joula Siponen -- 8.11.2021 -- Week 2 assignment, Data wrangling

library(dplyr)

#reading the data in from the web
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#checking the structure and dimentions of the data (1p)
str(lrn14)
dim(lrn14)
# str > shows 60 variables, their type (int or chr) and observations
# dim > 183 60


# CREATING THE ANALYSIS DATASET (1p)
# with variables gender, age, attitude, deep, stra, sufr and points

# creating column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude / 10

# then naming the questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# creating a column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# creating a column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# creating a column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#selecting the variables to keep
wanted_variables <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
lrn14 <- select(lrn14, one_of(wanted_variables))

# changing the names to match 
colnames(lrn14)[2] <- "age"
colnames(lrn14)[7] <- "points"

#filtering out all observations where the exam points variable is zero
lrn14 <- filter(lrn14, points > 0)

#now dim(lrn14) > 166 8


