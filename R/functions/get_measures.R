get_measures <- function(){
  combine_files_to_dataframe("measures") %>% 
    mutate(
      RPStartDate = dmy(RPStartDate),
      RPEndDate = dmy(RPEndDate)
    ) # convert date cols to date type
}