Simple Example
================

### Step 1

First, we are going to load some libraries. You will not need all of
them, but it will save you some time to have all of them loaded anyway.

``` r
# Loading the libraries

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
```

### Step 2

Load the data

``` r
data <- fread('archive.csv')
```

### Step 3

Select the necessary columns and count

``` r
byCountry <- data %>% select(Year,`Birth Country`)

byCountryCount <- byCountry %>% dplyr::group_by(Year,`Birth Country`) %>% dplyr::count()
```

### Step 4

Turn empty spaces into NAs, keep only valid data, and rename the columns
for future work

``` r
byCountryCount$`Birth Country`[byCountryCount$`Birth Country` == '']<-NA

byCountryCount <- byCountryCount[complete.cases(byCountryCount$`Birth Country`),]

colnames(byCountryCount) <- c('year','birthCountry','count')
```

### Step 5

Take a long dataset and reshape it to make it
wide

``` r
byCountrySpread <- dcast(setDT(byCountryCount), birthCountry ~ year, value.var = c("count"))
```

### Step 6

Write out the result

``` r
  fwrite(byCountrySpread,'nobelByCountry.csv')
```
