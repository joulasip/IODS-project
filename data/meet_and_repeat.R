# Joula Siponen -- 7.12.2021 -- Week 6, Analysis of longitudinal data: Data wrangling 

library(dplyr)
library(tidyr)

#loading the data from the websites
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

#checking an overview of the variables, dimensions and first 6 rows of the data (1p)

var(BPRS)
str(BPRS)
dim(BPRS) # 40 obs. of  11 variables 
head(BPRS)

var(RATS)
str(RATS)
dim(RATS) # 16 obs. of 13 variables
head(RATS)

# > wide form of the data > each time stamp is one variable along with ID/subject and Group/treatment variables


# converting the categorical variables of both data sets to factors (1p)
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


# converting the data sets to long form and adding a week variable to BPRS and a Time variable to RATS (1p)

BPRSL <- BPRS %>%
  gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks, 5,5)))


RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4))) 


# taking a serious look at the new data sets and comparing them with their wide form versions (2p):

variable.names(BPRSL) # treatment, subject, weeks, bprs and week
str(BPRSL) # 360 observations, 5 variables

variable.names(RATSL) # ID, Group, WD, Weight and Time 
str(RATSL) # 176 observations, 5 variables

# >> each single observation is separate unlike before >> there are multiple observations for the same week — one for each subject/ID

setwd("~/Documents/IODS/IODS-project")
write.table(BPRSL, "data/BPRS.txt")
write.table(RATSL, "data/RATS.txt")

