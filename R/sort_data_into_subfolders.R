#' Sort downloaded data into subfolders according to type.
#' Including individually handling any specific files with filename
#' inconsistencies which should be sorted to different folders.
#'
#' @param download_location The path of the folder containing fresh downloads
#'
#' @return NULL
#'
#' @noRd

sort_data_into_subfolders <- function(download_location){

  message("Sorting data into subfolders.")

  # new files are downloaded to the main folder
  new_files <- list.files(path = download_location)

  # move to subfolders
  purrr::map(new_files, move_file_into_subfolder, folder = download_location)

  # handle a mis-named file that gets sorted to the wrong folder automatically
  if(file.exists(file.path(download_location, "CQIM", "msds-jun2020-CQIM_v3.csv"))){

    move_file(file.path(download_location, "CQIM", "msds-jun2020-CQIM_v3.csv"), file.path(download_location, "measures", "msds-jun2020-CQIM_v3.csv"))
    # remove the now-empty CQIM folder
    unlink(file.path(download_location, "CQIM"), recursive = TRUE)
  }

  message("Data has been sorted into subfolders.")
  message("You may want to check the 'miscellaneous' folder for any new data that has be placed there in error...")
  message("(for example because of a filename typo).")
}
