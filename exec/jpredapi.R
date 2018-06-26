#!/usr/bin/env Rscript

"
jpredapir command-line interface

The RESTful API allows JPred users to submit jobs from the command-line.

Usage:
    jpredapir submit (--mode=<mode> --format=<format>) (--file=<filename> | --seq=<sequence>) [--email=<name@domain.com>] [--name=<job_name>] [--rest=<address>] [--skipPDB] [--silent]
    jpredapir status (--jobid=<id>) [--results=<path>] [--wait=<interval>] [--attempts=<max>] [--rest=<address>] [--jpred4=<address>] [--extract] [--silent]
    jpredapir get_results (--jobid=<id>) [--results=<path>] [--wait=<interval>] [--attempts=<max>] [--rest=<address>] [--jpred4=<address>] [--extract] [--silent]
    jpredapir quota (--email=<name@domain.com>)
    jpredapir -h | --help
    jpredapir -v | --version

Options:
    -h, --help                 Show this help message.
    -v, --version              Show jpredapi version.
    --silent                   Do not print messages.
    --extract                  Extract results tar.gz archive.
    --skipPDB                  PDB check.
    --mode=<mode>              Submission mode, possible values: single, batch, msa.
    --format=<format>          Submission format, possible values: raw, fasta, msf, blc.
    --file=<filename>          Filename of a file with the job input (sequence(s)).
    --seq=<sequence>           Instead of passing input file, for single-sequence submission.
    --email=<name@domain.com>  E-mail address where job report will be sent (optional for all but batch submissions).
    --name=<job_name>          Job name.
    --jobid=<job_id>           Job id.
    --results=<path>           Path to directory where to save archive with results.
    --rest=<address>           REST address of server [default: http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest].
    --jpred4=<address>         Address of Jpred4 server [default: http://www.compbio.dundee.ac.uk/jpred4].
    --wait=<interval>          Wait interval before retrying to check job status in seconds [default: 60].
    --attempts=<max>           Maximum number of attempts to check job status [default: 10].
" -> doc

library(docopt)

cmdargs <- docopt(doc)
print(cmdargs)
print(cmdargs$format)

cli <- function(cmdargs) {
  if (cmdargs$submit) {
    jpredapir::submit(mode = cmdargs$mode,
                      user_format = cmdargs$format,
                      file = cmdargs$file,
                      seq = cmdargs$seq,
                      skipPDB = cmdargs$skipPDB,
                      email = cmdargs$email,
                      name = cmdargs$name,
                      silent = cmdargs$silent,
                      host = cmdargs$rest)
    
  } else if (cmdargs$status) {
    jpredapir::status(job_id = cmdargs$jobid,
                      results_dir_path = cmdargs$results,
                      extract = cmdargs$extract,
                      silent = cmdargs$silent,
                      max_attempts = cmdargs$attempts,
                      wait_interval = cmdargs$wait,
                      host = cmdargs$rest,
                      jpred4 = cmdargs$jpred4)
  
  } else if (cmdargs$get_results) {
    jpredapir::get_results(job_id = cmdargs$jobid,
                           results_dir_path = cmdargs$results,
                           extract = cmdargs$extract,
                           silent = cmdargs$silent,
                           max_attempts = cmdargs$attempts,
                           wait_interval = cmdargs$wait,
                           host = cmdargs$rest,
                           jpred4 = cmdargs$jpred4)
  
  } else if (cmdargs$quota) {
    jpredapir::quota(email = cmdargs$email)
  }
}

cli(cmdargs)
