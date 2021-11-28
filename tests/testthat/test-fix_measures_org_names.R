
# set up the problem dataframe.
#datapasta::tribble_format(org_name_problem)

problem <- tibble::tribble(
  ~Org_Code,                                                  ~Org_Name,  ~n,
  "RHU", "PORTSMOUTH HOSPITALS UNIVERSITY NATIONAL HEALTH SERVICE TRUST", 4394L,
  "RHU",                                "PORTSMOUTH HOSPITALS NHS TRUST",  128L,
  "RXW",                     "SHREWSBURY AND TELFORD HOSPITAL NHS TRUST", 2196L,
  "RXW",                 "THE SHREWSBURY AND TELFORD HOSPITAL NHS TRUST", 2302L,
  "RCB",                   "YORK TEACHING HOSPITAL NHS FOUNDATION TRUST", 2941L,
  "RCB",  "YORK AND SCARBOROUGH TEACHING HOSPITALS NHS FOUNDATION TRUST", 1515L,
  "RYR",                 "WESTERN SUSSEX HOSPITALS NHS FOUNDATION TRUST", 2557L,
  "RYR",              "UNIVERSITY HOSPITALS SUSSEX NHS FOUNDATION TRUST", 1914L
)

test_that("the resulting dataframe has the correct number of rows", {

  o <- fix_measures_org_names(problem) %>%
    dplyr::distinct(Org_Name)

  expect_equal(
    nrow(o),
    4
  )

})

test_that("the problem rows no longer exist", {

  o <- fix_measures_org_names(problem)

  expect_equal(
    nrow(o %>% dplyr::filter(Org_Name == "PORTSMOUTH HOSPITALS NHS TRUST")),
    0
  )

  expect_equal(
    nrow(o %>% dplyr::filter(Org_Name == "THE SHREWSBURY AND TELFORD HOSPITAL NHS TRUST")),
    0
  )

  expect_equal(
    nrow(o %>% dplyr::filter(Org_Name == "YORK TEACHING HOSPITAL NHS FOUNDATION TRUST")),
    0
  )

  expect_equal(
    nrow(o %>% dplyr::filter(Org_Name == "WESTERN SUSSEX HOSPITALS NHS FOUNDATION TRUST")),
    0
  )

})

test_that("the rows have been renamed not removed", {

  o <- fix_measures_org_names(problem)

  expect_equal(
    o %>% dplyr::filter(Org_Name == "PORTSMOUTH HOSPITALS UNIVERSITY NATIONAL HEALTH SERVICE TRUST") %>% dplyr::pull(n),
    c(4394, 128)
  )

  expect_equal(
    o %>% dplyr::filter(Org_Name == "SHREWSBURY AND TELFORD HOSPITAL NHS TRUST") %>% dplyr::pull(n),
    c(2196, 2302)
  )

  expect_equal(
    o %>% dplyr::filter(Org_Name == "YORK AND SCARBOROUGH TEACHING HOSPITALS NHS FOUNDATION TRUST") %>% dplyr::pull(n),
    c(2941, 1515)
  )

  expect_equal(
    o %>% dplyr::filter(Org_Name == "UNIVERSITY HOSPITALS SUSSEX NHS FOUNDATION TRUST") %>% dplyr::pull(n),
    c(2557, 1914)
  )

})
