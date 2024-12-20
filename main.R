
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

#Step 5 : Getting all cleaned data after removing Cuba & North Korea
economic_cleaned_data <- economic_cleaned_data %>%
                      filter(!Country %in% c('Cuba', 'North Korea'))
economic_cleaned_data

#Step 6 : Getting all 12 pillar data from cleaned data 
economic_pillar_data <- economic_cleaned_data %>%
                      select(Overall_Score : Financial_Freedom)

#transpose version of print()
glimpse(economic_pillar_data)
nrow(economic_pillar_data)



#-------> Section 2 :
#--------> Part-1: R to build the Scatter matrix plot using ggpairs()

#Step-1: Installing ggPlot() and GGally() package for ploting scatter matrix plot

library(GGally)

#Step-2: Using ggpairs() of above library in data sets after removing NA values & sorting 
ggpairs(economic_pillar_data,
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
Single_predictor_model = lm(Overall_Score~Property_Rights , data = economic_pillar_data)
summary(Single_predictor_model)

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
library(car)
vif(model_1)
summary(model_1)

#R-Squared = 0.3958      ##### model-1
#Intercept =       30.58969   
#predictor(x) = 
      #--> Government_Spending -0.06461 *
      #--> Labor_Freedom        0.57853 ***

ggplot(data=economic_pillar_data, aes(x=(Government_Spending + Labor_Freedom), y=Overall_Score)) +
  geom_point() +
  geom_smooth(method=lm, se=TRUE)

#Step-2 = The best two-predictor model using any of the 12 pillar variables
model_2 <- lm(Overall_Score ~ Property_Rights + Tax_Burden, data = economic_pillar_data)
summary(model_2)
vif(model_2)

#----> scatter pot for fitted value 
ggplot(data=economic_pillar_data, aes(x=(Property_Rights + Tax_Burden), y=Overall_Score)) +
  geom_point() +
  geom_smooth(method=lm, se=TRUE)

#Bi-plot of model-3

#Step-3 = The best four-predictor model using any of the 12 pillar variables
model_3 <- lm(Overall_Score ~ Property_Rights + 
                              Tax_Burden + 
                              Trade_Freedom + 
                              Fiscal_Health, 
                          data = economic_pillar_data)
summary(model_3)
vif(model_3)

ggplot(data=economic_pillar_data, aes(x=(Property_Rights + Tax_Burden + Trade_Freedom + Fiscal_Health), y=Overall_Score)) +
  geom_point() +
  geom_smooth(method=lm, se=TRUE)

#Bi-plot of model-3
autoplot(model_3)


#--> Step-4 = The best linear model using any subset of variables from Pillar #1 and Pillar #2 only.
model_4 = lm(Overall_Score ~  Property_Rights + Government_Integrity + Judicial_Effectiveness + #pillar-1
                              Tax_Burden + Government_Spending + Fiscal_Health, #pillar-2
                              data = economic_pillar_data )  
summary(model_4)


vif(model_4) #multi-colinarity and if correlation value above 5 then model is not significant 

ggplot(data=economic_pillar_data, aes(x=(Property_Rights + Government_Integrity +
                                         Judicial_Effectiveness + #pillar-1
                                         Tax_Burden + Government_Spending + Fiscal_Health), y=Overall_Score)) +
                                         geom_point() +
                                         geom_smooth(method=lm, se=TRUE)
autoplot(model_4)


#----> Step-5: by region and any subset variable at most two variable of pillar 1 and 2 and 

economic_pillar_data <- economic_cleaned_data %>%
  select(Region : Financial_Freedom)

economic_pillar_data


model_5 = lm(Overall_Score ~ Region + Government_Integrity + Judicial_Effectiveness+ #Pillar-1
                             Government_Spending + Fiscal_Health +   #Pillar-2
                             Business_Freedom + Labor_Freedom +      #Pillar-3
                             Trade_Freedom + Investment_Freedom,     # Pillar-4 
                            data = economic_pillar_data ) 
summary(model_5)

vif (model_5)

ggplot(data = economic_pillar_data, 
       aes( x =(Government_Integrity + Judicial_Effectiveness +Government_Spending + Fiscal_Health +
               Business_Freedom + Labor_Freedom +      
               Trade_Freedom + Investment_Freedom), y=Overall_Score)) +
               geom_point() +geom_smooth(method=lm, se=TRUE)

#Di agonist-plot
autoplot(model_5)

AIC(model_1, model_2, model_3, model_4, model_5)
#if AIC value of the model is less the among all then this will be the best model




