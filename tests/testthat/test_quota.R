context("test quota")
source("constants.R")


testthat::test_that("test quota API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  quota_response <- jpredapir::quota(email = "name@domain.com")
  testthat::expect_equal(quota_response$status_code, 200)
})


testthat::test_that("test mock quota API call", {
  testthat::with_mock(
    quota = function(email) {return(list(status_code = 200))},
    quota_response <- quota(email = "name@domain.com"),
    testthat::expect_equal(quota_response$status_code, 200)
  )
})
