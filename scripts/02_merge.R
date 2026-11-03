
#Import tidyverse and dplyr
library(tidyverse)
library(dplyr)


#Import the cleaned files from script 1
english_scores <- read.csv("data/clean_english_scores.csv")

science_scores <- read.csv("data/clean_science_scores.csv")

math_scores <- read.csv("data/clean_math_scores.csv")

#Check the Anti-join
#Some schools only took one of the tests. We choose to ignore 
#this because the size is small and does not affect our general idea
english_scores |> 
  anti_join(science_scores, c("school_code","school_name","district_name"))
science_scores |> 
  anti_join(english_scores, c("school_code","school_name","district_name"))


#Perform the Merge
english_and_science <- english_scores |> 
  left_join(science_scores, c("school_code","school_name","district_name"))

dim(english_and_science)
names(english_and_science)
summary(english_and_science)


#Check the Anti-join again
#Again, some schools only took one of the tests. We choose to ignore this
#because most of these are middle schools, where the other tests are not taken
english_and_science |> 
  anti_join(math_scores, by = c("school_code","school_name","district_name"))

math_scores |> 
  anti_join(english_and_science, by = c("school_code","school_name","district_name"))


#Perform the Merge
all_scores <- english_and_science |> 
  left_join(math_scores, by = c("school_code","school_name","district_name"))

dim(all_scores)
names(all_scores)
summary(all_scores)

#Now we have a table where we have the school name, code, district name,
#and the scores of the three standardized tests. Now we save it.

write_csv(all_scores, "data/all_scores.csv")
