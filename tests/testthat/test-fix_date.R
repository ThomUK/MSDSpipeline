
test_that("excel numeric date as a string parses as expected", {

  expect_equal(
    fix_date("12345"),
    as.Date("1933-10-18")
  )

})

test_that("excel numeric date as a number parses as expected", {

  expect_equal(
    fix_date(12345),
    as.Date("1933-10-18")
  )

})

test_that("dmy date with forward-slashes parses as expected", {

  expect_equal(
    fix_date("30/1/2020"),
    as.Date("2020-01-30")
  )

})

test_that("a vector of different formats parses as expected", {

  expect_equal(
    fix_date(c("30/1/2020", "12345", 12345)),
    c(as.Date("2020-01-30"), as.Date("1933-10-18"), as.Date("1933-10-18"))
  )

})
