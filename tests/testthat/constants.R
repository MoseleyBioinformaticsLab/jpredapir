SKIP_REAL_JPREDAPI <- TRUE
EXAMPLE_DATA_DIR <- file.path(rprojroot::find_root("DESCRIPTION"), "inst", "exampledata")
HOST <- "http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest"
JPRED4 <- "http://www.compbio.dundee.ac.uk/jpred4"
CLI_EXEC <- shQuote(file.path(rprojroot::find_root("DESCRIPTION"), "exec", "jpredapi.R"))
