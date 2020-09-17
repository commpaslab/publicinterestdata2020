# Public Interest Data Lab 2020
# Building on R Intro, Best Practices
# 2020-09-18
# mpc


# 0. Set up ----
library(tidyverse)

# Useful for setup code to be together at beginning: e.g., loading packages, source code
# If you're setting a working directory, it would appear here as well, 
# but we'll be using R projects to help maintain consistent and shareable file structures/codes.


# 1. Read the data ----
alb <- read_csv("data/alb_court.csv")

# codebook at: https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing


# 2. Quick view ----
str(alb)
head(alb)
names(alb)
View(alb)


# An aside on keyboard shortcuts ----
# There are tons of keyboard shortcuts. Some useful early ones are
#   Cmd/Ctrl + Return/Enter, to execute code
#   Cmd/Ctrl + Shift + C, to comment/uncomment multiple lines
#   Option + -, to create the assignment operator
#   Cmd/Ctrl + S, save document


# 3. Summaries ----
# use $ to reference elements in a data frame
summary(alb$OffenseDate)
summary(alb$FiledDate)
summary(alb$HearingDate)


# An aside on code practice ----
# Note how I started the script with some key information:
#   Project name, script purpose, date, and my initials.
# In addition, I've created section headers to demarcate 
#   different steps. The dashes at the end add the 
#   section title to the gutter below for easy navigation.


# 4. Tables ----
# Counts
table(alb$Gender)
xtabs(~ Gender, alb)

# Proportions
prop.table(table(alb$Gender))
tab_sex <- table(alb$Gender) # or separate the steps
prop.table(tab_sex)
round(prop.table(tab_sex), 3) # reduce the output

proportions(xtabs(~ Gender, alb))
tab2_sex <- xtabs(~ Gender, alb)
proportions(tab2_sex)
round(proportions(tab2_sex), 2)


# An aside on naming conventions ----
# I created an object above using the assignment operater: <-
#   This saves it in local memory for use later. 
# When naming, avoide spaces or dashes; Use underscores, dots, 
#   capitalization to write descriptive names.
# I use camel case most frequently - camel_case
# Some people like snake case - SnakeCase - or dot notation - dot.names.


# 4. Cross-tabs ----
table(alb$shortcode, alb$Gender)
tab_sex_code <- table(alb$shortcode, alb$Gender)
prop.table(tab_sex_code) # cell proportions
prop.table(tab_sex_code, 1) # row proportions
round(prop.table(tab_sex_code, 2),3) # column proportions

xtabs(~shortcode + Gender, alb)
tab2_sex_code <- xtabs(~shortcode + Gender, alb)
proportions(tab2_sex_code) # cell proportions
proportions(tab2_sex_code, 1) # row proportions
round(proportions(tab2_sex_code, 2), 3) # column proportions


# An aside on commenting ----
# Comments are your friend -- make a lot of them! It's easier for you to read later,
#   and easier for others to use and follow, which is essential for collaborative work.
# What is this line or chunk of code intended to do? What question is it answering?
#   What quirkiness arose that made the code tricky, or what's the trick in this code?

# But it's also a good way to make notes -- observations about the data or a result,
#   steps you want to implement later (next steps, or the hard part you skipped for the moment),
#   useful resources like the link to the codebook. I regularly add links to stackoverflow threads
#   from which I derived solutions to my current challenge so I can find it again.
# And for the first couple of assignments, you'll add explanations and answers in comments.


# An aside on finding help ----
# Rstudio help viewer: e.g., ?table
# Package documentation, often includes vignettes: e.g., Tidyverse https://cran.r-project.org/web/packages/tidyverse/index.html
# RStudio Cheat Sheets: https://rstudio.com/resources/cheatsheets/
# Google an error, search Stackoverflow: e.g., some advice https://r4ds.had.co.nz/introduction.html#getting-help-and-learning-more
# Post questions on our slack