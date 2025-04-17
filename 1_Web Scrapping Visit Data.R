##################################################################
##################################################################
# Lee & Kim, SSQ 2024
# Replication R Script
# Web-Scrapping U.S. high-level visit data
##################################################################
rm(list=ls())
##################################################################
### Loading Libraries
library(httr)
library(stringr)
library(rvest)
library(XML)
library(foreign)
library(Jmisc)
##################################################################
setwd("./")
##################################################################
### Base Setting
url_base <- "https://history.state.gov" 
sec <- "/departmenthistory/travels/secretary"
pre <- "/departmenthistory/travels/president"

##################################################################
### Crawling Secretary Travels 
# Link extractions for secretary travel
url_sec <- paste(url_base, sec, sep='')
# Travels based on destination countries
sec_links <- read_html(url_sec) %>% html_nodes('a') %>% html_attr('href')
sec_links <- sec_links[71:260]
sec_clist <- substring(sec_links, 38)

# Access to each destination country page to extract the histroy of secretary visits
for(n in 1:190){
  # Specify the url for the page of each destination country
  urlcode <- paste(url_base, sec_links[n], sep = '')
  # Extract the table containing visit information
  codetable <- read_html(urlcode) %>% html_nodes('table') %>% html_table
  # Save the information as a data frame
  codetable <- data.frame(codetable)
  # Specify the name of the destination country 
  base_html <- "/html/body/div/section/div/main/div[1]/short-form-name"
  in_node <- GET(urlcode) %>% htmlParse() %>% xpathSApply(base_html,xmlValue)
    if(length(in_node) == 0){
      codetable[,"Country"] <-sec_clist[n]
    }
    else{codetable[,"Country"] <-  in_node}
  if(n == 1){sec.data <- codetable}
  else {sec.data <- rbind(sec.data, codetable)}
}

# Add a column saving the information of visit year 
sec.data[,"Year"] <- substring(sec.data[,"Date"], regexpr(",", sec.data[,"Date"]) + 1)
sec.data[,"Year"] <- substring(sec.data[,"Year"], first = 2, last = 5)

# Delete the travels that are not about meeting official leaders. 

write.csv(sec.data, file="./Webscrapped/sec_data.csv")

##################################################################
### Crawling President Travels 
url_pre <- paste(url_base, pre, sep='')

pre_links <- read_html(url_pre) %>% html_nodes('a') %>% html_attr('href')
pre_links <- pre_links[59:178]
pre_clist <- substring(pre_links, 38)

for(n in 1:120){
  urlcode <- paste(url_base, pre_links[n], sep = '')
  codetable <- read_html(urlcode) %>% html_nodes('table') %>% html_table
  codetable <- data.frame(codetable)
  base_html <- "/html/body/div/section/div/main/div[1]/short-form-name"
  in_node <- GET(urlcode) %>% htmlParse() %>% xpathSApply(base_html,xmlValue)
  if(length(in_node) == 0){
    codetable[,"Country"] <-pre_clist[n]
  }
  else{codetable[,"Country"] <-  in_node}
  if(n == 1){pre.data <- codetable}
  else {pre.data <- rbind(pre.data, codetable)}
}

pre.data[,"Year"] <- substring(pre.data[,"Date"], regexpr(",", pre.data[,"Date"]) + 1)
pre.data[,"Year"] <- substring(pre.data[,"Year"], first = 2, last = 5)


write.csv(pre.data, file="./Webscrapped/pre_data.csv")
