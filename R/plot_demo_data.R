#' Make a comparative plot using main data
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
plot_demo_data <- function(dtf, measure_name, focus_org_code){

  if(ncol(dtf) != 11) stop("The data frame has the wrong number of columns.")
  # check for a distinctive column name to loosely check the right info has been passed in
  if(!"Count_Of" %in% colnames(dtf)) stop("The 'Count_Of' column is missing from the data frame.")

  # find the earliest and latest dates in the full dataset
  start <- dtf %>% dplyr::filter(Dimension == measure_name) %>% dplyr::pull(Start_Date) %>% min()
  end <- dtf %>% dplyr::filter(Dimension == measure_name) %>% dplyr::pull(Start_Date) %>% max()

  all_data <- dtf %>%
    dplyr::filter(Dimension == measure_name) %>%
    dplyr::mutate(Value = as.numeric(Value)) %>%
    dplyr::filter(Org_Level == "Provider") %>%

    # group by the org code and add missing dates in, to break the line plots at missing data
    dplyr::group_by(Org_Code) %>%
    tidyr::complete(Start_Date = seq.Date(start, end, by="month")) %>%
    dplyr::ungroup()


  org_code_data <- all_data %>%
    dplyr::filter(Org_Code == focus_org_code)

  p <- ggplot(all_data, aes(x = Start_Date, y = Value, group = Org_Code)) +
    geom_line(size = 0.2, alpha = 0.3) +
    geom_line(data = org_code_data, col = "red", size = 1) +
    labs(
      title = paste0("Dimension - ", measure_name, " grouped by Org Code"),
      subtitle = paste0("Org code ", focus_org_code, " is highlighted")
    ) +
    theme(
      legend.position = "none"
    )

  print(p)
#  ggplotly(p)
}
