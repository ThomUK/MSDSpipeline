#' Fixes a raw data naming problem
#'
#' @param dtf A dataframe of measures data
#'
#' @return The corrected dataframe
#'
#' @noRd

fix_measures_org_names <- function(dtf){

    dtf %>% dplyr::mutate(
      Org_Name = dplyr::case_when(
        Org_Name == "PORTSMOUTH HOSPITALS NHS TRUST" ~ "PORTSMOUTH HOSPITALS UNIVERSITY NATIONAL HEALTH SERVICE TRUST",
        Org_Name == "THE SHREWSBURY AND TELFORD HOSPITAL NHS TRUST" ~ "SHREWSBURY AND TELFORD HOSPITAL NHS TRUST",
        Org_Name == "YORK TEACHING HOSPITAL NHS FOUNDATION TRUST" ~ "YORK AND SCARBOROUGH TEACHING HOSPITALS NHS FOUNDATION TRUST",
        Org_Name == "WESTERN SUSSEX HOSPITALS NHS FOUNDATION TRUST" ~ "UNIVERSITY HOSPITALS SUSSEX NHS FOUNDATION TRUST",
        TRUE ~ Org_Name
      )
    )

}
