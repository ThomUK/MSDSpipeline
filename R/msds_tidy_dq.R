#' Combine and tidy data quality data
#'
#' @param data_path Character string defining the path to the parent data folder
#' @param relative_path Logical (default TRUE). Whether the data_path will be treated as relative to working directory
#'
#' @return A dataframe of data quality data
#'
#' @importFrom magrittr %>%
#' @export

msds_tidy_dq <- function(data_path = "data/msds_download", relative_path = TRUE){

  path <- build_data_path(destination = data_path, relative_path = relative_path)

  result <- combine_files_to_dataframe("exp-dq", path)

  message("Cleaning... Parsing dates...")
  result <- result %>%
    # parse dates presented as both "YYYY-MM-DD" and "DD/MM/YYYY" as dates
    dplyr::mutate(
      ReportingPeriodStartDate = dplyr::case_when(
        !is.na(lubridate::as_date(ReportingPeriodStartDate, format = "%d/%m/%Y")) ~ lubridate::as_date(ReportingPeriodStartDate, format = "%d/%m/%Y"), #if this format works, use it
        !is.na(lubridate::as_date(ReportingPeriodStartDate, format = "%Y-%m-%d")) ~ lubridate::as_date(ReportingPeriodStartDate, format = "%Y-%m-%d") #if this format works, use it
      ),
      ReportingPeriodEndDate = dplyr::case_when(
        !is.na(lubridate::as_date(ReportingPeriodEndDate, format = "%d/%m/%Y")) ~ lubridate::as_date(ReportingPeriodEndDate, format = "%d/%m/%Y"), #if this format works, use it
        !is.na(lubridate::as_date(ReportingPeriodEndDate, format = "%Y-%m-%d")) ~ lubridate::as_date(ReportingPeriodEndDate, format = "%Y-%m-%d") #if this format works, use it
      )
    ) %>%

    # standardise column names
    dplyr::rename(
      RPStartDate = ReportingPeriodStartDate,
      RPEndDate = ReportingPeriodEndDate
    )

  message("Cleaning... Finalising column data types...")
  # create factors & numeric columns
  result <- result %>%
    dplyr::mutate(
      Org_Code = forcats::as_factor(Org_Code),
      DataTable = forcats::as_factor(DataTable),
      UID = forcats::as_factor(UID),
      DataItem = forcats::as_factor(DataItem),
      Valid = as.numeric(Valid),
      Default = as.numeric(Default),
      Invalid = as.numeric(Invalid),
      Missing = as.numeric(Missing),
      Denominator = as.numeric(Denominator)
    )

  message("Cleaning... Completed.")
  return(result)
}
