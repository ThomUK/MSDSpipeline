fix_date <- function(date){

  result<-purrr::map(
    .x = date,
    .f = ~
      if(stringr::str_detect(.x, "/")){

        lubridate::dmy(.x)

      } else {

        as.Date(as.numeric(.x), origin = "1899-12-30")

      }
    ) %>%
#    purrr::reduce(c) # this is a fancy trick I found to preserve the dates. (unlist() turns the vector back to numeric).
    unlist() %>%
#    lubridate::as_date()
    as.Date(origin = "1970-01-01")

  return(result)
}
