discover_data_type <- function(filename){

  #files with the following patterns in their names will be moved to dedicated subfolders
  raw_data_types <- c("exp-data", "measures", "CQIM", "exp-dq", "exp-meta", "exp-pa", "exp-rdt", "exp-qual")

  #keep is a variation of the map() function
  type <- purrr::keep(raw_data_types, function(x) stringr::str_detect(filename, x))

  #if the type wasn't listed, put it in the miscellaneous folder
  result <- ifelse(purrr::is_empty(type), "miscellaneous", type)

  return(result)
}
