context("test-jpred_parameters")

example_file_loc <- file.path(rprojroot::find_root("DESCRIPTION"), "inst", "exampledata")

test_that("batch fasta works", {
  out_param <- create_jpred_query(mode="batch", user_format="fasta", file = file.path(example_file_loc, "batch_fasta.example"), email="name@domain.com")
  expect_known_output(out_param, file = "fasta_batch", print = TRUE)
})
