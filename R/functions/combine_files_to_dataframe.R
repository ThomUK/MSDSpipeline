combine_files_to_dataframe <- function(type){
  
  #these are the 3 files that contain raw data
  valid_types <- c("exp-data", "measures", "exp-dq")
  
  if(!type %in% valid_types) stop("Dataframes can only be created for 'exp-data', 'measures', and 'exp-dq'")
  
  folder_name <- paste0(getwd(), "/data/downloaded/", type)
  message(paste0("Combining files from: ", folder_name))  
  
  files <- list.files(path = folder_name, full.names = TRUE)
  message(paste0("There are ", length(files) ," data files available to combine."))
  
  #read the files into a dataframe using map_dfr
  combined_data <- files %>% 
    set_names() %>% 
    map_dfr(.x = ., .f = read_csv, .id = "source_wb", col_types = cols(.default = "c"))
  
  #success summary
  message(paste0("Data from ", length(combined_data %>% pull(source_wb) %>% unique()) ," files appear in the data frame."))
  message(paste0(nrow(combined_data), " rows in total."))
  
  return(combined_data)
}