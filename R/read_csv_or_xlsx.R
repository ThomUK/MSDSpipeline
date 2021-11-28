#' Read from csv or xlsx file
#'
#' This function will accept both csv and xlsx file inputs, and will read them
#' with column types set to character
#'
#' @param file The path of the file to read
#'
#' @return A dataframe of the file content
#'
#' @noRd

read_csv_or_xlsx <- function(file){

  # get extension type of file
  extension <- tools::file_ext(file)

  if(extension == "csv"){

    readr::read_csv(file = file, col_types = readr::cols(.default = "c"))

  } else if(extension == "xlsx"){

    readxl::read_xlsx(path = file, col_types = "text")

  } else {

    stop("read_csv_or_xlsx: File must be .csv or .xlsx")

  }

}
