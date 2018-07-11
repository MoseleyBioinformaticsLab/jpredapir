context("test check_rest_version")
source("constants.R")


testthat::test_that("test check_rest_version API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  version <- jpredapir::check_rest_version()
  testthat::expect_equal(version, "v.1.5")
})


testthat::test_that("test mock check_rest_version API call", {
  testthat::with_mock(
    check_rest_version = function() {return("v.1.5")},
    testthat::expect_equal(check_rest_version(), "v.1.5")
  )
})
