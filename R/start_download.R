#' Start downloading the files from the given url, to the destination folder
#'
#' @param url The URL to download from
#' @param destination_folder The folder to save data to
#'
#' @return
#'
#' @noRd
#'
start_download <- function(url, destination_folder){

  #get the filename to be downloaded
  destination_filename <- basename(url)

  #check the folder exists, and if not, create it
  if (!isTRUE(file.info(destination_folder)$isdir)) dir.create(destination_folder, recursive=TRUE)

  #do the download
  download.file(url, file.path(destination_folder, destination_filename), mode = "wb")
}
