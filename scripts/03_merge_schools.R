
#Import tidyverse and dplyr
library(tidyverse)
library(dplyr)


#Import the cleaned files from script 1
english_scores <- read.csv("data/clean_english_scores.csv")

science_scores <- read.csv("data/clean_science_scores.csv")

math_scores <- read.csv("data/clean_math_scores.csv")

budget_per_student <- read.csv("data/clean_budget_per_student.csv")

student_ratios <- read.csv("data/clean_student_ratios.csv")

#Check the Anti-join
#Some schools only took one of the tests. We choose to ignore 
#this because the size is small and does not affect our general idea
english_scores |> 
  anti_join(science_scores, c("school_code","school_name","district_name","district_code"))
science_scores |> 
  anti_join(english_scores, c("school_code","school_name","district_name","district_code"))


#Perform the Merge
english_and_science <- english_scores |> 
  left_join(science_scores, c("school_code","school_name","district_name","district_code"))

dim(english_and_science)
names(english_and_science)
summary(english_and_science)


#Check the Anti-join again
#Again, some schools only took one of the tests. We choose to ignore this
#because most of these are middle schools, where the other tests are not taken
english_and_science |> 
  anti_join(math_scores, by = c("school_code","school_name","district_name","district_code"))

math_scores |> 
  anti_join(english_and_science, by = c("school_code","school_name","district_name","district_code"))


#Perform the Merge
all_scores <- english_and_science |> 
  left_join(math_scores, by = c("school_code","school_name","district_name","district_code"))

dim(all_scores)
names(all_scores)
summary(all_scores)

#Now we can add on the budget per student data
#Use the same checks as before with anti-join
all_scores |> 
  anti_join(budget_per_student, by = c("district_code" = "district_id"))
budget_per_student |> 
  anti_join(all_scores, by = c("district_id" = "district_code"))

#In this case, budget_per_student does not cover charter schools,
#but this is good because we want to focus on public schools.
#Also, multiple schools are not in all scores, but that's okay because
#these are middle and elementary school districts


#Therefore, we can complete the merge.
#We want only the schools with scores, so we left merge
#With scores first.
budget_scores <- all_scores |> 
  left_join(budget_per_student, by = c("district_code" = "district_id"))


#Now we have to merge on the student to teacher ratios
#Run the Anti-join checks again
budget_scores |> 
  anti_join(student_ratios, by = c("school_code", "district_code"))
student_ratios |> 
  anti_join(budget_scores, by = c("school_code", "district_code"))

#The Student ratios has ratios for all schools, including elementary and 
#middle schools, but we are only focused on high schools. So we can ignore all
#the schools given to us from that. Also, there is one school that is in the budget scores,
#but is not in student ratios, but it is a school for the deaf which is a special case
#and shouldn't be considered to begin with. So we can now complete the merge. 

budget_scores_ratios <- budget_scores |> 
  left_join(student_ratios, by = c("school_code", "district_code"))


#If we want to compare scores from different tests, we need to use
#a z-score. Essentially, we take the mean and subtract it from the score
#and divide by the standard deviation. This will give a universal score for 
#all the tests.
all_school_data <- budget_scores_ratios |> 
  mutate(
    z_score_math = (math_mean_scale_score - mean(math_mean_scale_score, na.rm = TRUE))/ sd(math_mean_scale_score, na.rm = TRUE),
    z_score_english = (english_mean_scale_score - mean(english_mean_scale_score, na.rm = TRUE))/ sd(english_mean_scale_score, na.rm = TRUE),
    z_score_science = (science_mean_scale_score - mean(science_mean_scale_score, na.rm = TRUE))/ sd(science_mean_scale_score, na.rm = TRUE),
  ) |> 
  rowwise() |> 
  mutate(
    z_score_total = sum(c(z_score_math, z_score_english, z_score_science), na.rm = TRUE)
  ) |> 
  ungroup()

#Now we want to make the names of the Score columns better for our App layout. Then
#we also choose just the columns that are important to us.
school_data <- all_school_data |> 
  rename(
    Math = math_mean_scale_score,
    English = english_mean_scale_score,
    Science = science_mean_scale_score,
    `All (Adjusted to be on the same scale)` = z_score_total
  ) |> 
  select("district_code", "school_code", "school_name.x", "Math", "English", "Science", 
         "All (Adjusted to be on the same scale)", "budget_per_pupil", "students_per_teacher")

  
  
#Save to app data so we can use it in the figures
write_csv(school_data, "app/data/school_data.csv")