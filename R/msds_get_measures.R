#' Get Measures
#'
#' @param data_path Character string defining the path to the parent data folder
#'
#' @return A dataframe of measures data
#'
#' @importFrom magrittr %>%
#' @export

msds_get_measures <- function(data_path = "data/msds_download"){
  result <- combine_files_to_dataframe("measures", data_path)

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
