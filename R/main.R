# rm(list = ls())
# library(tidyverse)
# library(rvest)
# library(lubridate)
# library(plotly)
#
# source("R/source/source_all_files.R")
#
# # Download data from the NHSDigital url.
# # As of Sept 2021, this function will download ~725MB of data
# download_msds_data(
#   check_for_new_data = TRUE,
#   force_redownload_all = FALSE
# )
#
# # Move the downloaded data into subfolders, based on file names (and therefore data contents)
# sort_data_into_subfolders()
#
# # There are 3 main types of raw data file:  "measures", "exp-data", and "exp-dq"
#
# ### 1. MEASURES ###
# # Read all measures files into a dataframe
# measures_dtf <- get_measures() # 401k rows
#
# # Quick plot of all providers data for a given measure, highlighting a single provider trust
# measure_comparative_plot(measures_dtf, "CQIMPreterm", "RX1")
#
#
# ### 2. EXP-DATA ###
# # Read all exp-data files into a dataframe
# data_dtf <- get_data() # 2.26M rows
#
# # Quick plot of all providers data for a given dimension, highlighting a single provider trust
# data_comparative_plot(data_dtf, "TotalBabies", "RX1")
#
#
# ### 3. EXP-DQ ###
# # Read all exp-dq files into a dataframe
# dq_dtf <- get_dq()
#
# # Quick summary plot of data quality, highlighting a single provider trust
# dq_comparative_plot(dq_dtf, "RX1")
