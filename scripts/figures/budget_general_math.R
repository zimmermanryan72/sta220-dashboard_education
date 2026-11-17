
#Import tidyverse and dplyr
library(tidyverse)
library(dplyr)

#Import budget_scores with the z scores
budget_scores <- read.csv("data/budget_scores.csv")

#Create a figure showing budget per student vs Math test scores
budget_general_math <- ggplot(budget_scores, aes(x = budget_per_pupil, y = math_mean_scale_score)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  coord_cartesian(xlim = c(10000, 40000)) +
  labs(
    title = "Budget per Student vs Math Scores",
    subtitle = "One Dot is one NJ Highschool",
    x = "Budget per Student in 2025 (Dollars)",
    y = "Mean Math Test Scores in 2025", 
    caption = "Sources: nj.gov Department of Education https://www.nj.gov/education/budget/ufb/2526/ for budget \n per student and https://www.nj.gov/education/assessment/results/reports/2425/index.shtml for test scores" 
  ) +
  theme_minimal()

#Save the figure
ggsave("output/figures/budget_general_math.png", budget_general_math, width =  6, height = 5, bg = "white")