#' MBRRACE-UK Trust Groupings.
#'
#' The MBRRACE trust groupings based on tables published in the
#' "MBRRACE-UK Perinatal Mortality Surveillance Report for births in 2018",
#' with the addition of Org_Codes.
#' The dataset is not identical to that in the published report because:
#' 1. Some trust names were altered to match official names from
#' NHS Organisation Data Service (ORD).
#' 2. Org_Codes have been added by joining on the corrected NHS trust names.
#'
#' @format A data frame with 165 rows and 5 variables:
#' \describe{
#'   \item{MBRRACE_Group}{The group assigned in the 2018 MBRRACE report}
#'   \item{MBRRACE_Group_Description}{A text description of the MBRRACE group}
#'   \item{Country}{Country of the NHS Trust}
#'   \item{Org_Code}{Organisation Code of the NHS Trust}
#'   \item{Org_Name}{Name of the MBRRACE group}
#' }
#'
#' @source \url{https://www.npeu.ox.ac.uk/mbrrace-uk/reports}
#' @source \url{https://www.npeu.ox.ac.uk/mbrrace-uk/reports/perinatal-mortality-surveillance}
"MBRRACE_groups_2018"
