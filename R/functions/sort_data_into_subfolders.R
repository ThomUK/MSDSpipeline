sort_data_into_subfolders <- function(){
  
  message("Sorting data into subfolders.")
  
  #new files are downloaded to the main folder
  new_files <- list.files(path = "data/downloaded")
  
  #move to subfolders
  map(new_files, move_file_into_subfolder)
  
  message("Data has been sorted into subfolders.")
  message("You may want to check the 'miscellaneous' folder for any new data that has be placed there in error (for example because of a filename typo).")
}
