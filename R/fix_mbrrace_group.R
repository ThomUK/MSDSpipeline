#' Fixes a raw data naming problem
#'
#' @param dtf A dataframe
#'
#' @return The corrected dataframe
#'
#' @noRd

fix_mbrrace_group <- function(dtf){

  dtf <- dtf %>% dplyr::mutate(
      Org_Code = dplyr::case_when(
        Org_Code == "Group 3. 4000 or more" ~ "Group 3. 4,000 or more",
        Org_Code == "Group 4. 2000 - 3999" ~ "Group 4. 2,000 - 3,999",
        Org_Code == "Group 5. under 2000" ~ "Group 5. Under 2,000",
        TRUE ~ Org_Code
      )
    )

  n <- dtf %>% filter(toupper(Org_Level) == "MBRRACE GROUPING") %>% pull(Org_Code) %>% unique() %>% length()

  assertthat::assert_that(
    n == 6,
    msg = glue::glue("The expected number of MBRRACE groups is 6, but the actual is {n}")
  )

  return(dtf)

}
