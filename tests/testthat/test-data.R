test_that("MBRRACE_groups_2018: dataset size is as expected", {

  expect_equal(
    nrow(MBRRACE_groups_2018),
    165
  )
  expect_equal(
    ncol(MBRRACE_groups_2018),
    5
  )

})

test_that("MBRRACE_groups_2018: Org_Codes appear only once", {

  o <- MBRRACE_groups_2018 %>%
    dplyr::filter(!is.na(Org_Code)) %>%
    unique()

  expect_equal(
    nrow(o),
    132 # the rest of the rows are NAs
  )

})

test_that("MBRRACE_groups_2018: Org_Names appear only once", {

  o <- MBRRACE_groups_2018 %>%
    dplyr::filter(!is.na(Org_Name)) %>%
    unique()

  expect_equal(
    nrow(o),
    nrow(MBRRACE_groups_2018)
  )

})

test_that("MBRRACE_groups_2018: Basic functionality works", {

  o <- MBRRACE_groups_2018 %>%
    dplyr::filter(Org_Code  == "RX1")

  expect_equal(
    o$Org_Name,
    "NOTTINGHAM UNIVERSITY HOSPITALS NHS TRUST"
  )

  expect_equal(
    o$MBRRACE_Group,
    1
  )

  expect_equal(
    o$MBRRACE_Group_Description,
    "Level 3 NICU & NS"
  )

})
