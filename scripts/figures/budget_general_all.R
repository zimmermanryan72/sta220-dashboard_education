
#Import tidyverse and dplyr
library(tidyverse)
library(dplyr)

#Import budget_scores with the z scores
budget_scores <- read.csv("data/budget_scores.csv")

#Create a figure showing budget per student vs all test scores
budget_general_all <- ggplot(budget_scores, aes(x = budget_per_pupil, y = z_score_total)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  coord_cartesian(xlim = c(10000, 40000)) +
  labs(
    title = "Budget per Student vs All Scores Weighted",
    subtitle = "One Dot is one NJ Highschool",
    x = "Budget per Student in 2025 (Dollars)",
    y = "Mean Weighted Test Scores for all Subjects in 2025", 
    caption = "Sources: nj.gov Department of Education https://www.nj.gov/education/budget/ufb/2526/ for budget \n 
    per student and https://www.nj.gov/education/assessment/results/reports/2425/index.shtml for test scores \n
    There are two outliers not shown in the graph above" 
  ) +
  theme_minimal()

#Save the figure
ggsave("output/figures/budget_general_all.png", budget_general_all, width =  6, height = 5, bg = "white")