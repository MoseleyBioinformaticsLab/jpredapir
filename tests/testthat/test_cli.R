context("test cli")
source("constants.R")

# real tests

testthat::test_that("test jpredapir help message", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "--help")), 0)
})


testthat::test_that("test jpredapir version", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "--version")), 0)
})


testthat::test_that("test jpredapir check_rest_version", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "check_rest_version")), 0)
})


testthat::test_that("test jpredapir check_rest_version", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "check_rest_version --silent")), 0)
})


testthat::test_that("test jpredapir quota", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "quota --email=name@domain.com")), 0)
})


testthat::test_that("test jpredapir quota", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "quota --email=name@domain.com", "--silent")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=single --format=raw --seq=MQVWPIEGIKKFETLSYLPP")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=single --format=raw --file=../../inst/exampledata/single_raw.example")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=single --format=fasta --file=../../inst/exampledata/single_fasta.example")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=batch --format=fasta --email=name@domain.com --file=../../inst/exampledata/batch_fasta.example")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=msa --format=fasta --email=name@domain.com --file=../../inst/exampledata/msa_fasta.example")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=msa --format=msf --email=name@domain.com --file=../../inst/exampledata/msa_msf.example")), 0)
})


testthat::test_that("test jpredapir submit", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "submit --mode=msa --format=blc --email=name@domain.com --file=../../inst/exampledata/msa_blc.example")), 0)
})


testthat::test_that("test jpredapir status", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "status --jobid=jp_K46D05A")), 0)
})


testthat::test_that("test jpredapir status", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "status --jobid=jp_K46D05A --results=jpred_sspred/results")), 0)
})


testthat::test_that("test jpredapir status", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "status --jobid=jp_K46D05A --results=jpred_sspred/results --extract")), 0)
})


testthat::test_that("test jpredapir get_results", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "get_results --jobid=jp_K46D05A")), 0)
})


testthat::test_that("test jpredapir get_results", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "get_results --jobid=jp_K46D05A --results=jpred_sspred/results")), 0)
})


testthat::test_that("test jpredapir get_results", {
  testthat::skip_if(SKIP_REAL_JPREDAPI, "Skipping tests that hit the real JPred API server.")
  testthat::expect_equal(system(paste("Rscript", CLI_EXEC, "get_results --jobid=jp_K46D05A --results=jpred_sspred/results --extract")), 0)
})
