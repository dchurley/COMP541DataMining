#Import the library which contains the Groceries dataset
#as well as the apriori algorithm
library(arules)

#Load Groceries
data("Groceries")

#Ensure dataset is correct (9835 rows)
print(Groceries)

# Run Apriori algorithm
rules <- apriori(Groceries, parameter = list(supp = 0.02, conf = 0.2))

# Print top 10 rules
inspect(head(rules, n = 10))
