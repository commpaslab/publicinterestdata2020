# Public Interest Data Lab 2020
# Chi-square and logit model examples
# 2020-11-06
# mpc

# 0. Set up ----
library(tidyverse)
library(skimr)
library(broom)


# 1. Read the data ----
ref <- readRDS("data/referrals_clean.rds")
skim(ref)


# 2. Comparing proportions ----
# a. Differences in allegations of neglect by Hispanic ethnicity?

table(ref$hispanic, ref$phys_neg_dum)

# let's recode this for the moment
ref <- ref %>% 
  mutate(hisp2 = fct_collapse(hispanic, 
                            nonhispanic = c("D", "N", "U"),
                            hispanic = "Y"))
table(ref$hisp2, ref$phys_neg_dum)

prop.table(table(ref$hisp2, ref$phys_neg_dum), 1)

# a chi-square test of the difference
chisq.test(ref$hisp2, ref$phys_neg_dum)

# when cell counts are small, the distributional approximations can be poor; 
#   simulating the p-values is one way of accounting for this 
#   (these p-values will often be larger);
chisq.test(ref$hispanic, ref$phys_neg_dum)
chisq.test(ref$hispanic, ref$phys_neg_dum, simulate.p.value = TRUE)

#   another approach is to use a Fisher's exact test
fisher.test(ref$hispanic, ref$phys_neg_dum)


# 3. Generate a model of maltreatment ----
# a. Super basic model of allegation of physical neglect
# let's use the binary indicators for race/ethnicity -- and add one for multiracial
neglect1 <- glm(phys_neg_dum ~ black + asian + nhpi + am_ind + hisp2 + 
                  age + gender, 
              data = ref, family = "binomial")
# model coefficients and summary stats
summary(neglect1)

# b. adding polynomial for age
# the poly function doesn't allow missing data, though obs with missing values are 
# already dropped from the estimation sample; still, to use poly, I have to formally
# remove these obs
ref2 <- ref %>% filter(!is.na(age))

neglect2 <- glm(phys_neg_dum ~ black + asian + nhpi + am_ind + hisp2 + 
                  poly(age, 2) + gender, 
              data = ref2, family = "binomial")
summary(neglect2)

# c. is model with age-squared "better"?
# AIC comparison
AIC(neglect1)
AIC(neglect2)
# lower values are better -- so, neglect1 (without age-squared) fits better (barely)

# more formally, anova test of nested models;
# does fuller model improve fit over reduced model?
anova(neglect2, neglect1, test = "Chisq")


# 4. Tidy models ----
# Helpful summaries with broom
tidy_neglect1 <- tidy(neglect1, conf.int = TRUE, conf.level = 0.9)

ggplot(tidy_neglect1, aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0)

# remove the intercept
tidy_neglect1 %>% 
  filter(term != "(Intercept)") %>% 
  ggplot(aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0)

