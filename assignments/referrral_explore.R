# Public Interest Data Lab 2020
# Building on R viz; dates/durations
# 2020-10-09
# mpc


# 0. Set up ----
library(tidyverse)
library(janitor)
library(lubridate) # handling dates
library(readxl)
library(ggbeeswarm)


# 1. Read the data ----
ref <- read_excel("data/Referral_Clients.xlsx")
# oc <- read_excel("data/CPS_Ongoing_Clients.xlsx")
# fc <- read_excel("data/Foster_Care_Clients.xlsx")
# ph <- read_excel("data/Placement_History.xlsx")

# data dictionary: https://docs.google.com/spreadsheets/d/1_Q_MlYg7DVthBMekUBGI1nZ8n2DcUTe6mTKO3aJOB-I/edit?usp=sharing

str(ref)
ref <- clean_names(ref) 
# We'll want to be more deliberate about names later,
#   once we've filled out the data dictionary above


# 2. A little exploration ----

# Age at referral
summary(ref$age_at_referral)

# Distribution of age - histogram
ggplot(ref, aes(x = age_at_referral)) +
  geom_histogram(binwidth = 1) # try binwidth = 1

# Average age by race
ref %>% 
  group_by(primary_ethnicity) %>% 
  summarize(n = n()) %>% 
  mutate(percent = 100*(n/sum(n)))


# 3. More on ggplot/scatterplots ----
ggplot(ref, aes(x = primary_ethnicity, y = age_at_referral)) +
  geom_point() 

# try jitter
ggplot(ref, aes(x = primary_ethnicity, y = age_at_referral)) +
  geom_jitter() 

# try beeswarm/quasirando
ggplot(ref, aes(x = primary_ethnicity, y = age_at_referral)) +
  geom_quasirandom() 

# add color (color = gender)
# add transparency (alpha = 1/3)
# flip coordinates (coord_flip())
# change color (scale_color_manual(values = c("blue", "orange")))
ggplot(ref, aes(x = primary_ethnicity, y = age_at_referral, color = gender)) +
  geom_quasirandom(alpha = 1/3) +
  scale_color_manual(values = c("blue", "orange")) + 
  coord_flip()

# piping, filter, facets
ref %>% filter(gender != "Unknown") %>% 
  ggplot(aes(x = primary_ethnicity, y = age_at_referral, color = gender)) +
  geom_quasirandom(alpha = 1/3) +
  facet_wrap(~ accepted) +
  coord_flip()

# adding elements from another data frame
ref_meanage <- ref %>% filter(gender != "Unknown") %>% 
  group_by(primary_ethnicity) %>% 
  summarize(meanage = mean(age_at_referral, na.rm = TRUE))

ref %>% filter(gender != "Unknown") %>% 
  ggplot(aes(x = primary_ethnicity, y = age_at_referral, color = accepted)) +
  geom_quasirandom(alpha = 1/3) +
  scale_color_manual(values = c("#141E3C", "#EB5F0C")) +
  coord_flip() +
  geom_point(data = ref_meanage, aes(x = primary_ethnicity, y = meanage), color = "#25CAD3", size = 3) 


# 4. Working with dates, durations ----

# In R, when you subtract two dates, you get a difftime object
# But durations are easier to work with;
#   We can use multiple duration constructors - 
#   dseconds, dminutes, dhours, ddays, dweeks, dyears

# Let's calculate the duration of a case, in days
ref <- ref %>% 
  mutate(dr_days = ifelse(
    is.na(closed_date),  # if close date is missing
    as.duration(as.POSIXct("2019-12-31") - referral_date)/ddays(1), # use the last day of the study period
    as.duration(closed_date - referral_date)/ddays(1)), # otherwise, use the closing date
    dr_days = ifelse(accepted == "N", NA_integer_, dr_days)) # and remove the durations for cases that aren't screened in

# distribution of duration
ggplot(ref, aes(x = dr_days)) + 
  geom_histogram()

# or if you're feeling fancy
ggplot(ref, aes(x = dr_days, fill = as.factor(white))) + 
  geom_density(alpha = .5)

# duration by race
ggplot(ref, aes(x = primary_ethnicity, y = dr_days, color = gender)) + 
  geom_quasirandom(alpha = 1/3) + 
  scale_color_manual(values = c("#141E3C", "#EB5F0C", "#25CAD3")) +
  coord_flip()
