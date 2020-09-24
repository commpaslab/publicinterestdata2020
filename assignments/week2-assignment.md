## Week 2 Assignment

Let's continue with the data pulled from Virginia Court records -- hearings for criminal cases filed in Albemarle County courts during 2019. Again, a simple data dictionary is available on a [shared google sheet](https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing).

### What to do
Building from the assignment1 folder you downloaded last week (and I'm just now seeing the limitations of my initial naming choice for this folder), begin a new script, called assign2_initials.R (e.g., assign2_mpc.R). In this well-commented/formatted script, answer the following questions about the data (using dplyr functions like select, arrange, filter, count, group_by, summarize). Don't forget to load necessary packages upfront.

1. For the cases charged the highest fines, what is the most common charge category (based on shortcode), case type, and final disposition?
2. Within charges related to motor vehicles, what's the frequency distribution of final dispositions? What are the three most common outcomes/dispositions? 
3. Within charges related to motor vehicles, what's the count of dispositions among White residents? among Black residents? 
4. Within charges related to motor vehicles, what's the average fine, the average costs, and the average sentence by race (race6)?
5. Consider charges related to motor vehicles classified as infractions or misdemeanors (case type) -- what's the most common disposition for vehicle infractions, what's the most common disposition for vehicle misdemeanors?
6. Consider the number of cases by date (hearing_date) -- generate the count by date and provide the average cases heard each day. What day had the most hearings, and how many were there?
7. Ask and answer one more question of your choosing of this data.


### What to submit
For these first few assignments, send them to me via direct message in Slack. Submit an R script with your code to answer the questions above, including comments providing narrative responses, by noon Friday, 10/2.


