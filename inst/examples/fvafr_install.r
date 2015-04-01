#!/usr/bin/Rscript --vanilla
#' \emph{file} fvafr_install.r
#'
#' use installr to provide python3 and pandoc on window machines at fvafr.
#'
#' python3 should be installed to C:\CU\pyton34\
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: c292952dbede3c2450d513a0d394603f89d6f8b8 $
#' @docType data
#' @name A Header for
NULL
# ROXYGEN_STOP

system_info <- Sys.info()
if (grepl("FVAFR-", system_info["nodename"]) && 
    system_info["sysname"] == "Windows") {
	if (Sys.which("pandoc") == "") installr::install.pandoc()
	if (Sys.which("python3") == "") {
	  url <- "https://www.python.org/ftp/python/3.4.3/python-3.4.3.amd64.msi"
	  installr::install.URL(url)
	}
}

