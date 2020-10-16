# Public Interest Data Lab 2020
# Building on R viz; n_distinct; joins
# 2020-10-16
# mpc


# 0. Set up ----
library(tidyverse)
library(lubridate) # handling dates
library(readxl)

# install.packages("googlesheets4")
library(googlesheets4)


# 1. Read the data ----
ref <- read_csv("data/Referral_Clients_update.csv")
ref_raw <- ref

# data dictionary url: 
dd_url <- "https://docs.google.com/spreadsheets/d/1_Q_MlYg7DVthBMekUBGI1nZ8n2DcUTe6mTKO3aJOB-I/edit?usp=sharing"

dd <- read_sheet(dd_url, sheet = "referrals", skip = 6)


# 2. Some data prep ----

# apply new var names
for (i in (1:nrow(dd))){
  colnames(ref)[i] <- dd$RENAME[i]
}
names(ref) # check

# reformat variables
# define varlist to format as factors
var_fct <- dd %>% 
  filter(`TYPE-needed` == "factor") %>% 
  select(RENAME) %>% 
  filter(!is.na(RENAME))

# create a vector of these variables
var_fct <- var_fct$RENAME

# mutate
ref <- ref %>% 
  mutate(across(all_of(var_fct), as.factor))


# 3. More visualization ----

# geom_bar (with fill)
ggplot(ref, aes(x = race_ethn)) +
  geom_bar()
# add fill color, show.legend = FALSE

# geom_col (with ordering)
ref %>% group_by(race_ethn) %>% 
  summarize(n = n(), 
            screenin = sum(screen_in == "Y")) %>% 
  mutate(screenrate = screenin/n) %>% 
  ggplot(aes(x = race_ethn, y = screenrate)) +
  geom_col()
# add fct_reorder

# filter and facet_wrap
ref %>% filter(screen_in == "Y") %>% 
ggplot(aes(x = dr_track)) +
  geom_bar() +
  facet_wrap(~race_ethn)
# add scales = "free_y"

# geom_bar with fill
ggplot(ref,  aes(x = dr_track, fill = white)) +
  geom_bar() # stacked counts
# default is: position = "stack"

ggplot(ref,  aes(x = dr_track, fill = white)) +
  geom_bar(position = "dodge") # side by side

ggplot(ref,  aes(x = dr_track, fill = white)) +
  geom_bar(position = "dodge2") # side by side, a little space

ggplot(ref,  aes(x = dr_track, fill = white)) +
  geom_bar(position = "fill") # relative proportions


# 4. A few other useful things ----
# n_distinct: getting a handle on the different id vars
n_distinct(ref$ref_id)
n_distinct(ref$client_id)
n_distinct(ref$case_id)
n_distinct(ref$ssn_id)
n_distinct(ref$fid)

# and the potential (easy-to-miss) missingness
ref %>% group_by(client_id) %>% 
  summarize(n = n()) %>% 
  ungroup() %>% 
  mutate(mean_n = mean(n)) %>% 
  filter(n == max(n))
# which creates a challenge if we want to join data sets by these variables

# speaking of, a little bit about joining/merging
oc <- read_excel("data/CPS_Ongoing_Clients.xlsx")
# ideally, I'd run this through some cleaning and formatting first as well...

n_distinct(oc$E_Client_ID)
n_distinct(oc$E_SSN)

oc %>% group_by(E_SSN) %>% 
  summarize(n = n()) %>% 
  ungroup() %>% 
  mutate(mean_n = mean(n)) %>% 
  filter(n == max(n))

# so def can't use anonymized ssn; let's try client id
# keeping in mind this is probably not quite what we want
ref_oc <- ref %>% 
  left_join(oc, by = c("client_id" = "E_Client_ID"))

# Aside on joins: 
# A visual explanation is in Grolemund’s and Wickham’s R for Data Science, 
# https://r4ds.had.co.nz/relational-data.html#understanding-joins
#
# full_join(): keeps all observations in x and y
# left_join(): keeps all observations in x
# right_join(): keeps all observations in y
# inner_join(): keeps observations in both x and y
#
# The syntax is always name_join(x, y, by = "key")

# So the above attached the ongoing client fields to every referral instance
# for a matching client id -- we haven't yet tried to distinguish if a
# particular referral was the most proximate precursor to services...
# (or if a child is referred while alreading a client)


# 5. Save the work for later ----
saveRDS(ref, "data/referrals_cleanish.rds")
# ref <- readRDS("data/referrals_cleanish.rds")         