#install.packages("RMySQL")

library(RMySQL)
print("Hello")

mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname='project',
                            host='150.230.44.118',
                            port=3306,
                            user='project',
                            password='COMP541',
                            local_infile = TRUE)
dbListTables(mysqlconnection)

#result = dbSendQuery(mysqlconnection, "select * from Kaggle")
data <- read.csv("COMP541Project/R/WELFake_Dataset.csv")

head(data)
dbWriteTable(mysqlconnection, name = "Kaggle", value = data, row.names = FALSE, col.names = c("id", "title", "text", "label"), overwrite = TRUE)
print(names(data))
