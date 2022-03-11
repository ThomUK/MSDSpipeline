#' Combine and tidy measures data files
#'
#' @param data_path Character string defining the path to the parent data folder
#' @param do_tidying Logical.  When FALSE, returns the joined but uncleaned dataset
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

msds_tidy_measures <- function(data_path = "data/msds_download", do_tidying = TRUE){

  path <- build_data_path(destination = data_path)

  result <- combine_files_to_dataframe("measures", path)

  if(!do_tidying) return(result) # skip the data cleaning (useful for debugging or demo of package purpose)

  message("Cleaning... Fixing data inconsistencies...")
  result <- result %>%
    fix_measures_mbrrace_group() %>%
    fix_measures_org_names()

  message("Cleaning... Fixing date formats...")
  suppressWarnings(
    result <- result %>%
      dplyr::mutate(
        Start_Date = dplyr::case_when(
          stringr::str_detect(RPStartDate, "/") ~ as.Date(RPStartDate, format = "%d/%m/%Y"), # rows likely came from the csv files
          TRUE ~ as.Date(as.numeric(RPStartDate), origin = "1899-12-30") # rows likely came from excel files (with numeric dates)
        ),
        End_Date = dplyr::case_when(
          stringr::str_detect(RPEndDate, "/") ~ as.Date(RPEndDate, format = "%d/%m/%Y"),
          TRUE ~ as.Date(as.numeric(RPEndDate), origin = "1899-12-30")
        )
      )
  )

  message("Cleaning... Finalising column data types...")
  result <- result %>%
    dplyr::mutate(
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
    dplyr::rename(
      Indicator_Family = IndicatorFamily
    )

    message("Cleaning... Pivoting result values...")
    result <- result %>%
    # pivot the Rate, Numerator, Denominator, Result, and Rate per Thousand columns out
    tidyr::pivot_wider(
      -c(Currency, Value),
      names_from = "Currency",
      values_from = "Value"
    )

    message("Cleaning... Cleaning rates and failure reasons...")
    result <- result %>%
    # create a specific column to hold failure reasons
    dplyr::mutate(
      Failure_Comment = dplyr::case_when(
        Rate == "Low DQ" ~ "Low DQ",
        Rate == "DNS" ~ "DNS",
        `Rate per Thousand` == "Low DQ" ~ "Low DQ",
        `Rate per Thousand` == "DNS" ~ "DNS",
        `Rate per Thousand` == "*" ~ "SMALL NUMBER",
      ),

      # replace the original failure reasons with NAs
      Rate = dplyr::case_when(
        Failure_Comment == "Low DQ" ~ NA_character_,
        Failure_Comment == "DNS" ~ NA_character_,
        TRUE ~ Rate
      ),
      `Rate per Thousand` = dplyr::case_when(
        Failure_Comment == "Low DQ" ~ NA_character_,
        Failure_Comment == "DNS" ~ NA_character_,
        Failure_Comment == "SMALL NUMBER" ~ NA_character_,
        TRUE ~ `Rate per Thousand`
      ),

      # assign appropriate types
      Failure_Comment = factor(Failure_Comment), # convert to factor
      Rate = as.numeric(Rate),
      `Rate per Thousand` = as.numeric(`Rate per Thousand`),
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
      Numerator,
      Denominator,
      Rate,
      `Rate per Thousand`,
      Result,
      Failure_Comment
    )

  message("Cleaning... Completed.")
  return(result)
}
