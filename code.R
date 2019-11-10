library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(shinyalert)
library(data.table)
library(dplyr)
library(shinyWidgets)
library(filesstrings)
library(shinycssloaders)
library(rintrojs)
library(tools)
library(shinyjs)
library(lubridate)
library(pbapply)
library(httr)
library(jsonlite)
library(RCurl)
library(DT)

data <- fread('archive.csv')

byCountry <- data %>% select(Year,`Birth Country`)

byCountryCount <- byCountry %>% dplyr::group_by(Year,`Birth Country`) %>% dplyr::count()

byCountryCount$`Birth Country`[byCountryCount$`Birth Country` == '']<-NA

byCountryCount <- byCountryCount[complete.cases(byCountryCount$`Birth Country`),]

colnames(byCountryCount) <- c('year','birthCountry','count')

byCountrySpread <- dcast(setDT(byCountryCount), birthCountry ~ year, value.var = c("count"))
#byCountrySpread[is.na(byCountrySpread)] <- 0

fwrite(byCountrySpread,'nobelByCountry.csv')

byCountryCumsum <- byCountryCount %>% group_by(year,birthCountry) %>% mutate(count = cumsum(count))


byCountryCumsum$count <- ave(byCountryCount$count, byCountryCount$birthCountry, FUN=cumsum)
byCountryCumsum <- byCountryCumsum[,-3]
byCountryCumsum <- dcast(setDT(byCountryCumsum), birthCountry ~ year, value.var = c("csum"))

fwrite(byCountryCumsum,'nobelByCountryCunsum.csv')
  
