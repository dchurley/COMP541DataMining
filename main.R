library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(RSelenium)
library(RMySQL)


source("new_york_times_webscraper.R")
source("fox_news_webscraper.R")

# Developer: Jae Molina
# This project supports ChromeDriver version: 122.0.6261.94
# ChromeDriver (Win32) post Chome 115 downloads located at https://googlechromelabs.github.io/chrome-for-testing/#stable
# Install into %localappdata%/binman/binman_chromedriver/win32/
# Uncomment to see your version of ChomeDriver:

#  ```{r eval=FALSE}
#  binman::list_versions(appname = "chromedriver")
#  ```

# Setup database
mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname='project',
                            host='150.230.44.118',
                            port=3306,
                            user='project',
                            password='COMP541',
                            local_infile = TRUE)
dbListTables(mysqlconnection)
db_name <- "Articles"
# Database input function
insert_into_database <- function(current_site, title, author, summary, text) {
  # Do not insert data if text is null
  if(is.null(text)) {
    print("Warning: Could not insert into database, text is NULL.")
    return()
  }
  
  id <- as.integer(dbGetQuery(mysqlconnection, "SELECT COUNT(*) FROM Articles") + 1)
  
  # Send into database
  dbSendQuery(mysqlconnection, paste('SET @ID = ', id, ";"))
  dbSendQuery(mysqlconnection, paste('SET @source = "', current_site, '";'))
  dbSendQuery(mysqlconnection, paste('SET @title = "', title, '";'))
  dbSendQuery(mysqlconnection, paste('SET @author = "', author, '";'))
  dbSendQuery(mysqlconnection, paste('SET @summary = "', summary, '";'))
  dbSendQuery(mysqlconnection, paste('SET @text = "', text, '";'))
  
  dbSendQuery(mysqlconnection, paste('INSERT INTO', db_name, '(id, source, title, author, summary, text, rating)',
                                     'VALUES(@ID, @source, @title, @author, @summary, @text, NULL)'))
  
  result <- dbGetQuery(mysqlconnection, 'SELECT * FROM Articles WHERE ID = @id')
  print(result)
  id <- id + 1
}


# Setup the RSelenium to the ChromeDriver initializing the "server"
rD <- RSelenium::rsDriver() # This might throw an error
# Assign the client to an object
remDr <- rD[["client"]]

# NEW YORK TIMES WEB SCRAPER
current_site <- "New York Times"
links <- new_york_times_linkscraper("https://www.nytimes.com/section/politics")

for(link in links) {
  result <- new_york_times_webscraper(remDr, link)
  insert_into_database(current_site, result[[1]], result[[2]], result[[3]], result[[4]])
}

# FOX NEW WEBSCRAPER
current_site = "Fox News"
for(category in list("https://www.foxnews.com/category/politics/executive", 
                  "https://www.foxnews.com/category/politics/senate", 
                  "https://www.foxnews.com/category/politics/house-of-representatives",
                  "https://www.foxnews.com/category/politics/judiciary",
                  "https://www.foxnews.com/category/politics/foreign-policy")) {
  links <- fox_news_linkscraper(remDr, category)
  for(link in links) {
    result <- fox_news_webscraper(remDr, link)
    insert_into_database(current_site, result[[1]], result[[2]], result[[3]], result[[4]])
  }
}

# LA TIMES WEBSCAPER

# NEW YORK POST WEBSCRAPER

# CNN WEBSCRAPER

# THE EPOCH TIMES

# SITES PROVEN TO BE FAKE OR SATIRICAL OR HIGHLY BIASES

# THE ONION

# federalistpress.com

