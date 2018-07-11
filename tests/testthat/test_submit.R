context("test submit")
source("constants.R")

# real tests

testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "single", user_format = "raw", file = NULL, seq = "MQVWPIEGIKKFETLSYLPP", 
                                       skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  submit_response <- jpredapir::submit(mode = "single", user_format = "raw", file = file.path(EXAMPLE_DATA_DIR, "single_raw.example"),
                                seq = NULL, skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "single", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "single_fasta.example"),
                                       seq = NULL, skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "batch", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "batch_fasta.example"),
                                       seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "msa", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "msa_fasta.example"),
                                       seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "msa", user_format = "msf", file = file.path(EXAMPLE_DATA_DIR, "msa_msf.example"),
                                       seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})


testthat::test_that("test submit API call", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  
  submit_response <- jpredapir::submit(mode = "msa", user_format = "blc", file = file.path(EXAMPLE_DATA_DIR, "msa_blc.example"),
                                       seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST)
  response_text <- tolower(httr::content(submit_response, "text"))
  success <- grepl(pattern = "created jpred job", response_text) || grepl(pattern = "you have successfully submitted", response_text)
  
  testthat::expect_equal(submit_response$status_code, 202)
  testthat::expect_equal(success, TRUE)
})

# mock tests

testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "single", user_format = "raw", file = NULL, seq = "MQVWPIEGIKKFETLSYLPP",
                              skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST),

    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "single", user_format = "raw", file = file.path(EXAMPLE_DATA_DIR, "single_raw.example"),
                              seq = NULL, skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "single", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "single_fasta.example"),
                              seq = NULL, skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "batch", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "batch_fasta.example"),
                              seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "msa", user_format = "fasta", file = file.path(EXAMPLE_DATA_DIR, "msa_fasta.example"),
                              seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "msa", user_format = "msf", file = file.path(EXAMPLE_DATA_DIR, "msa_msf.example"),
                              seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})


testthat::test_that("test mock submit API call", {
  testthat::with_mock(
    
    submit = function(mode, user_format, file, seq, skipPDB, email, name, silent, host) {return(list(success = TRUE, status_code = 202))},
    submit_response <- submit(mode = "msa", user_format = "blc", file = file.path(EXAMPLE_DATA_DIR, "msa_blc.example"), 
                              seq = NULL, skipPDB = TRUE, email = "name@domain.com", name = NULL, silent = FALSE, host = HOST),
    
    testthat::expect_equal(submit_response$status_code, 202),
    testthat::expect_equal(submit_response$success, TRUE))
})
