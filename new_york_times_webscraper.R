# Developer: Jae Molina

new_york_times_linkscraper <- function(remDr, link) {
  # Navigate to the NYT Politics, something very polarizing and more likely to Fake News
  remDr$navigate(link)
  
  # Scroll down the site
  webElem <- remDr$findElement("css", "body")
  for(x in 1:20) {
    webElem$sendKeysToElement(list(key = "end"))
    Sys.sleep(2)
  }
  
  # New York Times as of March, 2024 has their articles under the CSS navigation with the ID stream-panel
  # Get the Articles from here
  webElem <- remDr$findElement("id", "stream-panel")
  
  # Articles contain the hyperlink to the article, save this element so we can iterate and get the hyperlinks
  webs <- webElem$findChildElements("css", "a")
  
  # Put all links into a variable
  links <- sapply(webs, function(x) x$getElementAttribute("href"))
  # Remove the "Unncessessary links
  links <- head(links, -14)
  return(links)
}

new_york_times_webscraper <- function(remDr, link) {
  title <- NULL
  author <- NULL
  summary <- NULL
  text <- NULL
  
  print(link)
  remDr$navigate(link)
  Sys.sleep(2)
  
  # Get the Title, Author and Summary of the article
  tryCatch({
    title <- remDr$findElement("css", "h1")$getElementText()[[1]]
  }, error = function(e) {
    cat("Could not collect Title Information:", conditionMessage(e), "\n")
    # You might want to add additional error-handling logic based on your requirements
  })
  
  tryCatch({
    author <- remDr$findElement("class", "authorPageLinkClass")$getElementAttribute("innerText")[[1]]
  }, error = function(e) {
    cat("Could not collect Author Information:", conditionMessage(e), "\n")
  })
  
  tryCatch({
    summary <- remDr$findElement("id", "article-summary")$getElementText()[[1]]
  }, error = function(e) {
    cat("Could not collect Summary Information:", conditionMessage(e), "\n")
  })
  
  # Get the Article text
  tryCatch({
    webElem <- remDr$findElement("name", "articleBody")
    paragraphs <- webElem$findChildElements("css", "p")
    text <- sapply(paragraphs, function(x) paste(x$getElementAttribute("innerText"), ""))
    # Remove the unneccessary text
    text <- head(text, -1)
    text <- str_flatten(text)
    # REMOVE ADVERTISEMENT STRING
    text <- gsub(' ADVERTISEMENT', '', text)
  }, error = function(e) {
    cat("Could not collect article Information:", conditionMessage(e), "\n")
  })
  return(list(title, author, summary, text))
}