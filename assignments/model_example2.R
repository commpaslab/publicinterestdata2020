# Public Interest Data Lab 2020
# Count and Duration model examples
# 2020-11-13
# mpc

# 0. Set up ----
library(tidyverse)
library(skimr)
library(broom)
# install.packages("MASS")
library(MASS) # for negative binomial 
# install.packages("survival")
library(survival) # for duration/survival model


# 1. Read the data ----
ref <- readRDS("data/referrals_clean.rds")
ph <- readRDS("data/placement_clean.rds")


# 2. Event counts ----
# https://data.library.virginia.edu/getting-started-with-negative-binomial-regression-modeling/

# Example: number of allegations 
# (not ideal, as this has an upper limit, but let's go with it...)

# create number of allegations
var <- c("med_neg_dum", "phys_neg_dum", "ment_ab_dum", "phys_ab_dum", "sex_ab_dum")

ref <- ref %>% 
  mutate(allege_sum = rowSums(.[var]))

table(ref$allege_sum)

# negative binomial/event count model
# make hispanic binary
ref <- ref %>% 
  mutate(hisp2 = fct_collapse(hispanic, 
                              nonhispanic = c("D", "N", "U"),
                              hispanic = "Y"))
ref <- ref %>% 
  mutate(hisp2 = fct_relevel(hisp2, "hispanic"))

allege1 <- glm.nb(allege_sum ~ black + hisp2 + gender + age,
                  data = ref)
summary(allege1)
# the warning is most likely an indication that the data is underdispersed
# relative to the mean (so a straight up poisson might be a better choice)

allege0 <- glm.nb(allege_sum ~ black + hisp2,
                  data = ref)
summary(allege0)



allege2 <- glm(allege_sum ~ black + hisp2 + gender + age,
               family = quasipoisson,
                  data = ref)
summary(allege2)


# 3. Durations ----
# https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html

# We need a binary indicator for whether the child is still in a placement
# (e.g., the duration is observed or censored)
ph <- ph %>% 
  mutate(ph_event = if_else(is.na(exit_place_date), 0, 1)) # 1 if observed

# Modeling survival function
S <- Surv(ph$place_dur, ph$ph_event) # create survival object

dur1 <- coxph(S ~ black + gender, data = ph)
summary(dur1)
# a positive coefficient/hazard ratio > 1 means an increased hazard of event
# a negative coefficient/hazard ratio < 1 means a reduced hazard of event

# Plot of "survival" function
plot(survfit(dur1), xlab="Weeks", ylab="Placements Active")

race_diff <- with(ph,
                   data.frame(
                     black = c("1", "0"),
                     gender = c("Male", "Male")))
sex_diff <- with(ph,
                 data.frame(
                   black = c("0", "0"),
                   gender = c("Male", "Female")))

plot(survfit(dur1, newdata = sex_diff), 
     xlab="Weeks", ylab="Placements Active",
     col = c("lightblue", "darkblue")) 
# the survminer package allows for better/ggplot-style survival curves
