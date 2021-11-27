#' Combine and tidy measures data files
#'
#' @param data_path Character string defining the path to the parent data folder
#' @param relative_path Logical (default TRUE). Whether the data_path will be treated as relative to working directory
#'
#' @return A dataframe of measures data
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' # read data from the default directory path
#' msds_tidy_measures()
#'
#' # read data from a different (relative) directory path
#' msds_tidy_measures(data_path = "a/different/relative/directory")
#'
#' # read data from an absolute directory path, or network path
#' msds_tidy_measures(data_path = "C:/your/hard/drive/msds_data", relative_path = FALSE)


msds_tidy_measures <- function(data_path = "data/msds_download", relative_path = TRUE){

  path <- build_data_path(destination = data_path, relative_path = relative_path)

  result <- combine_files_to_dataframe("measures", path)

  message("Cleaning... Finalising column data types...")
  # create factors and date columns
  result <- result %>%
    dplyr::mutate(
      RPStartDate = lubridate::dmy(RPStartDate),
      RPEndDate = lubridate::dmy(RPEndDate),
      Org_Level = forcats::as_factor(Org_Level),
      Org_Code = forcats::as_factor(Org_Code),
      Org_Name = forcats::as_factor(Org_Name),
      IndicatorFamily = forcats::as_factor(IndicatorFamily),
      Indicator = forcats::as_factor(Indicator),
      Currency = forcats::as_factor(Currency)
    )

  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>%
    dplyr::select(
      source_wb,
      RPStartDate,
      RPEndDate,
      Org_Level,
      Org_Code,
      Org_Name,
      IndicatorFamily,
      Indicator,
      Currency,
      Value
    )

  message("Cleaning... Completed.")
  return(result)
}
