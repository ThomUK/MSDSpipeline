measure_comparative_plot <- function(dtf, measure_name, focus_org_code){
  
  if(ncol(dtf) != 10) stop("The data frame has the wrong number of columns.")
  if(!"Currency" %in% colnames(dtf)) stop("The 'Currency' column is missing from the data frame.")
  
  temp <- dtf %>% filter(
    Indicator == measure_name
    & Value != "Low DQ"
    & Value != "DNS"
  ) %>% 
    filter(Currency %in% c("Rate", "Rate per Thousand")) %>% 
    mutate(Value = as.numeric(Value)) %>% 
    filter(Org_Level == "Provider")
  
  p <- ggplot(temp, aes(x = RPStartDate, y = Value, group = Org_Code)) +
    geom_line(size = 0.2) + 
    geom_line(data = temp %>% filter(Org_Code == focus_org_code), col = "red", size = 1) +
    labs(
      title = paste0("Indicator - ", measure_name, " grouped by Org Code"),
      subtitle = paste0("Org code ", focus_org_code, " is highlighted")
    ) + 
    theme(
      legend.position = "none"
    )
  
  print(p)
#  ggplotly(p)
}