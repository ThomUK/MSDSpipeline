#' Combine and tidy data files
#'
#' @param data_path Character string defining the path to the parent data folder
#' @param relative_path Logical (default TRUE). Whether the data_path will be treated as relative to working directory
#'
#' @return A data frame of data
#'
#' @importFrom magrittr %>%
#' @export

msds_tidy_data <- function(data_path = "data/msds_download", relative_path = TRUE){

  path <- build_data_path(destination = data_path, relative_path = relative_path)

  result <- combine_files_to_dataframe("exp-data", path)

  message("Cleaning... Combining columns...")
  result <- result %>%
    # 3 measure description columns can safely be dropped as their data appears in the "Measure" column
    dplyr::select(-c(Measure_Description, Measure_Desc, `Measure Description`)) %>%

    # combine similar column names together under standard name
    tidyr::unite(Value, c(Value, Final_value), na.rm = TRUE) %>%
    tidyr::unite(Org_Level, c(Org_Level, `Org Level`), na.rm = TRUE) %>%
    tidyr::unite(Org_Code, c(Org_Code, `Org Code`), na.rm = TRUE) %>%
    tidyr::unite(Org_Name, c(Org_Name, `Org Name`), na.rm = TRUE)

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

    # standardise the date formatting in the "Period" column
    # inputs are of the format "Dec-18 and "December 2018"
    dplyr::mutate(Period = ifelse(is.na(Period), Period, paste0("1-",Period))) %>% #add 1- to everything, to represent the 1st of the month
    dplyr::mutate(Period = stringr::str_replace_all(Period, "-", " ")) %>% #replace "-" in date with space
    dplyr::mutate(Period = lubridate::dmy(Period)) %>% #make it a date type column

    # create reporting period start and end dates from the Period date
    dplyr::mutate(
      ReportingPeriodStartDate = dplyr::case_when(
        !is.na(ReportingPeriodStartDate) ~ ReportingPeriodStartDate,
        TRUE ~ lubridate::floor_date(Period, unit = "month")
      ),
      ReportingPeriodEndDate = dplyr::case_when(
        !is.na(ReportingPeriodEndDate) ~ ReportingPeriodEndDate,
        TRUE ~ lubridate::ceiling_date(Period, unit = "month")
      )
    ) %>%
    dplyr::select(-Period) %>%  #remove unnecessary column

    # standardise column names
    dplyr::rename(
      RPStartDate = ReportingPeriodStartDate,
      RPEndDate = ReportingPeriodEndDate
    )

  message("Cleaning... Finalising column data types...")
  # create factors
  result <- result %>%
    dplyr::mutate(
      Dimension = forcats::as_factor(Dimension),
      Org_Level = forcats::as_factor(Org_Level),
      Org_Code = forcats::as_factor(Org_Code),
      Org_Name = forcats::as_factor(Org_Name),
      Measure = forcats::as_factor(Measure),
      Count_Of = forcats::as_factor(Count_Of),
      Org_Geog_Code = forcats::as_factor(Org_Geog_Code),
    )

  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>%
    dplyr::select(
      source_wb,
      RPStartDate,
      RPEndDate,
      Org_Level,
      Org_Geog_Code,
      Org_Code,
      Org_Name,
      Dimension,
      Measure,
      Count_Of,
      Value
    )

  message("Cleaning... Completed.")
  return(result)
}
