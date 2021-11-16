# Joula Siponen -- 16.11.2021 -- Week 3: Linear regression, Data wrangling
# data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance 
#   The data are from two identical questionaires related to secondary school student alcohol
#   comsumption in Portugal.

library(dplyr)

#reading the data in from the files and check the structure and dimensions (1p)
math <- read.csv("data/student-mat.csv", sep=";", header=TRUE)
por <- read.csv("data/student-por.csv", sep=";", header=TRUE)
str(mat)
str(por)
#output mat: 395 obs. and 33 var., por: 649 obs. and 33 var.

# **********
#FROM HERE ON: original code for combining the data by Reijo Sund

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

# borrowed code ends here >> included also combining duplicated data (1p)
# and taking average of weekday and weekend alcohol consumption to 'alc_use'
# as well as creating 'high_use' which is TRUE for students for which 'alc_use' > 2 (1p)
# **********

# checking the structure of the joined data (1p)
str(pormath)
# output: 370 observations and 51 variables

#glimpse the data
glimpse(pormath)

#looking good!

#__________________________________________
# WRITING THE NEW DATA TO A DATA FILE and checking that looking ok (1p)
# setting the working directory to IODS project folder
setwd("~/Documents/IODS/IODS-project")

write.csv(pormath, "data/alc")

#reading the newly created csv file into a data frame
test <- read.csv("data/alc", row.names = 1)
str(test)
head(test)

# all good!

