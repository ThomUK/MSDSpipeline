test_that("destination is a character vector", {

  expect_error(
    build_data_path(destination = FALSE, relative_path = TRUE),
    "build_data_path: destination argument must be a character vector."
  )

})

test_that("destination is a character vector", {

  expect_error(
    build_data_path(destination = "a/path", relative_path = 1),
    "build_data_path: relative_path argument must be logical."
  )

})

test_that("a relative path is returned", {

  expect_equal(
    build_data_path("a/relative/path", relative_path = TRUE),
    paste0(getwd(), "/a/relative/path")
  )

})

test_that("an absolute path can be returned", {

  expect_equal(
    build_data_path("C:/an/absolute/path", relative_path = FALSE),
    "C:/an/absolute/path"
  )

})
