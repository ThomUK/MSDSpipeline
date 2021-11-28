## code to prepare `MBRRACE_groups_2018` dataset

MBRRACE_groups_2018 <- readr::read_csv("data-raw/MBRRACE_groups_2018.csv")

usethis::use_data(MBRRACE_groups_2018, overwrite = TRUE)
