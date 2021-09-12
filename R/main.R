rm(list = ls())
library(tidyverse)
library(rvest)
library(lubridate)
library(plotly)

source("R/functions/discover_links.R")
source("R/functions/download_data_from_url.R")
source("R/functions/download_msds_data.R")
source("R/functions/sort_data_into_subfolders.R")
source("R/functions/move_file_into_subfolder.R")
source("R/functions/discover_data_type.R")
source("R/functions/combine_files_to_dataframe.R")
source("R/functions/move_file.R")
source("R/functions/get_measures.R")
source("R/functions/get_data.R")
source("R/functions/plots/measure_comparative_plot.R")
source("R/functions/plots/data_comparative_plot.R")

# Download data from the NHSDigital url.
# As of Sept 2021, this function will download ~725MB of data
download_msds_data(
  check_for_new_data = TRUE, 
  force_redownload_all = FALSE
)

# Move the downloaded data into subfolders, based on file names (and therefore data contents)
sort_data_into_subfolders()

# There are 3 main data source files:  measures, data, and dq
# MEASURES #
#read measures data into a dataframe, including any background data cleaning
measures_dtf <- get_measures() # 401k rows

#quick plot of all providers data for a given measure
measure_comparative_plot(measures_dtf, "CQIMPreterm", "RX1")

# DATA #
data_dtf <- get_data() # 2.26M rows

#quick plot of all providers data for a given dimension
data_comparative_plot(data_dtf, "TotalBabies", "RX1")

# DQ #
  # Coming soon
