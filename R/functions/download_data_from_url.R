download_data_from_url <- function(url, destination_folder){
  
  #get the filename to be downloaded
  destination_filename <- basename(url)
  
  #check the folder exists, and if not, create it
  todir <- paste0(getwd(), "/", destination_folder) # full file path
  if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
  
  #TODO fix the download location (folder is created, but files go into parent folder)
  
  #do the download
  download.file(url, paste0(todir, "/", destination_filename), mode = "wb")
}