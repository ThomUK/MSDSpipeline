#' Check for, and download MSDS data
#'
#' @param destination Character. The filepath where downloads will be saved
#' @param relative_path Logical (default TRUE). Whether the desination path will be treated as relative to working directory
#'
#' @return NULL
#' @export
#'
#' @examples
#' # download data to the default directory path
#' msds_download_data()
#'
#' # download data to a different (relative) directory path
#' msds_download_data(destination = "a/different/directory")
#'
#' # download data to an absolute directory path, or network path
#' msds_download_data(destination = "C:/your/hard/drive/msds_data", relative_path = FALSE)

msds_download_data <- function(destination = "data/msds_download", relative_path = TRUE){

  path <- build_data_path(destination = destination, relative_path = relative_path)

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
  existing_files <- list.files(path, recursive = TRUE)
  message(paste0(length(existing_files), " files have previously been downloaded to this computer."))

  #add detail on what has already been downloaded to the dataframe
  data_links <- data_links %>%
    dplyr::mutate(
      filename = basename(url),
      already_downloaded = ifelse(filename %in% basename(existing_files), TRUE, FALSE)
    )

  #filter down to a list for downloading
  urls_to_download <- data_links %>%
    dplyr::filter(already_downloaded == FALSE) %>%
    dplyr::pull(url)

  message(paste0("There are ", length(urls_to_download), " new files to download."))

  #map/walk through each file and download it
  purrr::walk(.x = urls_to_download, destination_folder = path, .f = start_download)

  #TODO write filename to a summary table

  message("All downloads complete.")

  sort_data_into_subfolders(download_location = path)
}
