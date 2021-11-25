get_data <- function(){
  result <- combine_files_to_dataframe("exp-data")
  
  message("Cleaning... Combining columns...")
  result <- result %>% 
    # 3 measure description columns can safely be dropped as their data appears in the "Measure" column
    select(-c(Measure_Description, Measure_Desc, `Measure Description`)) %>% 
    
    # combine similar column names together under standard name
    unite(Value, c(Value, Final_value), na.rm = TRUE) %>% 
    unite(Org_Level, c(Org_Level, `Org Level`), na.rm = TRUE) %>% 
    unite(Org_Code, c(Org_Code, `Org Code`), na.rm = TRUE) %>% 
    unite(Org_Name, c(Org_Name, `Org Name`), na.rm = TRUE)
  
  message("Cleaning... Parsing dates...")
  result <- result %>% 
    # parse dates presented as both "YYYY-MM-DD" and "DD/MM/YYYY" as dates
    mutate(
      ReportingPeriodStartDate = case_when(
        !is.na(as_date(ReportingPeriodStartDate, format = "%d/%m/%Y")) ~ as_date(ReportingPeriodStartDate, format = "%d/%m/%Y"), #if this format works, use it
        !is.na(as_date(ReportingPeriodStartDate, format = "%Y-%m-%d")) ~ as_date(ReportingPeriodStartDate, format = "%Y-%m-%d") #if this format works, use it
      ),
      ReportingPeriodEndDate = case_when(
        !is.na(as_date(ReportingPeriodEndDate, format = "%d/%m/%Y")) ~ as_date(ReportingPeriodEndDate, format = "%d/%m/%Y"), #if this format works, use it
        !is.na(as_date(ReportingPeriodEndDate, format = "%Y-%m-%d")) ~ as_date(ReportingPeriodEndDate, format = "%Y-%m-%d") #if this format works, use it
      )
    ) %>%
    
    # standardise the date formatting in the "Period" column
    # inputs are of the format "Dec-18 and "December 2018"
    mutate(Period = ifelse(is.na(Period), Period, paste0("1-",Period))) %>% #add 1- to everything, to represent the 1st of the month
    mutate(Period = str_replace_all(Period, "-", " ")) %>% #replace "-" in date with space
    mutate(Period = dmy(Period)) %>% #make it a date type column
    
    # create reporting period start and end dates from the Period date
    mutate(
      ReportingPeriodStartDate = case_when(
        !is.na(ReportingPeriodStartDate) ~ ReportingPeriodStartDate,
        TRUE ~ floor_date(Period, unit = "month")
      ),
      ReportingPeriodEndDate = case_when(
        !is.na(ReportingPeriodEndDate) ~ ReportingPeriodEndDate,
        TRUE ~ ceiling_date(Period, unit = "month")
      )
    ) %>%
    select(-Period) %>%  #remove unnecessary column
    
    # standardise column names
    rename(
      RPStartDate = ReportingPeriodStartDate,
      RPEndDate = ReportingPeriodEndDate
    )
  
  message("Cleaning... Finalising column data types...")
  # create factors
  result <- result %>% 
    mutate(
      Dimension = as_factor(Dimension),
      Org_Level = as_factor(Org_Level),
      Org_Code = as_factor(Org_Code),
      Org_Name = as_factor(Org_Name),
      Measure = as_factor(Measure),
      Count_Of = as_factor(Count_Of),
      Org_Geog_Code = as_factor(Org_Geog_Code),
    )
  
  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>% 
    select(
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