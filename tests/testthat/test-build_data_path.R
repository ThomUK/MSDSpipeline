test_that("destination is a character vector", {

  expect_error(
    build_data_path(destination = FALSE),
    "build_data_path: destination argument must be a character vector."
  )

})

test_that("a relative path is returned", {

  expect_equal(
    build_data_path("a/relative/path"),
    paste0(getwd(), "/a/relative/path")
  )

})

test_that("a drive-based absolute path can be returned", {

  expect_equal(
    build_data_path("C:/an/absolute/path"),
    "C:/an/absolute/path"
  )

})

test_that("a network-based absolute path can be returned", {

  expect_equal(
    build_data_path("\\\\an\\absolute\\path"),
    "//an/absolute/path"
  )

})
