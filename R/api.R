JPRED4 <- "http://www.compbio.dundee.ac.uk/jpred4"
HOST <- "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest"
VERSION <- "1.5.0"


check_version <- function(host = HOST, suffix = "version"){
  jpred_version_url <- paste(host, suffix, sep = "/")
  response <- GET(jpred_version_url)
  version_string <- content(response, "text")
  jpred_version <- str_match(string = version_string, pattern = "VERSION=(v.[0-9]*.[0-9]*)")[2]
  return(jpred_version)
}


quota <- function(email, host = HOST, suffix = "quota") {
  quota_url = paste(host, suffix, email, sep = "/")
  response <- GET(quota_url)
  print(content(response, "text"))
}

#' Create JPRED parameters
#' 
#' Creates a list of JPRED parameters for job submission.
#' 
#' @param mode what mode is being used. See Details.
#' @param user_format what format is the data in
#' @param file a file to submit
#' @param seq alternatively, a sequence in character string
#' @param skipPDB should the PDB query be skipped? (default = TRUE)
#' @param email for a batch job submission, where to send the results?
#' @param name a name for the job.
#' 
#' @export
#' 
#' @return list of jpred parameters
create_jpred_parameters <- function(mode, user_format, file = NULL, seq = NULL, 
                                  skipPDB = TRUE, email = NULL, name = NULL, 
                                  silent = FALSE){
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
         Valid combinations are: --mode=single --format=raw
         --mode=single --format=fasta
         --mode=msa    --format=fasta
         --mode=msa    --format=msf
         --mode=msa    --format=blc
         --mode=batch  --format=fasta")
  }
  
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
  
  #print(sequence_query)

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
    print("Your job will be submitted with the following parameters:")
    print(paste("format:", rest_format))
    print(paste("skipPDB:", skipPDB))
    if (!is.null(file)) {
      print(paste("file:", file))
    } else if (!is.null(seq)) {
      print(paste("seq:", seq))
    }

    if (!is.null(email)) {
      print(paste("email:", email))
    }

    if (!is.null(name)) {
      print(paste("name:", name))
    }
  }
  
  parameters_list <- Filter(function(x) {!is.null(x)}, list(skipPDB=skipPDB, format=rest_format, email=email, name=name))
  parameters <- paste(names(parameters_list), parameters_list, sep = "=", collapse = "£€£€")
  parameters

}

#' Submit a job
#' 
#' Sumits a job to jpred itself.
#' 
#' @param mode what mode is being used. See Details.
#' @param user_format what format is the data in
#' @param file a file to submit
#' @param seq alternatively, a sequence in character string
#' @param skipPDB should the PDB query be skipped? (default = TRUE)
#' @param email for a batch job submission, where to send the results?
#' @param name a name for the job.
#' 
#' @export
#' 
#' @importFrom httr POST headers content
#' @importFrom stringr str_match
submit <- function(mode, user_format, file = NULL, seq = NULL, skipPDB = TRUE, email = NULL, name = NULL, silent = FALSE) {

  parameters <- create_jpred_parameters(mode, user_format, file = file, seq = seq, 
                                        skipPDB = skipPDB, email = email, name = name, 
                                        silent = silent)
  query <- paste(parameters, sequence_query, sep = "£€£€")
  
  job_url <- paste(HOST, "job", sep = "/")
  response <- httr::POST(job_url, body = query, httr::add_headers("Content-type" = "text/txt"))
  
  if (response$status_code == 202) {
    if (rest_format != "batch") {
      result_url <- httr::headers(response)$location
      job_id <- stringr::str_match(string = result_url, pattern = "(jp_.*)$")[2]
      
      if (!silent) {
        print(paste("Created JPred job with jobid:", job_id))
        print(paste("You can check the status of the job using the following URL:", result_url))
      }
      
    } else if (rest_format == "batch") {
      print(httr::content(response, "text"))
    }
    
  } else {
    print(response$status_code)
  }
  
  return(response)
}


status <- function(job_id, results_dir_path = NULL, extract = FALSE, silent = FALSE, max_attempts = 10, wait_interval = 60) {
  if (!silent) {
    print("Your job status will be checked with the following parameters:")
    print(paste("Job id:", job_id))
    print(paste("Get results:", !is.null(results_dir_path)))
  }
  
  job_url = paste(HOST, "job", "id", job_id, sep = "/")
  
  # response = RETRY("GET", job_url, times = 10, pause_base = 60, pause_cap = 120)
  # I cannot use RETRY here because malformed "job_id" returns status code 200 as
  # well as correct "job_id" returns status code 200, i.e. incorrect REST API status 
  # codes handling. Will use while loop instead.
  
  attempts <- 0
  while (attempts < max_attempts) {
    response <- GET(job_url)
    
    if (grepl(pattern = "finished", content(response, "text"))) {
      
      if (!is.null(results_dir_path)) {
        dir.create(results_dir_path, showWarnings = FALSE)
        results_dir_path <- file.path(results_dir_path, job_id)
        dir.create(results_dir_path, showWarnings = FALSE)
        
        archive_url <- paste(JPRED4, "results", job_id, paste0(job_id, ".tar.gz"), sep = "/")
        archive_path <- file.path(results_dir_path, paste0(job_id, ".tar.gz"))
        
        download.file(archive_url, archive_path)
        
        if (extract) {
          untar(archive_path, exdir = results_dir_path)
        }
        
        if (!silent) {
          print(paste("Saving results to:", normalizePath(results_dir_path)))
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


get_results <- function(job_id, results_dir_path = NULL, extract = FALSE, silent = FALSE) {
  if (is.null(results_dir_path)) {
    results_dir_path <- file.path(getwd(), job_id)
  }
  
  status(job_id = job_id, results_dir_path = results_dir_path, extract = extract, silent = silent)
}

