#' Combine and tidy data files
#'
#' @param data_path Character string defining the path to the parent data folder
#' @param do_tidying Logical.  When FALSE, returns the joined but uncleaned dataset
#'
#' @return A data frame of data
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' \dontrun{
#' # read data from the default directory path
#' msds_tidy_data()
#'
#' # read data from a different (relative) directory path
#' msds_tidy_data(data_path = "a/different/relative/directory")
#'
#' # read data from an absolute directory path, or network path
#' msds_tidy_data(data_path = "C:/your/hard/drive/msds_data")
#' }

msds_tidy_data <- function(data_path = "data/msds_download", do_tidying = TRUE){

  path <- build_data_path(destination = data_path)

  result <- combine_files_to_dataframe("exp-data", path)

  if(!do_tidying) return(result) # skip the data cleaning (useful for debugging or demo of package purpose)

  message("Cleaning... Combining columns...")
  result <- result %>%
    # 3 measure description columns can safely be dropped as their data appears in the "Measure" column
    dplyr::select(-c(Measure_Description, Measure_Desc, `Measure Description`)) %>%

    # standardise similar column names
    dplyr::mutate(
      Value = dplyr::case_when(
        !is.na(Final_value) ~ Final_value,
        TRUE ~ Value
      ),
      Final_Value = NULL, # remove the disused column

      Org_Level = dplyr::case_when(
        !is.na(`Org Level`) ~ `Org Level`,
        TRUE ~ Org_Level
      ),
      `Org Level` = NULL, # remove the disused column

      Org_Code = dplyr::case_when(
        !is.na(`Org Code`) ~ `Org Code`,
        TRUE ~ Org_Code
      ),
      `Org Code` = NULL, # remove the disused column

      Org_Name = dplyr::case_when(
        !is.na(`Org Name`) ~ `Org Name`,
        TRUE ~ Org_Name
      ),
      `Org Name` = NULL # remove the disused column
    )

  message("Cleaning... Parsing dates...")
  result <- result %>%
    # parse dates presented as both "YYYY-MM-DD" and "DD/MM/YYYY" as dates
    dplyr::mutate(

      # parse the two start date formats into two temp columns
      sd1 = as.Date(ReportingPeriodStartDate, format = "%d/%m/%Y"),
      sd2 = as.Date(ReportingPeriodStartDate, format = "%Y-%m-%d"),
      # combine then remove temp columns
      Start_Date = if_else(!is.na(sd1), sd1, sd2),
      sd1 = NULL,
      sd2 = NULL,

      # parse the two end date formats into two temp columns
      ed1 = as.Date(ReportingPeriodEndDate, format = "%d/%m/%Y"),
      ed2 = as.Date(ReportingPeriodEndDate, format = "%Y-%m-%d"),
      # combine then remove temp columns
      End_Date = if_else(!is.na(ed1), ed1, ed2),
      ed1 = NULL,
      ed2 = NULL
    )

  message("Cleaning... Parsing period column into dates...")
  result <- result %>%
    # standardise the date formatting in the "Period" column
    # inputs are of the format "Dec-18 and "December 2018"
    dplyr::mutate(Period = if_else(is.na(Period), Period, paste0("1-",Period))) %>% #add 1- to everything, to represent the 1st of the month
    dplyr::mutate(Period = stringr::str_replace_all(Period, "-", " ")) %>% #replace "-" in date with space
    dplyr::mutate(Period = as.Date(Period, tryFormats = c("%d %b %y", "%d %B %Y"))) %>% #make it a date type column

    # create reporting period start and end dates from the Period date
    dplyr::mutate(
      Start_Date = dplyr::case_when(
        !is.na(Start_Date) ~ Start_Date,
        TRUE ~ lubridate::floor_date(Period, unit = "month")
      ),
      End_Date = dplyr::case_when(
        !is.na(End_Date) ~ End_Date,
        TRUE ~ lubridate::ceiling_date(Period, unit = "month")
      )
    ) %>%
    dplyr::select(-Period) #remove unnecessary column

  message("Cleaning... Fix raw data category name inconsistencies...")
  result <- result %>%

    fix_mbrrace_group() %>%

    dplyr::mutate(
      Org_Level = dplyr::case_when(
        Org_Level %in% c("Provider", "Trust") ~ "Provider Trust", # consolidate and rename this category
        Org_Level %in% c("NHS England (Region)", "Region") ~ "NHS England Region", # consolidate and rename this category
        TRUE ~ Org_Level
      ),
      Org_Code = dplyr::case_when(
        Org_Level == "National" & Org_Code == "AllSubmitters" ~ "All",
        TRUE ~ Org_Code
      ),
      Org_Name = dplyr::case_when(
        Org_Level == "National" & Org_Code == "All" ~ "ALL SUBMITTERS",
        toupper(Org_Level) == "MBRRACE GROUPING" ~ Org_Code,
        TRUE ~ Org_Name
      ),
      Measure = dplyr::case_when(
        toupper(Dimension) == "APGARSCORE5TERMGROUP7" & Measure == "0-6" ~ "0 to 6",
        toupper(Dimension) == "APGARSCORE5TERMGROUP7" & Measure == "07-Oct" ~ "7 to 10",
        toupper(Dimension) == "APGARSCORE5TERMGROUP7" & Measure == "Missing Value/Value outside reporting parameters" ~ "Missing Value / Value outside reporting parameters",
        TRUE ~ Measure
      )
    )

  message("Cleaning... Finalising column data types...")
  # create factors
  result <- result %>%
    dplyr::mutate(
      Dimension = factor(toupper(Dimension)),
      Org_Level = factor(toupper(Org_Level)),
      Org_Code = factor(toupper(Org_Code)),
      Org_Name = factor(toupper(Org_Name)),
      Measure = factor(toupper(Measure)),
      Count_Of = factor(toupper(Count_Of)),
      Org_Geog_Code = factor(toupper(Org_Geog_Code)),
    )

  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>%
    dplyr::select(
      Source_WB,
      Start_Date,
      End_Date,
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
