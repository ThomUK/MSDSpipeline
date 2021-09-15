get_dq <- function(){
  result <- combine_files_to_dataframe("exp-dq")
  
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
    
    # standardise column names
    rename(
      RPStartDate = ReportingPeriodStartDate,
      RPEndDate = ReportingPeriodEndDate
    )
  
  message("Cleaning... Finalising column data types...")
  # create factors & numeric columns
  result <- result %>% 
    mutate(
      Org_Code = as_factor(Org_Code),
      DataTable = as_factor(DataTable),
      UID = as_factor(UID),
      DataItem = as_factor(DataItem),
      Valid = as.numeric(Valid),
      Default = as.numeric(Default),
      Invalid = as.numeric(Invalid),
      Missing = as.numeric(Missing),
      Denominator = as.numeric(Denominator)
    )
  
  message("Cleaning... Completed.")
  return(result)
}
