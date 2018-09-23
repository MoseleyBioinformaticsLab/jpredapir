#!/usr/bin/env Rscript

#' \code{jpredapir}: A package for interfacing with JPred server. 
#'
#' The \code{jpredapir} package provides functions to submit, check status, and 
#' retrieve results from JPred: A Secondary Structure Prediction Server 
#' ([JPred](http://www.compbio.dundee.ac.uk/jpred/)).
#' 
#' This package contains a collection of functions to interface with JPred server.
#' 
#' For a complete list, use \code{library(help = "jpredapir")}.
#' 
#' @section The \code{jpredapir} package functions:
#' 
#' \itemize{
#' \item \code{jpredapir::submit()} Submit job to JPred REST interface.
#' \item \code{jpredapir::status()} Check job status on JPred REST interface.
#' \item \code{jpredapir::get_results()} Download results from JPred server.
#' \item \code{jpredapir::quota()} Check JPred REST interface quota.
#' \item \code{jpredapir::check_rest_version()} Check version of JPred REST interface.
#' }
#'
#' @references Browse documentation at: \url{https://moseleybioinformaticslab.github.io/jpredapir}
#' @references Browse source code at: \url{https://github.com/MoseleyBioinformaticsLab/jpredapir}
#' @references Report a bugs at: \url{https://github.com/MoseleyBioinformaticsLab/jpredapir/issues}
#' @references JPred Server at: \url{http://www.compbio.dundee.ac.uk/jpred}
#'
#' @docType package
#' @name jpredapir
NULL
