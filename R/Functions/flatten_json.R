# Flatten JSON from GLEIF API
# Purpose: Flatten JSON to be a row of data from the GLEIF API 
# Input: 
#     JSON data from GLEIF API
# Output: 
#     Flattened data. One row of data than can be appended together to create   
#     a dataframe of LEIs
#
#
# Contact: Baker Research & Data Services (brds@hbs.edu)
# Repo: https://github.com/hbs-brds
# Website: https://www.library.hbs.edu/baker-research-data-services 

flatten_json <- function(data, parent_key = '', sep = ' ') {
  items <- list()
  for (k in names(data)) {
    new_key <- ifelse(parent_key == '', k, paste(parent_key, k, sep = sep))
    if (is.list(data[[k]])) {
      items <- c(items, flatten_json(data[[k]], new_key, sep))
    } else {
      items[[new_key]] <- data[[k]]
    }
  }
  return(items)
}
