
# set up the problem dataframe.  The last 3 rows should not be there.
problem <- tibble::tribble(
  ~Org_Code,                    ~n,
  "Group 1. Level 3 NICU & NS", 1515L,
  "Group 2. Level 3 NICU",      1536L,
  "Group 3. 4,000 or more",     1572L,
  "Group 4. 2,000 - 3,999",     1548L,
  "Group 5. Under 2,000",       1521L,
  "Group 6. Unknown",           1095L,
  "Group 3. 4000 or more",      18L,
  "Group 4. 2000 - 3999",       18L,
  "Group 5. under 2000",        18L
)

test_that("the resulting dataframe has the correct number of rows", {

  o <- fix_measures_mbrrace_group(problem) %>%
    dplyr::distinct(Org_Code)

  expect_equal(
    nrow(o),
    6
  )

})

test_that("the problem rows no longer exist", {

  o <- fix_measures_mbrrace_group(problem)

  expect_equal(
    nrow(o$Org_Code == "Group 3. 4000 or more"),
    NULL
  )

  expect_equal(
    nrow(o$Org_Code == "Group 4. 2000 - 3999"),
    NULL
  )

  expect_equal(
    nrow(o$Org_Code == "Group 5. under 2000"),
    NULL
  )

})

test_that("the rows have been renamed", {

  o <- fix_measures_mbrrace_group(problem)

  expect_equal(
    o %>% dplyr::filter(Org_Code == "Group 3. 4,000 or more") %>% dplyr::pull(n),
    c(1572, 18)
  )

  expect_equal(
    o %>% dplyr::filter(Org_Code == "Group 4. 2,000 - 3,999") %>% dplyr::pull(n),
    c(1548, 18)
  )

  expect_equal(
    o %>% dplyr::filter(Org_Code == "Group 5. Under 2,000") %>% dplyr::pull(n),
    c(1521, 18)
  )

})
