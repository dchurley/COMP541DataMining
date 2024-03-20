# Install necessary packages if not already installed
if (!require("caret")) install.packages("caret")
if (!require("tm")) install.packages("tm")
if (!require("e1071")) install.packages("e1071")

# Load required libraries
library(caret)
library(tm)
library(e1071)

# Load your dataset (assuming it's in CSV format)
# Replace "your_dataset.csv" with the actual path to your dataset
library(RMySQL)
conn = dbConnect(RMySQL::MySQL(),
                 dbname='project',
                 host='150.230.44.118',
                 port=3306,
                 user='project',
                 password='COMP541',
                 local_infile = TRUE)

data = dbGetQuery(conn, statement = "select * from `Kaggle` where `X` < 100")


removeSpecialChars <- function(x) {
  gsub("[^a-zA-Z ]", "", x)
}


# Create a corpus from text data
corpus <- Corpus(VectorSource(data$text))

# clean the corpus
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removeSpecialChars))
corpus <- tm_map(corpus, removeWords, stopwords())
#remove the word said because it's the most common and it's boring
corpus <- tm_map(corpus, removeWords, "said")
corpus <- tm_map(corpus, stripWhitespace)

# Create a document-term matrix
dtm <- DocumentTermMatrix(corpus)
# Convert dtm to a matrix and then to a dataframe
dtm_matrix <- as.matrix(dtm)
dtm_df <- as.data.frame(dtm_matrix)

# Bind labels to the dataframe
dtm_df$label <- data$label

# Split data into training and testing sets
set.seed(123) # For reproducibility
trainIndex <- createDataPartition(dtm_df$label, p = .8, 
                                  list = FALSE, 
                                  times = 1)
train_data <- dtm_df[trainIndex, ]
test_data <- dtm_df[-trainIndex, ]

# Train a classifier
model <- svm(label ~ ., data = train_data)

# Make predictions on test data
predictions <- predict(model, newdata = test_data)

# Evaluate the model
confusion_matrix <- table(predictions, test_data$label)
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
cat("Accuracy:", accuracy, "\n")
 
