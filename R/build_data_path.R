build_data_path <- function(destination, relative_path){

  assertthat::assert_that(
    inherits(destination, "character"),
    msg = "build_data_path: destination argument must be a character vector."
  )

  assertthat::assert_that(
    inherits(relative_path, "logical"),
    msg = "build_data_path: relative_path argument must be logical."
  )

  if(relative_path){
    file.path(getwd(), destination)
  } else {
    file.path(destination)
  }

}
