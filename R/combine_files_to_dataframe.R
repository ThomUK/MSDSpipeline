#' Combine data files into dataframe
#'
#' @param type A string naming the data file type to combine
#' @param data_path Character string defining the path to the parent data folder
#'
#' @return A dataframe of the combined data
#'
#' @importFrom magrittr %>%
#'
#' @noRd

combine_files_to_dataframe <- function(type, data_path){

  #these are the 3 files that contain raw data
  valid_types <- c("exp-data", "measures", "exp-dq")

  if(!type %in% valid_types) stop("Dataframes can only be created for 'exp-data', 'measures', and 'exp-dq'")

  folder_name <- file.path(data_path, type)
  message(paste0("Combining files from: ", folder_name))

  files <- list.files(path = folder_name, full.names = TRUE)
  message(paste0("There are ", length(files) ," data files available to combine."))

  #read the files into a dataframe using map_dfr
  combined_data <- files %>%
    purrr::set_names() %>%
    purrr::map_dfr(.x = ., .f = read_csv_or_xlsx, .id = "Source_WB")

  #success summary
  message(paste0("Data from ", length(combined_data %>% dplyr::pull(Source_WB) %>% unique()) ," files appear in the data frame."))
  message(paste0(nrow(combined_data), " rows in total."))

  return(combined_data)
}
