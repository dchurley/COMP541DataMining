# Install required packages
#install.packages(c("tm", "e1071"))

# Load packages
library(tm)
library(e1071)

# Load the dataset (assuming it's a data frame with columns 'text' and 'label')
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

data = dbGetQuery(conn, statement = "select * from `Kaggle` where `X` < 1000")

# Create a corpus from the text data
corpus <- Corpus(VectorSource(data$text))

# Perform text preprocessing (convert to lowercase, remove punctuation, numbers, and stopwords)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Create a document-term matrix
dtm <- DocumentTermMatrix(corpus)

# Convert the document-term matrix to a sparse matrix
spam <- removeSparseTerms(dtm, 0.999)

# Create data frames for training and labels
train_data <- as.data.frame(as.matrix(spam))
labels <- data$label

# Train a Naive Bayes classifier
classifier <- naiveBayes(train_data, labels)

# Make predictions on new data
new_data <- "This is a new news article text to be classified."
new_corpus <- Corpus(VectorSource(new_data))
new_corpus <- tm_map(new_corpus, content_transformer(tolower))
new_corpus <- tm_map(new_corpus, removePunctuation)
new_corpus <- tm_map(new_corpus, removeNumbers)
new_corpus <- tm_map(new_corpus, removeWords, stopwords("english"))
new_dtm <- DocumentTermMatrix(new_corpus, list(dictionary = Terms(spam)))
new_spam <- removeSparseTerms(new_dtm, 0.999)
new_data <- as.data.frame(as.matrix(new_spam))
prediction <- predict(classifier, new_data)

# Print the prediction
print(prediction)