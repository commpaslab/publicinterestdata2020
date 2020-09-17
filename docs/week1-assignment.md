## Week 1 Assignment

We're working with different administrative data set this week as we await the new data from VDSS. This is data pulled from Virginia Court records and represents criminal cases filed in Albemarle County courts during 2019. A simple data dictionary is available on a [shared google sheet](https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing).

### What to do
To start, download this zipped folder, assignment1. It contains 

* an .Rproj file which you should click to start an RStudio session
* a data folder with the file alb_court.csv
* a script folder with the Rnotes for September 18

For this assignment you should begin a new script, called assign1_initials.R (for me, it would be assign1_mpc.R). In this well-commented/formatted script, answer the following questions about the data (using functions like str, head, summary, skim, table/xtabs, prop.table/proportions). Don't forget to load necessary packages upfront.

1. How many variables in this data are numeric? Character? Dates? What other types are present.
2. What are the mean, min, and max of fines imposed by the court? For how many cases is this value missing? What are the mean, min, and max of costs assigned to defendants, along with the rate of missingness?
3. What is the distribution of race for individuals charged in Albemarle County? Look at both Race and Race6.
4. Race6 is a variable I created -- create a contingency table/cross-tab of Race and Race6 -- can you describe how I created Race6 from Race?
5. What is the distribution of shortcode, the truncated charge code variable I created? Based on the distribution, what category of criminal charge is made most frequently? Provde the category and percent of charges made in Albemarle in 2019 for the top three categories of charges?
6. Compare the frequency of charge categories by race. Are there any notable differences in the category of crimes with which people are charged in Albemarle County court based on race?
7. Ask and answer one more question of your choosing of this data.


### What to submit
For these first few assignments, send them to me via direct message in Slack. Submit an R script with your code to answer the questions above, including comments providing narrative responses, by noon Friday, 9/25.


