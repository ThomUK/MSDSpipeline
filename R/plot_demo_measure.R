#' Make a comparative plot using measures data
#' as an example of the data available
#'
#' @param dtf A dataframe containing measures data
#' @param measure_name A character vector of the measure name to plot
#' @param focus_org_code A character vector of a single org code to highlight in the plot
#'
#' @return NULL
#'
#' @import ggplot2
#'
#' @export
#'
plot_demo_measure <- function(dtf, measure_name, focus_org_code){

  if(ncol(dtf) != 10) stop("The data frame has the wrong number of columns.")
  if(!"Currency" %in% colnames(dtf)) stop("The 'Currency' column is missing from the data frame.")

  temp <- dtf %>% dplyr::filter(
    Indicator == measure_name
    & Value != "Low DQ"
    & Value != "DNS"
  ) %>%
    dplyr::filter(Currency %in% c("Rate", "Rate per Thousand")) %>%
    dplyr::mutate(Value = as.numeric(Value)) %>%
    dplyr::filter(Org_Level == "Provider")

  p <- ggplot(temp, aes(x = RPStartDate, y = Value, group = Org_Code)) +
    geom_line(size = 0.2, alpha = 0.3) +
    geom_line(data = temp %>% dplyr::filter(Org_Code == focus_org_code), col = "red", size = 1) +
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
