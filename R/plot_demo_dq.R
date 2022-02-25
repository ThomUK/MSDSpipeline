#' Make a comparative plot using data quality data
#' as an example of the data available
#'
#' @param dtf A dataframe containing measures data
#' @param focus_org_code A character vector of a single org code to highlight in the plot
#'
#' @return NULL
#'
#' @import ggplot2
#'
#' @export

plot_demo_dq <- function(dtf, focus_org_code){

  if(ncol(dtf) != 12) stop("The data frame has the wrong number of columns.")
  # check for a distinctive column name to loosely check the right info has been passed in
  if(!"Valid" %in% colnames(dtf)) stop("The 'Valid' column is missing from the data frame.")

  # calculate summary percentages by org code
  summarised_data <- dtf %>%
    dplyr::group_by(Org_Code, Start_Date) %>%
    dplyr::summarise(
      Valid = sum(Valid) / sum(Denominator),
      Default = sum(Default) / sum(Denominator),
      Invalid = sum(Invalid) / sum(Denominator),
      Missing = sum(Missing) / sum(Denominator),
    ) %>%
    dplyr::mutate(
      Check_Sum = Valid + Default + Invalid + Missing
    ) %>%
    tidyr::pivot_longer(c(Valid, Default, Invalid, Missing), names_to = "Submission", values_to = "value")

  # make the plot
  ggplot(summarised_data, aes(x = Start_Date, y = value, group = Org_Code) ) +
    scale_y_continuous(labels = scales::percent) +
    facet_wrap(vars(Submission), scales = "free_y") +
    geom_line(size = 0.2, alpha = 0.3) +
    geom_line(summarised_data %>% dplyr::filter(Org_Code == focus_org_code), mapping = aes(group = Submission), colour = "red", size = 1) +
    labs(
      title = paste0("Data quality status, grouped by Org Code"),
      subtitle = paste0("Org code ", focus_org_code, " is highlighted in red")
    )
}
