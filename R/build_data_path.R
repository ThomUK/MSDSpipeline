build_data_path <- function(destination){

  assertthat::assert_that(
    inherits(destination, "character"),
    msg = "build_data_path: destination argument must be a character vector."
  )

  R.utils::getAbsolutePath(destination)

}
