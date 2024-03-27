library(RMySQL)
print("Hello")

conn = dbConnect(RMySQL::MySQL(),
                            dbname='project',
                            host='150.230.44.118',
                            port=3306,
                            user='project',
                            password='COMP541',
                            local_infile = TRUE)

#result = dbSendQuery(mysqlconnection, "select * from Kaggle")
#data <- read.csv("COMP541Project/R/WELFake_Dataset.csv")
true_data <- read.csv("R/True.csv")
fake_data <- read.csv("R/fake.csv")

true_data$label = 1
fake_data$label = 0

data <- rbind(true_data, fake_data)

# Assuming df is your data frame and you want to write columns "col1" and "col2" into a table named "target_table"
# Subset the columns of interest
data <- data[, c("title", "subject", "text", "label")]

# Write the subsetted data frame into the target table
# If the table already exists and you want to append the data, you can set append = TRUE
dbWriteTable(conn, name = "Tutorial", value = data, append = TRUE, row.names = FALSE)

# Close the database connection
dbDisconnect(con)

head(data)
