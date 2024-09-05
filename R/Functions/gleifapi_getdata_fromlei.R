# leipull_gleifapi
# Purpose: Pull Data for one LEI from the GLEIF API, return a clean row of data on that LEI
# Input: 
#     JSON data from GLEIF API
# Output: 
#     Flattened data. One row of data than can be appended together to create   
#     a dataframe of LEIs
#
# Contact: Baker Research & Data Services (brds@hbs.edu)
# Repo: https://github.com/hbs-brds
# Website: https://www.library.hbs.edu/baker-research-data-services 


# Function
gleifapi_getdata_fromlei  <- function(lei) {
  # Set API information for this specific LEI
  url <- paste0("https://api.gleif.org/api/v1/lei-records/",lei)
  res <- curl_fetch_memory(url)
  
  #Pause for API Limits
  Sys.sleep(1.3)
  
  # Get data, format
  content <- rawToChar(res$content)
  parsed_data <- fromJSON(content)
  flattened_data <- flatten_json(parsed_data)
  transpose_flat <- t(flattened_data)
  transpose_flat <- as.data.frame(transpose_flat)
  
  return(transpose_flat)
}
