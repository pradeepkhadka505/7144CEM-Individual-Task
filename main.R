
#tidyverse is library for EDA 
library(tidyverse)

#-Section-1 : 
#---------> 1. loading Data sets 
#---------> 2. Checking all NA values of Data sets using Summary method 
#---------> 3. checking number of rows having NA values 
#---------> 4. Removing NA values from Data sets 
#---------> 5. Checking Data sets Summary method 
#---------> 6. checking number of rows after removing NA values
#========================================================================

#loading data from data sets 
economic_data = read_csv("data/index_of_economic_freedom_2024.csv")
economic_data
#view all to columns
colnames(economic_data)

#Step 1: checking all NA values in data sets using Summary() method
summary(economic_data)

#Step 2: Number of rows 
nrow(economic_data)

#step 3: removing NA values from each row 
economic_data_na = na.omit(economic_data)
economic_data_na

#Step 4: Checking all NA values in data-set after removing rows having NA values 
summary(economic_data_na)

#number of rows after removing 
nrow(economic_data_na)

#step 4 : Sorting data sets using overall_score highest to lowest
economic_data_na <- economic_data_na %>%
                arrange(desc(Overall_Score))
economic_data_na












