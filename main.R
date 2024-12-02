
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
glimpse(economic_data)

#Step 1: checking all NA values in data sets using Summary() method
summary(economic_data)

#Step 2: Number of rows 
nrow(economic_data)

#step 3: removing NA values from each row 
economic_cleaned_data = na.omit(economic_data)
economic_cleaned_data

#Step 4: Checking all NA values in data-set after removing rows having NA values 
summary(economic_cleaned_data)

#number of rows after removing 
nrow(economic_cleaned_data)

#step 4 : Sorting data sets using overall_score highest to lowest
economic_cleaned_data = arrange(economic_cleaned_data,desc(Overall_Score))
economic_cleaned_data

#Step 5 : geting all 12 pillar data from cleaned data 
economic_pillar_data <- economic_cleaned_data %>%
                      filter(!Country %in% c('Cuba', 'North Korea')) %>%
                      select(Overall_Score : Financial_Freedom)
glimpse(economic_pillar_data)
nrow(economic_pillar_data)

#-Section 2 :
#--------> Part-1: R to build the Scatter matrix plot using ggpairs()

#Step-1: Installing ggPlot() and GGally() package for ploting scatter matrix plot

library(ggplot2)
library(GGally)

#Step-2: Using ggpairs() of above library in data sets after removing NA values & sorting 
ggpairs(economic_pillar_data,
        aes(),
        title = "Scatter Matrix of Economic Freedom Variables by Region",
        )

# Compute correlation matrix for the pillar variables
correlation_matrix <- cor(economic_pillar_data, use = "complete.obs")
# Print the correlation matrix
print(correlation_matrix)


library(corrplot)

# Create a correlogram
corrplot(correlation_matrix, method = "color", type = "upper", tl.cex = 0.8, addCoef.col = "black")

#Step - 3 : Single-predictor Linear Model 
model = lm(Overall_Score~Property_Rights , data = economic_pillar_data)
model
summary(model)

#step -4 : To check Residual and fitted value and Normal Q-Q
library(ggfortify)
autoplot(model)


#------ Section-3
#---------------> Part-A:  <------------
#==============================

# Briefly explanation about the AIC (Akaike Information Criterion) when using compare the model 


#----------------> Part-B:   <-----------
library(olsrr)

#Step-1 = linear model using only government spending and labor freedom as predictors.
model_1 = lm(Overall_Score ~ Government_Spending + Labor_Freedom, data = economic_pillar_data)
model_1
summary(model_1)

#Step-2 = The best two-predictor model using any of the 12 pillar variables
model_2 <- lm(Overall_Score ~ Property_Rights + Tax_Burden, data = economic_pillar_data)
summary(model_2)

#Step-3 = The best four-predictor model using any of the 12 pillar variables
model_3 <- lm(Overall_Score ~ Property_Rights + 
                              Tax_Burden + 
                              Trade_Freedom + 
                              Fiscal_Health, 
                          data = economic_pillar_data)
summary(model_3)


AIC(model_1, model_2, model_3)












