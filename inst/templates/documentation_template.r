#!/usr/bin/Rscript --vanilla
#' file documentation_template.R 
#'
#' provide a template for create_documentation() mixing markdown and roxygen.
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 7ffb899e952f9d9dc057badbc3b3cf1060c02410 $
#' @note This header will show up in the documentation, but it's got nothing to
#' do with the R statements below. Usually this is not intended.
#' @section Warning: READ THIS FILE CAREFULLY. There's some information in the
#' comments.
# DO NOT CHANGE THE FOLLWOWING THREE LINES.
#' @docType data
#' @name A Header for
NULL
# ROXYGEN_STOP


##% load packages
library('methods') # load an example package from the standard library

##% source files
cat(file = 'local.tmp', 'options(warn = 1)') # we first have to create a dummy
source('local.tmp')

##% set 'global' options
options(warn = 2) # treat warnings as errors

##% define local functions
# ROXYGEN_START
#' Function example
#'
#' This really is just an example, the function prints \code{head()} and
#' \code{str} of the given \code{data.frame}.
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 7ffb899e952f9d9dc057badbc3b3cf1060c02410 $
#' @param data Name of a data.frame to ... do whatever needs to be done.
#' @return NULL. This is no good.
#'
a_first_function <- function(data) {
    print(head(data))
    print(str(data))
    return(invisible(NULL))
}

#' Function example
#'
#' This really is just an example, the function prints \code{head()} and
#' \code{str} of the given \code{data.frame}.
#'
#' This is just a copy of \code{\link{a_first_function}}. But we've added a
#' \emph{Details} section for roxygen.
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 7ffb899e952f9d9dc057badbc3b3cf1060c02410 $
#' @param data Name of a data.frame to ... do whatever needs to be done.
#' @return NULL. This is no good.
#'
a_second_function <- function(data) {
    print(head(data))
    print(str(data))
    return(invisible(NULL))
}

#% Analysis
#' Start of the analysis
#'
#' This comment cannot be properly documented by roxygen, since roxygen is
#' designed to document functions, libraries and the like. It will therefore be
#' ignored.
#'
#' DO NOT CHANGE THE FOLLWOWING LINE.
#' @rdname Header-package
# ROXYGEN_STOP
# IT MAKES SURE THE ROXYGEN COMMENTS ON THE ANALYSIS DO NOT SHOW UP IN
# THE DOCUMENTATION.
# (you should put your documentation comment in the file header, not at the
#  start of the analysis, and you should use usual R comments at the start of
#  the analysis. But I assume you don't. This is why that line is there.
#  You may remove it if you change the comment type of the 'Start of the
#  analysis' and the lines below it from roxygen2-style to standard R comments.
# )

## Of course you can define further functions, classes, methods, etc. down here.
## And you can add roxygen comments. They just won't get documented by
## roxygen2/documentation.
#' Function example
#'
#' This really is just an example, the function prints \code{head()} and
#' \code{str} of the given \code{data.frame}.
#'
#' This is just a copy of \code{\link{a_second_function}}. 
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 7ffb899e952f9d9dc057badbc3b3cf1060c02410 $
#' @param data Name of a data.frame to ... do whatever needs to be done.
#' @return NULL. This is no good.
#' @note This function won't be documented by roxygen/documentation!
#'
a_third_function <- function(data) {
    print(head(data))
    print(str(data))
    return(invisible(NULL))
}

a_first_function(swiss)

###% Load data
# we don't load anything here, it's just for the lulz.

###% Do some analysis
####% There is only a summary
summary(lm(Fertility ~ . , data = swiss))
#% collect garbage  
# We created a local options file on our file system, which we should
# remove now.
file.remove('local.tmp')



