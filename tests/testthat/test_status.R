context("test status")
source("constants.R")

# real tests

testthat::test_that("test status API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode="single", user_format="raw", seq="MQVWPIEGIKKFETLSYLPP")
  result_url <- httr::headers(submit_response)$location
  job_id <- stringr::str_match(string = result_url, pattern = "(jp_.*)$")[2]
  status_response <- jpredapir::status(job_id = job_id, results_dir_path = NULL, extract = FALSE, silent = FALSE,  host = HOST, jpred4 = JPRED4)
  
  testthat::expect_equal(status_response$status_code, 200)
})


testthat::test_that("test status API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode="single", user_format="raw", seq="MQVWPIEGIKKFETLSYLPP")
  result_url <- httr::headers(submit_response)$location
  job_id <- stringr::str_match(string = result_url, pattern = "(jp_.*)$")[2]
  status_response <- jpredapir::status(job_id = job_id, results_dir_path = "jpred_results", extract = FALSE, silent = FALSE, host = HOST, jpred4 = JPRED4)
  
  testthat::expect_equal(status_response$status_code, 200)
})


testthat::test_that("test status API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode="single", user_format="raw", seq="MQVWPIEGIKKFETLSYLPP")
  result_url <- httr::headers(submit_response)$location
  job_id <- stringr::str_match(string = result_url, pattern = "(jp_.*)$")[2]
  status_response <- jpredapir::status(job_id = job_id, results_dir_path = "jpred_results", extract = TRUE, silent = FALSE, host = HOST, jpred4 = JPRED4)
  
  testthat::expect_equal(status_response$status_code, 200)
})


# mock tests

testthat::test_that("test mock status API call", {
  testthat::with_mock(
    
    status = function(job_id, results_dir_path, extract, silent, host, jpred4) {return(list(success = TRUE, status_code = 200))},
    status_response <- status(job_id = "jp_mock", results_dir_path = NULL, extract = FALSE, silent = FALSE, host = HOST, jpred4 = JPRED4),
    
    testthat::expect_equal(status_response$status_code, 200))
})


testthat::test_that("test mock status API call", {
  testthat::with_mock(
    
    status = function(job_id, results_dir_path, extract, silent, host, jpred4) {return(list(success = TRUE, status_code = 200))},
    status_response <- status(job_id = "jp_mock", results_dir_path = "jpred_results", extract = FALSE, silent = FALSE, host = HOST, jpred4 = JPRED4),
    
    testthat::expect_equal(status_response$status_code, 200))
})


testthat::test_that("test mock status API call", {
  testthat::with_mock(
    
    status = function(job_id, results_dir_path, extract, silent, host, jpred4) {return(list(success = TRUE, status_code = 200))},
    status_response <- status(job_id = "jp_mock", results_dir_path = "jpred_results", extract = TRUE, silent = FALSE, host = HOST, jpred4 = JPRED4),
    
    testthat::expect_equal(status_response$status_code, 200))
})
