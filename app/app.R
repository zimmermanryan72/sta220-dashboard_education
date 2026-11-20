# app.R
# A base dashboard to edit for your final project. See "Using the Dashboard Template."
# Based on "Hello Shiny!" https://shiny.posit.co/r/gallery/start-simple/faithful/

library(shiny)
library(tidyverse)


# The Data ---------------------------------------------------------------------------------------

# Save your cleaned data in app/data/, then delete the # below.
budget_scores <- read_csv("data/school_data.csv")

# The UI (what the reader sees) ------------------------------------------------------------------

ui <- fluidPage(

  titlePanel("Administrative Decisions and their affects on Standardized State Test Scores"),
  p("For: High School Administrators"),
  p("The decision: Should we change our District to increase Test Scores?"),

  selectInput(inputId = "Scores", label = "Which scores do you want to look at:", 
              choices = c("All (Adjusted to be on the same scale)", "English", "Math", "Science")),

  h3("Figure 1. Budget Per Student and Test Scores"),
  plotOutput(outputId = "fig_1"),
  p("The Figure shows how a budget could affect test scores."),

  h3("Figure 2. Amount of Students per Teacher and Test Scores"),
  plotOutput(outputId = "fig_2"),
  p("The Figure shows how different student to teacher ratios could affect test scores."),

  h3("What this dashboard cannot tell you"),
  p("Data can not show teacher or admin salaries, which would be valueable to know if you are planning
    a budget.")

)


# The Server (how the figures are made) ----------------------------------------------------------

server <- function(input, output) {

  output$fig_1 <- renderPlot({

    ggplot(school_data, aes(x = budget_per_pupil, y = .data[[input$Scores]])) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      coord_cartesian(xlim = c(10000, 40000)) +
      labs(
        subtitle = "One Dot is one NJ Highschool",
        x = "Budget per Student in 2025 (Dollars)",
        y = "Mean Test Score in 2025", 
        caption = "Sources: nj.gov Department of Education https://www.nj.gov/education/budget/ufb/2526/ for budget \n 
    per student and https://www.nj.gov/education/assessment/results/reports/2425/index.shtml for test scores"
      ) +
      theme_minimal()
  })

  output$fig_2 <- renderPlot({

    ggplot(school_data, aes(x = students_per_teacher, y = .data[[input$Scores]])) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      coord_cartesian(xlim = c(0, 50)) +
      labs(
        subtitle = "One Dot is one NJ Highschool",
        x = "Number of Students for each Teacher",
        y = "Mean Test Score in 2025", 
        caption = "Sources: nj.gov Department of Education https://www.nj.gov/education/spr/download/ for student to teacher ratio \n
        and https://www.nj.gov/education/assessment/results/reports/2425/index.shtml for test scores"
      ) +
      theme_minimal()
  })

}


# Run the App ------------------------------------------------------------------------------------

shinyApp(ui = ui, server = server)
