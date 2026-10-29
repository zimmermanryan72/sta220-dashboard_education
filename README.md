# sta220-dashboard_education
Sta220 Final Project Dashboard

## What is this?

## Where did the data come from?
Raw test scores were collected from nj.gov's School Year Assesement
Reports: https://www.nj.gov/education/assessment/results/reports/
2425/index.shtml.
Cost Per Pupil and the Key was collected from nj.gov's User_Friendly 
Budget page under the Department of Education: https://www.nj.gov/
education/budget/ufb/2526/
## How do I run it?

## What does each script do?

## What is in each folder?
data/: raw files, never edited by hand, as well as edited files.
scripts/: run in order by number.
output/: made by the scripts.
## Who made it, and when was it last updated?
Ryan Zimmerman, 10/29/2026

##Manually Curating Data for R scripts
clean_test_scores for Algebra 1, 9th grade English,
and 11th grade Science were created by:

Delete the first two lines in the excel sheet. The first two rows
of each sheet was only the instructions on how to read the table
and a couple of notes. 

Keep only columns that pertain to physical scores in test score 
data. So we get rid of:
Registered to Test
Not Tested
Valid Scores

Rename Columns
Rename all columns in test scores to be in snake case