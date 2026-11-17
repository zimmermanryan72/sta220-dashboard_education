
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



#Clean all test score data so we have only the total scores and the mean scores
english_scores <- english_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_code, district_name, school_code, school_name, english_mean_scale_score)

science_scores <- science_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_code, district_name, school_code, school_name, science_mean_scale_score)

math_scores <- math_scores |> 
  filter(subgroup == "Total" & school_name != "District Total") |> 
  select(district_code, district_name, school_code, school_name, math_mean_scale_score)

#Import the budget per student data
budget_per_student <- read.csv(
  "data/raw_cost_per_student.csv",
  colClasses = c(district_id = "character")
)


#Fix some of the format for the year_5 column in budget per student
budget_per_student$year_5 <- as.double(budget_per_student$year_5)


#Clean the budget data so we only have total budget per student, and we
#select only columns we care about
budget_per_student <- budget_per_student |> 
  filter(line_desc == "Total Budgetary Comparative Per Pupil Cost") |> 
  select(district_id, district_name, year_5) |> 
  rename(
    budget_per_pupil = year_5
  )

#Import the Faculty to Student Ratio
student_ratio <- read_excel(
  "data/clean_student_faculty_ratios.xlsx",
)

#Convert all the ratios to just a number showing how many students or teachers there are for
#Each teacher or admin
student_ratio$student_teacher_school <- sub(":.*", "", student_ratio$student_teacher_school)
student_ratio$student_admin_school <- sub(":.*", "", student_ratio$student_admin_school)
student_ratio$teacher_admin_school <- sub(":.*", "", student_ratio$teacher_admin_school)

#Replace all the missing values show they show NA in the table and
#select only the columns that matter to us.
student_ratio <- student_ratio |> 
  mutate(
    students_per_teacher = if_else(
      student_teacher_school == "There is no data is available for this school year.", NA, student_teacher_school),
    students_per_admin = if_else(
      student_admin_school == "There is no data is available for this school year.", NA, student_admin_school),
    teachers_per_admin = if_else(
      teacher_admin_school == "There is no data is available for this school year.", NA, teacher_admin_school),
  ) |> 
  select("district_code", "district_name", "school_code", "school_name", 
         "students_per_teacher", "students_per_admin", "teachers_per_admin")

#Make all of the number double instead of characters
student_ratio$students_per_teacher <- as.double(student_ratio$students_per_teacher)
student_ratio$students_per_admin <- as.double(student_ratio$students_per_admin)
student_ratio$teachers_per_admin <- as.double(student_ratio$teachers_per_admin)


#Save
write_csv(english_scores, "data/clean_english_scores.csv")

write_csv(science_scores, "data/clean_science_scores.csv")

write_csv(math_scores, "data/clean_math_scores.csv")

write_csv(budget_per_student, "data/clean_budget_per_student.csv")

write_csv(student_ratio, "data/clean_student_ratios.csv")