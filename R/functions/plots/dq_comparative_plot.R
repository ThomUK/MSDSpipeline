dq_comparative_plot <- function(dtf, focus_org_code){
  
  if(ncol(dtf) != 12) stop("The data frame has the wrong number of columns.")
  # check for a distinctive column name to loosely check the right info has been passed in
  if(!"Valid" %in% colnames(dtf)) stop("The 'Valid' column is missing from the data frame.")
  
  # calculate summary percentages by org code  
  summarised_data <- dtf %>% 
    group_by(Org_Code, RPStartDate) %>% 
    summarise(
      Valid = sum(Valid) / sum(Denominator),
      Default = sum(Default) / sum(Denominator),
      Invalid = sum(Invalid) / sum(Denominator),
      Missing = sum(Missing) / sum(Denominator),
    ) %>%
    mutate(
      Check_Sum = Valid + Default + Invalid + Missing
    ) %>% 
    pivot_longer(c(Valid, Default, Invalid, Missing), names_to = "Submission", values_to = "value")
  
  # make the plot
  ggplot(summarised_data, aes(x = RPStartDate, y = value, group = Org_Code) ) +
    scale_y_continuous(labels = scales::percent) +
    facet_wrap(vars(Submission), scales = "free_y") +
    geom_line() + 
    geom_line(summarised_data %>% filter(Org_Code == focus_org_code), mapping = aes(group = Submission), colour = "red", size = 1) + 
    labs(
      title = paste0("Data quality status, grouped by Org Code"),
      subtitle = paste0("Org code ", focus_org_code, " is highlighted in red")
    )
}