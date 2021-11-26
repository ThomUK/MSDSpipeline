#' Check for, and download MSDS data
#'
#' @param destination Character. The filepath where downloads will be saved
#' @param check_for_new_data Logical. Whether to skip checking for updates (to save time)
#' @param force_redownload_all
#'
#' @return NULL
#' @export

msds_download_data <- function(destination = "data/msds_download", check_for_new_data = TRUE, force_redownload_all = FALSE){

  if(check_for_new_data){

    main_url <- "https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics"

    links_df <- discover_links(main_url) %>%
      dplyr::filter(grepl("/data-and-information/publications", url)) #filter down to the publication links

    #create a master table of data file urls
    data_links <- NULL

    #for each link
    for(i in 1:nrow(links_df)){

      relative_page_url <- links_df[i,] %>% dplyr::pull(url)
      message(paste0("Reading url: ", relative_page_url))

      page_url <- paste0("https://digital.nhs.uk", relative_page_url)

      #find the links on the page
      page_links <- discover_links(page_url) %>%
        dplyr::filter(grepl(".csv|.xlsx", url)) %>% #filter down to .csv and .xlsx files
        identity()

      #add to the master table of file urls available to download
      data_links <- dplyr::bind_rows(data_links, page_links)

    }

    message(paste0("There are ", nrow(data_links), " MSDS files available for download."))

    #read the filenames of already downloaded files, including those sorted into subfolders
    existing_files <- list.files(destination, recursive = TRUE)
    message(paste0(length(existing_files), " files have previously been downloaded to this computer."))

    #add detail on what has already been downloaded to the dataframe
    data_links <- data_links %>%
      dplyr::mutate(
        filename = basename(url),
        already_downloaded = ifelse(filename %in% basename(existing_files), TRUE, FALSE)
      )

    #filter down to a list for downloading (unless force_redownload_all is TRUE)
    urls_to_download <- data_links %>%
      {
        if(force_redownload_all == FALSE) dplyr::filter(., already_downloaded == FALSE) else identity(.)
      } %>%
      dplyr::pull(url)

    message(paste0("There are ", length(urls_to_download), " new files to download."))

    #map/walk through each file and download it
    purrr::walk(.x = urls_to_download, destination_folder = destination, .f = start_download)

    #TODO write filename to a summary table

    message("All downloads complete.")
  }

  message("check_for_new_data is set to FALSE, no new data added.")

  sort_data_into_subfolders(download_location = destination)
}
