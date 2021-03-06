% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_results}
\alias{get_results}
\title{Download results from JPred server.}
\usage{
get_results(jobid, results_dir_path = NULL, extract = FALSE,
  max_attempts = 10, wait_interval = 60, silent = FALSE,
  host = "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest",
  jpred4 = "http://www.compbio.dundee.ac.uk/jpred4")
}
\arguments{
\item{jobid}{Job id.}

\item{results_dir_path}{Directory path where to save results if job is finished.}

\item{extract}{Extract or not results into directory (default = FALSE).}

\item{max_attempts}{Maximum number of attempts to check job status (default = 10).}

\item{wait_interval}{Wait interval before retrying to check job status in seconds (default = 60).}

\item{silent}{Should the work be done silently? (default = FALSE).}

\item{host}{JPred host address.}

\item{jpred4}{JPred address for results retrieval.}
}
\value{
Response.
}
\description{
Download results from JPred server.
}
\examples{
\dontrun{
## Not run ---
get_results(jobid = "jp_K46D05A")
get_results(jobid = "jp_K46D05A", results_dir_path = "jpred_sspred/results")
get_results(jobid = "jp_K46D05A", results_dir_path = "jpred_sspred/results", extract = TRUE)
}
}
