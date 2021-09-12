get_measures <- function(){
  result <- combine_files_to_dataframe("measures")
  
  message("Cleaning... Finalising column data types...")
  # create factors and date columns
  result <- result %>% 
    mutate(
      RPStartDate = dmy(RPStartDate),
      RPEndDate = dmy(RPEndDate),
      Org_Level = as_factor(Org_Level),
      Org_Code = as_factor(Org_Code),
      Org_Name = as_factor(Org_Name),
      IndicatorFamily = as_factor(IndicatorFamily),
      Indicator = as_factor(Indicator),
      Currency = as_factor(Currency)
    )
  
  message("Cleaning... Finalising column order...")
  # order the columns
  result <- result %>% 
    select(
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