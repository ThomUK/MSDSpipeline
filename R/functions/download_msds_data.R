download_msds_data <- function(destination = "data/downloaded", check_for_new_data = TRUE, force_redownload_all = FALSE){
  
  if(check_for_new_data == FALSE) return(message("check_for_new_data is set to FALSE, no new data added."))
  
  main_url <- "https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics"
  
  links_df <- discover_links(main_url) %>% 
    filter(grepl("/data-and-information/publications", url)) #filter down to the publication links
  
  #create a master table of data file urls
  data_links <- NULL
  
  #for each link
  for(i in 1:nrow(links_df)){
    
    relative_page_url <- links_df[i,] %>% pull(url)
    message(paste0("Reading url: ", relative_page_url))
    
    page_url <- paste0("https://digital.nhs.uk", relative_page_url)
    
    #find the links on the page
    page_links <- discover_links(page_url) %>% 
      filter(grepl(".csv|.xlsx", url)) %>% #filter down to .csv and .xlsx files
      identity()
    
    #add to the master table of file urls available to download
    data_links <- bind_rows(data_links, page_links)
    
  }
  
  message(paste0("There are ", nrow(data_links), " MSDS files available for download."))
  
  #read the filenames of already downloaded files
  existing_files <- list.files(destination)
  message(paste0(length(existing_files), " files have previously been downloaded to this computer."))
  
  #add detail on what has already been downloaded to the dataframe
  data_links <- data_links %>% 
    mutate(
      filename = basename(url),
      already_downloaded = ifelse(filename %in% existing_files, TRUE, FALSE)
    )
  
  #filter down to a list for downloading (unless force_redownload_all is TRUE)
  urls_to_download <- data_links %>% 
    {
      if(force_redownload_all == FALSE) filter(., already_downloaded == FALSE) else identity(.) 
    } %>%
    pull(url)
  
  message(paste0("There are ", length(urls_to_download), " new files to download."))
  
  #map/walk through each file and download it
  walk(.x = urls_to_download, destination_folder = destination, .f = download_data_from_url)
  
  #TODO write filename to a summary table
  
  message("All downloads complete.")
}
