# Pull LEIs From GLEIF API 
# Purpose: Pull data from a list of LEIs from the GLEIF API 
# Input: 
#     csv file with list of LEIs 
# Output: 
#     Informaiton on these LEIs from the GLEIF API  
#     (EG: Company name, date issues, LEI Status etc.)
#
#
# Contact: Baker Research & Data Services  (brds@hbs.edu)
# Repo: https://github.com/hbs-brds
# Website: https://www.library.hbs.edu/baker-research-data-services 



## --- I. Set Up ----
rm(list=ls())
dir <- getwd()

### Packages ----
library(dplyr)
library(tidyverse)
library(utils)
library(stringr)
library(lubridate)
library(curl)
library(rjson)
library(readr)
library(glue)

### Functions ----
source(file=glue("{dir}/Functions/flatten_json.R"))
source(file=glue("{dir}/Functions/gleifapi_getdata_fromlei.R"))


### Import ---- 
lei_list <- read.csv("Input/SampleLEIList.csv")


## LEI Look up code ----
firstloop = TRUE 
lei_list <- head(lei_list)
# Loop through list of LEIs
for (i in 1:nrow(lei_list)) {
  # Set API information for this specific LEI
  lei <- lei_list$LEI[i]
  print(lei)
  url <- paste0("https://api.gleif.org/api/v1/lei-records/",lei)
  res <- curl_fetch_memory(url)
  
  #Pause for API Limits
  Sys.sleep(1.3) 
  
  # Get data, format
  single_lei <- gleifapi_getdata_fromlei(lei)
  
  # Append data  
  if(firstloop) {
    all_leis <- single_lei 
    firstloop <- FALSE
  }
  else {
    all_leis <- bind_rows(all_leis, single_lei)
  }
}

# Standardize Data Frame
export <- data.frame(lapply(all_leis, function(x) {
  if (is.list(x)) {
    return(sapply(x, toString))
  } else {
    return(x)
  }
}), stringsAsFactors = FALSE)


# Export Data on LEIs
export %>% 
  write_csv(glue("{dir}/Export/SampleLEIList_APIPull.csv"))
