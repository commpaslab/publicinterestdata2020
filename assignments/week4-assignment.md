## Week 4 Assignment

We have the data! So this week's assignment consists of two main pieces -- (a) filling out the data dictionary (which will require some exploration of a data set) and (b) practicing some visualization (and working with dates) on a dataset. 

The VDSS data came in four files

* Referral_Clients
* CPS_Ongoing_Clients
* Foster_Care_Clients
* Placement_History

I've created a data dictionary for Referral_Clients -- both to get us started and as a model (including some points where I need to seek clarification). We'll split into groups of 3, and each group will focus on one of the remaining data sets for both (a) and (b).

### The data dictionary -- done once as a group

The shared google sheet for the [data dictionary is here](https://docs.google.com/spreadsheets/d/1_Q_MlYg7DVthBMekUBGI1nZ8n2DcUTe6mTKO3aJOB-I/edit?usp=sharing) (also in the R scripts and I'll post to slack). For your assigned data set

* Add the current variable names, the current variable type, the variable type desired, and a proposed new variable name that will be easier to use (we'll use these files to implement the changes later; it will make our clean up code simpler and guarantee consistency).
* Provide a brief description of what you think the variable is capturing -- here, it might be useful to look at the data dictionaries for Charlottesville (I'll point to these, and some other userful resources, again in slack/alb-dss-materials).
* Provide the response possibilites for limited categorical variables (not needed for real numeric/integer values; and can be truncated for variables with more 10 or more responses -- that almost certainly means we'll need to collapse these to be useful) and what you believe the responses mean if it's not self-evident (again, the resources I'll post in slack might provide more insight).
* Finally, tell us how much missingness is present, and if it makes sense (e.g., is it missing because that outcome isn't relevant for some cases; this is where the example for referrals could be useful)

We won't necessarily know what everything is at the outset, so it's important to document on the sheet where we need to seek clarification or verification from other sources. And we'll continue to refine this as we learn more.

### The data viz and working with dates -- done individually
You should now be working in the encrypted volume. For each data set, I've tried to generate an analagous set of tasks to get us started. The specific questions for each dataset are provided in starter scripts in the folder I shared. But in general, they boil down to

1. Read in the assigned data set and clean the names (this name cleaning is temporoary; we'll use more intentional and targeted names after filling out the data dictionary)
2. Make a histogram of something
3. Make a table of counts and percents of records by race
4. Make a scatterplot of something (let's call it Y) by race -- trying various options like jitter and quasirandom
5. Calculate the average of Y by race, and see if you can add it to the figure you made in 3.
6. Generate a measure of duration -- time between two dates.
7. Make a histogram of that duration, along with a scatterplot of the duration by race.

### What to submit
The google sheet should be updated for all to see and share. The data viz/dates exploration of your data set should be sent to me via direct message in Slack by noon Friday, 10/16.
