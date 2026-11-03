
#Import tidyverse, read excel, and dplyr
library(tidyverse)
library(readxl)
library(dplyr)

#Import the semi-cleaned data of English, Science, and Math scores

english_scores <- read_excel(                     #English
  "data/clean_test_scores_9thenglish_2025.xlsx",
  na = c("*")
)
science_scores <- read_excel(                     #Science
  "data/clean_test_scores_11th_science_2025.xlsx",
  na = c("*")
)
math_scores <- read_excel(                        #Math
  "data/clean_test_scores_algebra2_2025.xlsx",
  na = c("*")
)


#Clean all data so we have only the total scores and the mean scores
english_scores <- english_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_name, school_code, school_name, english_mean_scale_score)

science_scores <- science_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_name, school_code, school_name, science_mean_scale_score)

math_scores <- math_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_name, school_code, school_name, math_mean_scale_score)


#Save
write_csv(english_scores, "data/clean_english_scores.csv")

write_csv(science_scores, "data/clean_science_scores.csv")

write_csv(math_scores, "data/clean_math_scores.csv")