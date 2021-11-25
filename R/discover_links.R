#' Discover the links (a tags) at a given web page URL
#'
#' @param page_url A character string for the web page URL
#'
#' @return A dataframe of links and page URLs
#'
#' @noRd
#'
discover_links <- function(page_url){

  #read the page
  html <- read_html(page_url)

  #read the URLs
  url_ <- html %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  # Extract the link text
  link_ <- html %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()

  return(tibble(link = link_, url = url_))

}
