# Public Interest Data Lab 2020
# Building on R cleaning and factors
# 2020-10-02
# mpc


# 0. Set up ----
library(tidyverse)
library(janitor)


# 1. Read the data ----
alb <- readRDS("data/albemarle_criminal_2019.rds")
str(alb)

# codebook at: https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing


# 2. Separate ----
alb <- alb %>% 
  separate(code_section, into = c("title", "chapter"), sep = "-", remove = FALSE)

# VA Code: https://law.lis.virginia.gov/vacode/


# 3. Mutate ----
alb <- alb %>% 
  mutate(fine0 = if_else(is.na(fine), 0, fine),
         cost0 = if_else(is.na(costs), 0, costs),
         fine_cost = fine0 + cost0)


# 4. Factors ----
# and forcats

# Factors are how R handles categorical variables
#   stored as a vector of integer values with the corresponding set of character values

alb %>% count(case_type) # currently a character

alb %>% 
  mutate(case_type = factor(case_type)) %>% # make a factor
  count(case_type)

# Felony: Criminal offense that is more serious than misdemeanors; usually involves violence; punishcment usually involves jail time
# Misdemeanor: Criminal offense that is less serious than a felony; usually punishable by a fine nad some time in a localy county jail
# Infraction: Minor violation (i.e., traffic ticket; usually punished with a fine; does not have right to jury trial
# Capias: Failure to appear before the court
# Civil violation: violation of stat or local law other than criminal offense; usually punishable by a civil fine or forfeiture
# Show cause: an order requiring one or more parties to justify, explain, or prove something to the court (judge needs more info)

# assert the ordering of the factor levels
case_levels <- c("Felony", "Misdemeanor", "Infraction", "Capias", "Civil Violation", "Show Cause")
alb %>% 
  mutate(case_type = factor(case_type, levels = case_levels)) %>% 
  count(case_type)

# forcats: fct_infreq, fct_collapse, fct_recode, etc: https://forcats.tidyverse.org/
# order categories by frequency of responses
alb %>% 
  mutate(case_type = fct_infreq(case_type)) %>% 
  count(case_type)

# combine categories into manually defined groups
alb %>% 
  mutate(case_group = fct_collapse(case_type,
                                   criminal = c("Felony", "Misdemeanor"),
                                   infraction = "Infraction",
                                   minor = c("Capias", "Civil Violation", "Show Cause"))) %>% 
  count(case_group)

# lump and sequence
alb %>% 
  mutate(case_group = fct_lump(case_type, n = 3, other_level = "Other"),
         case_group = fct_infreq(case_group)) %>% 
  count(case_group)

# making factors of many variables
#    across -- performing same operation on multiple columns
#    where -- a selection helper function

# which variables are characters?
alb %>% select(where(is.character)) %>% names()

alb %>% 
  mutate(across(where(is.character), as.factor)) %>% 
  select(hearing_result, status, gender, race) %>% 
  str()

# make it so
alb <- alb %>% 
  mutate(across(where(is.character), as.factor))


# 5 Group_by, summarize ----
# mean sentence time by case_type
alb %>% 
  group_by(case_type) %>% 
  summarize(mean_sent = mean(sentence_time, na.rm = TRUE))

# mean everything (for which a mean ake sense) by case_type
alb %>% 
  group_by(case_type) %>% 
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

# okay, that didn't actually make sense for everything numeric, select a few
alb %>% 
  group_by(case_type) %>% 
  summarise(across(c(sentence_time, fine, costs), mean, na.rm = TRUE),
            n = n())


# you can get pretty fancy with dplyr verbs...
# e.g., what's the racial breakdown of each case type?
alb %>% 
  group_by(case_type, race6) %>%
  summarize(n = n()) %>% 
  left_join(alb %>% # left_join is a merge function
              group_by(case_type) %>% 
              summarize(case_n = n())) %>% 
  mutate(case_race = (n / case_n)*100)
  
  
