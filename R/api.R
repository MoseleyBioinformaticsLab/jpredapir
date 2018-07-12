#!/usr/bin/env Rscript

#' Check version of JPred REST interface.
#' 
#' Check version of JPred REST API.
#'
#' @param host JPred host address.
#' @param suffix Host address suffix.
#' @param silent Should the work be done silently? (default = FALSE)
#'
#' @return Version of JPred REST API.
#' 
#' @export
#' 
#' @importFrom httr GET content
#' @importFrom stringr str_match
#' 
#' @examples
#' \dontrun{
#' ## Not run --
#' check_rest_version()
#' }
check_rest_version <- function(host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest", 
                               suffix = "version",
                               silent = FALSE) {
  
  jpred_version_url <- paste(host, suffix, sep = "/")
  response <- httr::GET(jpred_version_url)
  version_string <- httr::content(response, "text")
  jpred_version <- stringr::str_match(string = version_string, pattern = "VERSION=(v.[0-9]*.[0-9]*)")[2]
  if (!silent) {
    message(jpred_version)
  }
  return(jpred_version)
}


#' Check quota.
#' 
#' Check how many jobs you have already submitted on a given day
#' (out of 1000 maximum allowed jobs per user per day).
#'
#' @param email E-mail address.
#' @param host JPred host address.
#' @param suffix Host address suffix.
#' @param silent Should the work be done silently? (default = FALSE)
#'
#' @return Response.
#' 
#' @export
#' 
#' @importFrom httr GET content
#'
#' @examples
#' \dontrun{
#' ## Not run --
#' quota(email = "name@domain.com")
#' }
#' 
quota <- function(email, 
                  host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest", 
                  suffix = "quota",
                  silent = FALSE) {
  
  quota_url = paste(host, suffix, email, sep = "/")
  response <- httr::GET(quota_url)
  if (!silent) {
    message(httr::content(response, "text"))
  }
  return(response)
}


#' Determine JPred REST submission format.
#' 
#' Resolve format of submission to JPred REST interface based on provided mode and user format.
#'
#' @param mode Submission mode, possible values: "single", "batch", "msa".
#' @param user_format Submission format, possible values: "raw", "fasta", "msf", "blc".
#'
#' @return Format for JPred REST interface.
resolve_rest_format <- function(mode, user_format) {
  
  if (user_format == "raw" & mode == "single") {
    rest_format <- "seq"
  } else if (user_format == "fasta" & mode == "single") {
    rest_format <- "seq"
  } else if (user_format == "fasta" & mode == "msa") {
    rest_format <- "fasta"
  } else if (user_format == "msf" & mode == "msa") {
    rest_format <- "msf"
  } else if (user_format == "blc" & mode == "msa") {
    rest_format <- "blc"
  } else if (user_format == "fasta" & mode == "batch") {
    rest_format <- "batch"
  } else {
    stop("Invalid mode/format combination.
         Valid combinations are: 
         --mode=single --format=raw
         --mode=single --format=fasta
         --mode=msa    --format=fasta
         --mode=msa    --format=msf
         --mode=msa    --format=blc
         --mode=batch  --format=fasta")
  }
  return(rest_format)
}


#' Create JPred parameters.
#' 
#' Create a string with JPred parameters for job submission.
#' 
#' @param rest_format Format for JPred REST interface.
#' @param file File path to a file with the job input (sequence or msa).
#' @param seq Alternatively, amino acid sequence passed as string of single-letter code without spaces, e.g. --seq=ATWFGTHY
#' @param skipPDB Should the PDB query be skipped? (default = TRUE)
#' @param email For a batch job submission, where to send the results?
#' @param name A name for the job.
#' @param silent Should the work be done silently? (default = FALSE)
#' 
#' @return Formatted string with JPred parameters.
create_jpred_query <- function(rest_format, file = NULL, seq = NULL, 
                               skipPDB = TRUE, email = NULL, name = NULL, 
                               silent = FALSE) {
  
  if (is.null(file) & is.null(seq)) {
    stop("Neither input sequence nor input file are defined.
         Please provide either --file or --seq parameters.")
  } else if (!is.null(file) & !is.null(seq)) {
    stop("Both input sequence and input file are defined.
         Please choose --file or --seq parameter.")
  }
  
  if (!is.null(file)) {
    sequence_query <- readChar(file, file.info(file)$size)
  } else if (!is.null(seq)) {
    sequence_query <- paste(">query", seq, sep = "\n")
  } else {
    sequence_query <- ""
  }

  if (skipPDB) {
    skipPDB <- "on"
  } else {
    skipPDB <- "off"
  }
  
  if (rest_format == "batch" & is.null(email)) {
    stop("When submitting batch job email is obligatory.
         You will receive detailed report, list of links and a link to archive
         to all results via email.")
  }
  
  if (!silent) {
    message(paste0("Your job will be submitted with the following parameters:\n",
                   "format: ", rest_format, "\n",
                   "skipPDB: ", skipPDB, "\n",
                   "file: ", file, "\n",
                   "seq: ", seq, "\n",
                   "email: ", email, "\n",
                   "name: ", name, "\n"))
  }
  
  parameters_list <- Filter(function(x) {!is.null(x)}, list(skipPDB=skipPDB, format=rest_format, email=email, name=name))
  parameters <- paste(names(parameters_list), parameters_list, sep = "=", collapse = "£€£€")
  query <- paste(parameters, sequence_query, sep = "£€£€")
  return(query)
}


#' Submit job to JPred interface.
#' 
#' Submit job to JPred REST API.
#' 
#' @param mode Submission mode, possible values: "single", "batch", "msa".
#' @param user_format Submission format, possible values: "raw", "fasta", "msf", "blc".
#' @param file File path to a file with the job input (sequence or msa).
#' @param seq Alternatively, amino acid sequence passed as string of single-letter code without spaces, e.g. --seq=ATWFGTHY
#' @param skipPDB Should the PDB query be skipped? (default = TRUE)
#' @param email For a batch job submission, where to send the results?
#' @param name A name for the job.
#' @param silent Should the work be done silently? (default = FALSE)
#' @param host JPred host address.
#' @param suffix Host address suffix.
#' 
#' @return Response.
#' 
#' @export
#' 
#' @importFrom httr POST headers content
#' @importFrom stringr str_match
#' 
#' @examples
#' \dontrun{
#' ## Not run ---
#' submit(mode = "single", user_format = "raw", seq = "MQVWPIEGIKKFETLSYLPP")
#' submit(mode = "single", user_format = "raw", file = "inst/exampledata/single_raw.example")
#' submit(mode = "single", user_format = "fasta", file = "inst/exampledata/single_fasta.example")
#' submit(mode = "batch", user_format = "fasta", file = "inst/exampledata/batch_fasta.example", email = "name@domain.com")
#' submit(mode = "msa", user_format = "fasta", file = "inst/exampledata/msa_fasta.example", email = "name@domain.com")
#' submit(mode = "msa", user_format = "msf", file = "inst/exampledata/msa_msf.example", email = "name@domain.com")
#' submit(mode = "msa", user_format = "blc", file = "inst/exampledata/msa_blc.example", email = "name@domain.com")
#' }
submit <- function(mode, user_format, file = NULL, seq = NULL, skipPDB = TRUE, 
                   email = NULL, name = NULL, silent = FALSE,
                   host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest",
                   suffix = "job") {
  
  rest_format <- resolve_rest_format(mode = mode, user_format = user_format)
  query <- create_jpred_query(rest_format = rest_format, file = file, 
                              seq = seq, skipPDB = skipPDB, email = email, 
                              name = name, silent = silent)
  
  job_url <- paste(host, suffix, sep = "/")
  response <- httr::POST(job_url, body = query, httr::add_headers("Content-type" = "text/txt"))
  
  if (response$status_code == 202 & grepl(pattern = "created jpred job", tolower(httr::content(response, "text")))) {
    if (rest_format != "batch") {
      result_url <- httr::headers(response)$location
      job_id <- stringr::str_match(string = result_url, pattern = "(jp_.*)$")[2]
      
      if (!silent) {
        message(paste("Created JPred job with jobid:", job_id))
        message(paste("You can check the status of the job using the following URL:", result_url))
      }
      
    } else if (rest_format == "batch") {
      if (!silent) {
        message(httr::content(response, "text"))
      }
    }
    
  } else {
    if (!silent) {
      message(paste(message(httr::content(response, "text")), response$status_code))
    }
  }
  return(response)
}


#' Check status.
#' 
#' Check status of the submitted job.
#'
#' @param job_id Job id.
#' @param results_dir_path Directory path where to save results if job is finished.
#' @param extract Extract or not results into directory (default = FALSE).
#' @param max_attempts Maximum number of attempts to check job status (default = 10).
#' @param wait_interval Wait interval before retrying to check job status in seconds (default = 60).
#' @param silent Should the work be done silently? (default = FALSE).
#' @param host JPred host address.
#' @param jpred4 JPred address for results retrieval.
#'
#' @return Response.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' ## Not run ---
#' status(job_id = "jp_K46D05A")
#' status(job_id = "jp_K46D05A", results_dir_path = "jpred_sspred/results")
#' status(job_id = "jp_K46D05A", results_dir_path = "jpred_sspred/results", extract = TRUE)
#' }
status <- function(job_id, results_dir_path = NULL, extract = FALSE, 
                   max_attempts = 10, wait_interval = 60, silent = FALSE,
                   host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest",
                   jpred4 = "http://www.compbio.dundee.ac.uk/jpred4") {
  if (!silent) {
    message("Your job status will be checked with the following parameters:")
    message(paste("Job id:", job_id))
    message(paste("Get results:", !is.null(results_dir_path)))
  }
  
  job_url = paste(host, "job", "id", job_id, sep = "/")
  
  attempts <- 0
  while (attempts < max_attempts) {
    response <- GET(job_url)
    
    if (grepl(pattern = "finished", tolower(httr::content(response, "text")))) {
      
      if (!is.null(results_dir_path)) {
        dir.create(results_dir_path, showWarnings = FALSE)
        results_dir_path <- file.path(results_dir_path, job_id)
        dir.create(results_dir_path, showWarnings = FALSE)
        
        archive_url <- paste(jpred4, "results", job_id, paste0(job_id, ".tar.gz"), sep = "/")
        archive_path <- file.path(results_dir_path, paste0(job_id, ".tar.gz"))
        
        download.file(archive_url, archive_path)
        
        if (extract) {
          untar(archive_path, exdir = results_dir_path)
        }
        
        if (!silent) {
          message(paste("Saving results to:", normalizePath(results_dir_path)))
        }
      }
      break
    } else {
      Sys.sleep(wait_interval)
      attempts <- attempts + 1
    }
  }
  return(response)
}

#' Download results.
#' 
#' Download results from JPred server.
#'
#' @param job_id Job id.
#' @param results_dir_path Directory path where to save results if job is finished.
#' @param extract Extract or not results into directory (default = FALSE).
#' @param max_attempts Maximum number of attempts to check job status (default = 10).
#' @param wait_interval Wait interval before retrying to check job status in seconds (default = 60).
#' @param silent Should the work be done silently? (default = FALSE).
#' @param host JPred host address.
#' @param jpred4 JPred address for results retrieval.
#'
#' @return Response.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' ## Not run ---
#' get_results(job_id = "jp_K46D05A")
#' get_results(job_id = "jp_K46D05A", results_dir_path = "jpred_sspred/results")
#' get_results(job_id = "jp_K46D05A", results_dir_path = "jpred_sspred/results", extract = TRUE)
#' }
get_results <- function(job_id, results_dir_path = NULL, extract = FALSE, 
                        max_attempts = 10, wait_interval = 60, silent = FALSE,
                        host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest",
                        jpred4 = "http://www.compbio.dundee.ac.uk/jpred4") {
  
  if (is.null(results_dir_path)) {
    results_dir_path <- file.path(getwd(), job_id)
  }
  
  response = status(job_id = job_id, results_dir_path = results_dir_path, 
                    extract = extract, silent = silent)
  return(response)
}
