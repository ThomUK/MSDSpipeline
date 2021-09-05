rm(list = ls())
library(tidyverse)
library(rvest)

source("R/functions/discover_links.R")
source("R/functions/download_data_from_url.R")
source("R/functions/download_msds_data.R")
source("R/functions/sort_data_into_subfolders.R")
source("R/functions/move_file_into_subfolder.R")
source("R/functions/discover_data_type.R")
source("R/functions/move_file.R")

# Download data from the NHSDigital url.
# As of Sept 2021, this function will download ~725MB of data
download_msds_data(
  check_for_new_data = TRUE, 
  force_redownload_all = FALSE
)

# Move the downloaded data into subfolders, based on file names (and therefore data contents)
sort_data_into_subfolders()
