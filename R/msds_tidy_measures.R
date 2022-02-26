#' Combine and tidy measures data files
#'
#' @param data_path Character string defining the path to the parent data folder
#'
#' @return A dataframe of measures data
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' \dontrun{
#' # read data from the default directory path
#' msds_tidy_measures()
#'
#' # read data from a different (relative) directory path
#' msds_tidy_measures(data_path = "a/different/relative/directory")
#'
#' # read data from an absolute directory path, or network path
#' msds_tidy_measures(data_path = "C:/your/hard/drive/msds_data")
#' }

msds_tidy_measures <- function(data_path = "data/msds_download"){

  path <- build_data_path(destination = data_path)

  result <- combine_files_to_dataframe("measures", path)

  message("Cleaning... Fixing data inconsistencies...")
  result <- result %>%
    fix_measures_mbrrace_group() %>%
    fix_measures_org_names()

  message("Cleaning... Finalising column data types...")
  # create factors and date columns
  result <- result %>%
    dplyr::mutate(
      Start_Date = dplyr::case_when(
        stringr::str_detect(RPStartDate, "/") ~ as.Date(RPStartDate, format = "%d/%m/%Y"), # rows likely came from the csv files
        TRUE ~ as.Date(RPStartDate, origin = "1899-12-30") # rows likely came from excel files (with numeric dates)
      ),
      End_Date = dplyr::case_when(
        stringr::str_detect(RPEndDate, "/") ~ as.Date(RPEndDate, format = "%d/%m/%Y"),
        TRUE ~ as.Date(RPEndDate, origin = "1899-12-30")
      ),
      Org_Level = dplyr::case_when(
        Org_Level %in% c("Mbrrace", "MBRRACE Grouping") ~ "MBRRACE Grouping", # consolidate two category names
        Org_Level == "Provider" ~ "Provider Trust", # rename this category
        Org_Level %in% c("NHS England (Region)", "Region") ~ "NHS England Region", # consolidate and rename this category
        TRUE ~ Org_Level
      ),
      Org_Level = forcats::as_factor(Org_Level),
      Org_Code = forcats::as_factor(Org_Code),
      Org_Name = forcats::as_factor(Org_Name),
      IndicatorFamily = forcats::as_factor(IndicatorFamily),
      Indicator = forcats::as_factor(Indicator),
      Currency = forcats::as_factor(Currency)
    ) %>%
    rename(
      Indicator_Family = IndicatorFamily
    )

  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>%
    dplyr::select(
      Source_WB,
      Start_Date,
      End_Date,
      Org_Level,
      Org_Code,
      Org_Name,
      Indicator_Family,
      Indicator,
      Currency,
      Value
    )

  message("Cleaning... Completed.")
  return(result)
}
