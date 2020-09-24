# Public Interest Data Lab 2020
# Building on R cleaning, more best practices
# 2020-09-25
# mpc


# 0. Set up ----
library(tidyverse)
library(janitor)


# 1. Read the data ----
alb <- read_csv("data/alb_court.csv")

# codebook at: https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing


# 2. Rename vars ----
glimpse(alb)
alb <- clean_names(alb)


# An aside on dplyr ----
# Part of the the tidyverse, dplyr is a package for data manipulation. 
#   Implements a grammar for transforming data, based on verbs/functions 
#   that define a set of common tasks.
# First argument of dplyr functions is always a data frame
#   followed by function specific arguments that detail what to do.
#   Waht's returned is a data frame.


# 3. Isolating Data ----
# select, filter, arrange, distinct, pipe

# select: extract columns by name
select(alb, offense_date, filed_date, hearing_date, case_type)

# arrange: order rows based on values for designated column(s)
alb %>% arrange(offense_date) %>% 
  select(offense_date, arrest_date, filed_date, hearing_date, case_type) 

alb %>% arrange(desc(offense_date)) %>% 
  select(offense_date, arrest_date, filed_date, hearing_date, case_type)


# An aside on the pipe and keystroke shortcuts ----
# The %>% "pipe operator" passes result on left into the first argument 
#   of the function on the right. Read it in your head as "and then."
# Shortcut: 
#   Mac: cmd + shift + m
#   Windows: ctrl + shift + m


# distinct: filter for unique rows
alb %>% distinct(charge)

# filter: extract rows that meet condition
alb %>% filter(shortcode == 3) %>% 
  select(charge, code_section, case_type)

alb %>% filter(shortcode == 18) %>% 
  select(charge, code_section, case_type)

# Logical tests
#   x < y: less than
#   x > y: greater than
#   x == y: equal to
#   x <= y: less than or equal to
#   y >= y: greater than or equal to
#   x != y: not equal to
#   x %in% y: is a member of
#   is.na(x): is NA
#   !is.na(x): is not NA

# Boolean operators for multiple conditions
#   a & b: and
#   a | b: or

alb %>% filter(shortcode == 9 | shortcode == 10) %>% 
  select(charge, code_section, case_type)

alb %>% filter(shortcode %in% c(9,10)) %>% # same as above
  select(charge, code_section, case_type)


# 4. Deriving Estimates ----
# group_by, summarize

alb %>% filter(shortcode == 18) %>% 
  group_by(case_type) %>%  # add final_disposition
  summarize(num = n(),
            minsentence = min(sentence_time, na.rm = TRUE),
            meansentence = mean(sentence_time, na.rm = TRUE),
            maxsentence = max(sentence_time, na.rm = TRUE)) %>% 
  arrange(desc(meansentence))

# Summary functions include
#   first(): first value
#   last(): last value
#   nth(.x, n): nth value
#   n(): number of values
#   n_distinct(): number of distinct values
#   min(): minimum value
#   max(): maximum value
#   mean(): mean value
#   median(): median value
#   var(): variance
#   sd(): standard deviation
#   IQR(): interquartile range

# count: short for group_by() %>% summarize(n())
# makes a table of counts

alb %>% group_by(case_type) %>% summarize(n())
alb %>% count(case_type)


# An aside on code practice ----
# Indenting makes it easier to read/understand code, see what arguments
#   below with each function. Let Rstudio indent for you! 
# Note how I'm keeping the comments fairly short, so they don't require you to continually scroll right to read the whole thing. 
#   You'll want to do that, too.
# And keep lines of code relatively short; break lines at points 
#   where R knows to expect another object on the next line, 
#   e.g., after a pipe (%>%), comma (,), plus sign (+).


# 5 Saving Data ----
# rds, csv

# save the updated alb data frame
saveRDS(alb, file = "albemarle_criminal_2019.rds") 
# alb <- readRDS("albemarle_criminal_2019.rds")

# save as a csv file 
write_csv(alb, path = "albemarle_criminal_2019.csv") 
# alb <- read_csv("albemarle_criminal_2019.csv")
