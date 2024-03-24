library(RMySQL)


SQL_GET_DATA <- function(table, where = "") {
  
  
  conn = dbConnect(RMySQL::MySQL(),
                              dbname='project',
                              host='150.230.44.118',
                              port=3306,
                              user='project',
                              password='COMP541',
                              local_infile = TRUE)
  
  
  query <- paste0("SELECT * FROM `", table)
  
  if(where != "")
    query <- paste0(query, "` WHERE ", where)
  else
    query <- paste0(query, "`")
  
  data <- dbGetQuery(conn, statement = query)
  
  return(data)
  
}