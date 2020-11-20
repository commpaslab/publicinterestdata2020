# Public Interest Data Lab 2020
# Commuicating Model Results
# Generating quantities of interest (qoi)
# 2020-11-20
# mpc

# 0. Set up ----
library(tidyverse)
library(skimr)
library(broom)
library(MASS) # for negative binomial 
library(survival) # for duration/survival model

source("scripts/gen_qoi.R")


# 1. Read the data ----
ref <- readRDS("data/referrals_clean.rds")
ph <- readRDS("data/placement_clean.rds")



# 2. Logit models ----
# quantity of interest -- predicted probbility of outcome

# Back to the super basic model of allegation of physical neglect
neglect1 <- glm(phys_neg_dum ~ race5 + hisp_white + 
                  age + gender, 
                data = ref, family = "binomial")
# model coefficients and summary stats
summary(neglect1)

# Hmmm, that's not going to work....
ref2 <- ref %>% 
  filter(gender != "Unknown") %>% 
  mutate(hisp_white = ifelse(hisp4 == "Hispanic,White", "Y", "N"),
         hisp_white = factor(hisp_white, levels = c("N", "Y")))

neglect2 <- glm(phys_neg_dum ~ race5 + hisp_white + 
                  age + gender, 
                data = ref2, family = "binomial")
# model coefficients and summary stats
summary(neglect2)

# generate predicted probabilities from neglect1: vary by race5
set.seed(1017) # to generate reproducible (identical) results
pred_prob_neglect <- gen_qoi(ref2, "race5", neglect2) # data, "var", model
pred_prob_neglect # check the output
pred_prob_neglect <- pred_prob_neglect %>% 
  mutate(group = fct_relevel(group, "Asian", "Black", "White", "Multiracial", "Remain_Unknown"))

# plot predicted probabilities
ggplot(pred_prob_neglect, aes(x = fct_rev(group), y = outcome, color = group)) +
  geom_point(size=4) +
  geom_pointrange(aes(ymin = lower, ymax=upper)) +
  coord_flip() +
  # scale_color_manual(values=pidlpal) +
  labs(title="Predicted Probability of Alleged Neglect",
       x = "", color = "Race",
       y = "Predicted Probability of Alleged Neglect",
       caption = "Note: error bars are 90% credible intervals")

# generate predicted probabilities from neglect1: vary by hisp_white
set.seed(1017) # to generate reproducible (identical) results
pred_prob_neglect2 <- gen_qoi(ref2, "hisp_white", neglect2) # data, "var", model
pred_prob_neglect2 # check the output
pred_prob_neglect2 <- pred_prob_neglect2 %>% 
  mutate(group = fct_recode(group, LatinX = "Y"))

# plot predicted probabilities
ggplot(pred_prob_neglect2, aes(x = fct_rev(group), y = outcome, color = group)) +
  geom_point(size=4) +
  geom_pointrange(aes(ymin = lower, ymax=upper)) +
  coord_flip() +
  # scale_color_manual(values=pidlpal) +
  labs(title="Predicted Probability of Alleged Neglect",
       x = "", color = "Hispanic",
       y = "Predicted Probability of Alleged Neglect",
       caption = "Note: error bars are 90% credible intervals")

# maybe combine these?
pred_prob_neglect3 <- pred_prob_neglect %>% 
  rbind(pred_prob_neglect2) %>% 
  filter(group != "N") 

# plot predicted probabilities
ggplot(pred_prob_neglect3, aes(x = fct_rev(group), y = outcome, color = group)) +
  geom_point(size=4) +
  geom_pointrange(aes(ymin = lower, ymax=upper)) +
  coord_flip() +
  # scale_color_manual(values=pidlpal) +
  labs(title="Predicted Probability of Alleged Neglect",
       x = "", color = "Race/Ethnicity",
       y = "Predicted Probability of Alleged Neglect",
       caption = "Note: error bars are 90% credible intervals")


# 3. Event counts ----
# quantity of interest -- predicted count

# New example: number of referrals
ref3 <- ref2 %>% 
  add_count(client_id, name = "refnum") %>% 
  group_by(client_id) %>% 
  slice(1)

# negative binomial/event count model
refnum1 <- glm.nb(refnum ~ race5 + hisp_white + gender + age,
                  data = ref3)
summary(refnum1)
# the warning is most likely an indication that the data is underdispersed
# relative to the mean (so a straight up poisson might be a better choice)

refnum2 <- glm(refnum ~ race5 + hisp_white + gender + age,
               family = poisson,
                  data = ref3)
summary(refnum2)

# generate predicted probabilities from neglect1: vary by hisp_white
set.seed(1017) # to generate reproducible (identical) results
pred_prob_refnum <- gen_qoi(ref3, "race5", refnum2) # data, "var", model
pred_prob_refnum # check the output
pred_prob_refnum <- pred_prob_refnum %>% 
  mutate(group = fct_relevel(group, "Asian", "Black", "White", "Multiracial", "Remain_Unknown"))

# plot predicted probabilities
ggplot(pred_prob_refnum, aes(x = fct_rev(group), y = outcome, color = group)) +
  geom_point(size=4) +
  geom_pointrange(aes(ymin = lower, ymax=upper)) +
  coord_flip() +
  # scale_color_manual(values=pidlpal) +
  labs(title="Predicted Probability of Alleged Neglect",
       x = "", color = "Hispanic",
       y = "Predicted Probability of Alleged Neglect",
       caption = "Note: error bars are 90% credible intervals")



# 3. Durations ----
# quantity of interest -- predicted duration/length

# install.packages("coxed")
library(coxed)
# https://cran.r-project.org/web/packages/coxed/vignettes/coxed.html#with-bootstrapped-standard-errors

# Set up the survival object
ph <- ph %>% 
  mutate(ph_event = if_else(is.na(exit_place_date), 0, 1)) # 1 if observed

S <- Surv(ph$place_dur, ph$ph_event) 

# reset the baseline for race
ph <- ph %>% 
  mutate(race = fct_relevel(race, "White"))

# survival model
dur1 <- coxph(S ~ race + gender, data = ph)
summary(dur1)
# a positive coefficient/hazard ratio > 1 means an increased hazard of event
# a negative coefficient/hazard ratio < 1 means a reduced hazard of event

# generate predicted probabilities from dur1: vary by race
# set up newdata that varies only by race
ph_new <- data.frame(race = c("White", "Black", "Multi-Race"),
                             gender = c("Female", "Female", "Female"))
ph_new

# generate predictions
pred_dur1 <- coxed(dur1, newdata = ph_new, method="npsf", 
                   bootstrap = TRUE, level = 0.9)
pred_dur1$exp.dur

ph_new <- ph_new %>% 
  cbind(pred_dur1$exp.dur)

# plot predicted durations
ggplot(ph_new, aes(x = fct_rev(race), y = exp.dur, color = race)) +
  geom_point(size=4) +
  geom_pointrange(aes(ymin = lb, ymax=ub)) +
  coord_flip() +
  # scale_color_manual(values=pidlpal) +
  labs(title="Predicted Duration of Individual Placement",
       x = "", color = "Race",
       y = "Predicted Duration in Days",
       caption = "Note: error bars are 90% confidence intervals")


# 4. Tables ----
# install.packages("stargazer")
library(stargazer)

stargazer(neglect2, type = "text")

# multiple models in same table
# generate a second model for illustration
abuse2 <- glm(phys_ab_dum ~ race5 + hisp_white + 
                  age + gender, 
                data = ref2, family = "binomial")

stargazer(neglect2, abuse2, type = "text")

# customize stuff
stargazer(neglect2, abuse2, type = "text",
          title = "Logit Models of Maltreatment Allegations",
          covariate.labels = c("Black", "Multiracial", "Asian",
                              "Race Unknown", "Hispanic",
                              "Age", "Male"),
          dep.var.caption = "", dep.var.labels.include=FALSE,
          column.labels = c("Physical Neglect", "Physical Abuse"),
          star.cutoffs = c(0.1, 0.05, .01))

?stargazer
