
#Import tidyverse and dplyr
library(tidyverse)
library(dplyr)


#Import the merged file from script 2
all_scores <- read.csv("data/all_scores.csv")


#As of right now we don't have a benchmark, and its midnight
#and just want to get something done, so I'll find it later


#Create a scatterplot for english vs math scores
figure_1 <- ggplot(
  all_scores,
  aes(
    x = english_mean_scale_score,
    y = math_mean_scale_score
  )
) +
geom_point() +
geom_smooth(method = "lm", se = FALSE) +
labs(
  title = "Schools Tend to Have Higher Math and English Scores Togther",
  subtitle = "One Point is One School",
  x = "Average English Score",
  y = "Average Math Score",
  caption = "Source: NJ Department of Education Assessment Reports"
)

#It drops 304 rows due to missing values.

ggsave(
  "output/english_vs_math.png",
  figure_1,
  width = 7,
  height = 4.6,
  bg = "white"
)