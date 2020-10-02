## Week 3 Assignment

[Rnotes_20201002.R](https://raw.githubusercontent.com/commpaslab/publicinterestdata_2020/main/assignments/Rnotes_20201002.R)

VDSS had indicated we'd have the Albemarle County data by the end of September, but alas, we're still waiting. So we'll continue practicing with R using the Albemarle County criminal court records for the week. 

Again, a simple data dictionary is available on a [shared google sheet](https://docs.google.com/spreadsheets/d/182TfRgi8-m9EnzME9E3mCa6rTqGMmTh2IGMDvWIuZq4/edit?usp=sharing). And more information about the codes which individuals are charged with violating are available at [the Code of Virginia site](https://law.lis.virginia.gov/vacode/).

### What to do
Using the same assignment1 folder as before begin a new script, called assign3_initials.R. In this well-commented/formatted script, answer the following questions about the data (using dplyr functions like select, filter, count, group_by, summarize, mutate, factor/forcats functions). Don't forget to load necessary packages upfront.

1. First, update the data to make all of the character variables factors, except for charge and code_section (these are better as strings). Then create a new variable collapsing responses to final disposition as below and ordering the levels of the variable by frequency. What's the frequency of this new disposition variable?

   * circuit: Certified misdemeanor and Certified grand jury -- these are all sent to be tried in circuit court
   * guilty: Guilty (admission of facts), Guilty in absentia (not in courtroom), Prepaid (fine is paid before hearing)
   * not guilty: Dismissed (closed without finding of guilt), Not guilty (finding of innocence), Noelle Prosequi (not enough evidence to convict, case dropped)
   * other: everything else

2. Using this new disposition variable (that is, grouping by), what's the mininium, maximum, and median of outcomes like fines, costs, sentence time, and license suspension time by disposition outcome? 
3. Using this new disposition variable along with race, what's the median and mean of outcomes like fines, costs, sentence time, and license suspension time by race (race6)?
4. What's the racial breakdown of this new disposition variable -- what's the proportion of each outcome by race?
5. Looking just at motor vehicle violations, what's the frequency of the new disposition variable? What's the mean and median of fines and costs by disposition?
6. Ask and answer one more question of your choosing of this data.


### What to submit
For these first few assignments, send them to me via direct message in Slack. Submit an R script with your code to answer the questions above, including comments providing narrative responses, by noon Friday, 10/9.
