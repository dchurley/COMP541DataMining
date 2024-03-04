library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(RSelenium)
library(RMySQL)

# Developer: Jae Molina
# This project supports ChromeDriver version: 122.0.6261.94
# ChromeDriver (Win32) post Chome 115 downloads located at https://googlechromelabs.github.io/chrome-for-testing/#stable
# Install into %localappdata%/binman/binman_chromedriver/win32/
# Uncomment to see your version of ChomeDriver:

#  ```{r eval=FALSE}
#  binman::list_versions(appname = "chromedriver")
#  ```

mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname='project',
                            host='150.230.44.118',
                            port=3306,
                            user='project',
                            password='COMP541',
                            local_infile = TRUE)
dbListTables(mysqlconnection)


# Setup the RSelenium to the ChromeDriver initializing the "server"
```{r, eval=FALSE}
rD <- RSelenium::rsDriver() # This might throw an error
```

# Assign the client to an object
remDr <- rD[["client"]]

# NEW YORK TIMES WEB SCRAPER

# Navigate to the NYT Politics, something very polarizing and more likely to Fake News
remDr$navigate("https://www.nytimes.com/section/politics")

# Scroll down the site
webElem <- remDr$findElement("css", "body")
for(x in 1:10) {
  webElem$sendKeysToElement(list(key = "end"))
}

# Get the WebSource of the Page
```{r, eval=FALSE}
webSource <- remDr$getPageSource()[[1]]
```

# New York Times as of March, 2024 has their articles under the CSS navigation with the ID stream-panel
# Get the Articles from here
webElem <- remDr$findElement("id", "stream-panel")

# Articles contain the hyperlink to the article, save this element so we can iterate and get the hyperlinks
webs <- webElem$findChildElements("css", "a")

links <- sapply(webs, function(x) x$getElementAttribute("href"))

# Go through each article and collect the articles
lapply(links, function(x) remDr$navigate(x))

remDr$navigate("https://www.nytimes.com/2024/03/04/us/politics/faa-boeing-737-max-audit.html")

# Get the Title, Author and Summary of the article
title <- remDr$findElement("css", "h1")$getElementText()[[1]]
author <- remDr$findElement("class", "authorPageLinkClass")$getElementAttribute("innerText")[[1]]
summary <- remDr$findElement("id", "article-summary")$getElementText()[[1]]

# Get the Article text
webElem <- remDr$findElement("name", "articleBody")
paragraphs <- webElem$findChildElements("css", "p")
text <- sapply(paragraphs, function(x) x$getElementAttribute("innerText"))
# Remove the unneccessary text
text <- head(text, -1)
text <- str_flatten(text)

# SITES VARYING THE POLITICAL SPECTRUM

# FOX NEW WEBSCRAPER

# LA TIMES WEBSCAPER

# NEW YORK POST WEBSCRAPER

# CNN WEBSCRAPER

# THE EPOCH TIMES

# SITES PROVEN TO BE FAKE OR SATIRICAL OR HIGHLY BIASES

# THE ONION

# federalistpress.com

