library(tm)

# Load the text data


library(RMySQL)
conn = dbConnect(RMySQL::MySQL(),
                            dbname='project',
                            host='150.230.44.118',
                            port=3306,
                            user='project',
                            password='COMP541',
                            local_infile = TRUE)

texts = dbGetQuery(conn, statement = "select `text` from `Kaggle` where `X` = 3")

#texts <- c("Text one for analysis", "Another text for analysis")

# Create a corpus
corpus <- Corpus(VectorSource(texts))

# Preprocess the corpus: remove punctuation, numbers, whitespace, and convert to lowercase
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)

# Create a document-term matrix
dtm <- DocumentTermMatrix(corpus)

# Inspect the document-term matrix
inspect(dtm)
