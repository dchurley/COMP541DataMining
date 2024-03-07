# Developer: Jae Molina

fox_news_linkscraper <- function(remDr, link) {
  remDr$navigate(link)
  webElem <- remDr$findElement("xpath", "//a[contains(text(),'Show More')]")
  for(x in 1:10) {
    webElem$clickElement()
    Sys.sleep(1)
  }
  webElem <- remDr$findElement("xpath", "//body/div[@id='__nuxt']/div[@id='__layout']/div[@id='wrapper']/div[2]/div[3]/div[1]/main[1]/section[1]/div[1]")
  links <- lapply(webElem$findChildElements("class", "article"), function(x) paste0(str_flatten(x$findChildElement("css", "a")$getElementAttribute("href")), ".amp"))
  return(links)
}

fox_news_webscraper <- function(remDr, link) {
  title <- NULL
  author <- NULL
  summary <- NULL
  text <- NULL
  
  print(link)
  remDr$navigate(link)
  Sys.sleep(2)
  
  # Get Title
  tryCatch({
    title <- remDr$findElement("xpath", "/html[1]/body[1]/div[1]/div[1]/div[2]/div[1]/div[1]/article[1]/header[1]/h1[1]")
    title <- title$getElementAttribute("innerText")
  }, error = function(e) {
    cat("Could not collect Title Information:", conditionMessage(e), "\n")
  })
  
  # Get Author
  tryCatch({
    author <- remDr$findElement("xpath", "/html[1]/body[1]/div[1]/div[1]/div[2]/div[1]/div[1]/article[1]/header[1]/div[3]/div[1]/span[1]/span[1]/a[1]")
    author <- author$getElementAttribute("innerText")
  }, error = function(e) {
    cat("Could not collect Author Information:", conditionMessage(e), "\n")
  })
  
  tryCatch({
    # Get Text
    webElem <- remDr$findElement("xpath", "//body/div[@id='wrapper']/div[1]/div[2]/div[1]/div[1]/article[1]/div[1]/div[1]/div[1]")
    text <- sapply(webElem$findChildElements("css", "p"), function(x){
      x$getElementAttribute("innerText")
    })
    summary <- text[[1]]
    summary <- gsub('\"', '', str_flatten(summary))
  }, error = function(e) {
    cat("Could not collect Article Information:", conditionMessage(e), "\n")
  })
  
  # Get Summary & Cleanup Text
  tryCatch({
    for(paragraph in webElem$findChildElements("css", "p")[]) {
      tryCatch({
        webElem <- paragraph$findChildElement("css", "strong")
        text <- (gsub(str_flatten(webElem$getElementAttribute("innerText")), '', text))
      }, error = function(e) {cat()} )
    }
  }, error = function(e) {cat()})
  
  text <- gsub('\"', '', str_flatten(text))
  
  return(list(title, author, summary, text))
}
