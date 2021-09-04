rm(list = ls())
library(tidyverse)
library(rvest)

source("R/functions/discover_links.R")
source("R/functions/download_data_from_url.R")
source("R/functions/download_msds_data.R")

# Download data from the NHSDigital url.
# As of Sept 2021, this function will download ~725MB of data
download_msds_data(
  check_for_new_data = TRUE, 
  force_redownload_all = FALSE
)
