\name{create_roxygen_documentation}
\alias{create_roxygen_documentation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
create_roxygen_documentation(file_name, output_directory = ".", overwrite = FALSE, check_package = TRUE, copy_tmp_files_to = NULL, working_directory = tempdir(), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file_name}{
%%     ~~Describe \code{file_name} here~~
}
  \item{output_directory}{
%%     ~~Describe \code{output_directory} here~~
}
  \item{overwrite}{
%%     ~~Describe \code{overwrite} here~~
}
  \item{check_package}{
%%     ~~Describe \code{check_package} here~~
}
  \item{copy_tmp_files_to}{
%%     ~~Describe \code{copy_tmp_files_to} here~~
}
  \item{working_directory}{
%%     ~~Describe \code{working_directory} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (file_name, output_directory = ".", overwrite = FALSE, 
    check_package = TRUE, copy_tmp_files_to = NULL, working_directory = tempdir(), 
    ...) 
{
    out_file_name <- sub(".Rnw$", ".r", basename(file_name))
    package_name <- gsub("_", ".", sub(".[rRS]$|.Rnw$", "", out_file_name, 
        perl = TRUE))
    man_directory <- file.path(working_directory, package_name, 
        "man")
    package_directory <- file.path(working_directory, package_name)
    pdf_name <- sub("[rRS]$", "pdf", out_file_name)
    pdf_path <- file.path(output_directory, pdf_name)
    txt_name <- sub("[rRS]$", "txt", out_file_name)
    txt_path <- file.path(output_directory, txt_name)
    file_name_tex <- gsub("_", "\\_", out_file_name, fixed = TRUE)
    pdf_title <- paste("'Roxygen documentation for file", file_name_tex, 
        "'")
    R_CMD_pdf <- paste("R CMD Rd2pdf --no-preview --internals", 
        "--title=", pdf_title, man_directory)
    R_CMD_pdf <- gsub("= ", "=", R_CMD_pdf)
    unlink(working_directory, recursive = TRUE)
    dir.create(working_directory)
    roxygen_code <- get_lines_between_tags(file_name, ...)
    if (is.null(roxygen_code) || !any(grepl("^#+'", roxygen_code))) {
        stop(paste("Couldn't find roxygen comments in file", 
            file_name, "\n You shoud set from_firstline and to_lastline to FALSE."))
    }
    writeLines(roxygen_code, con = file.path(working_directory, 
        out_file_name))
    package.skeleton(code_files = file.path(working_directory, 
        out_file_name), name = package_name, path = working_directory, 
        force = TRUE)
    roxygenize(package.dir = package_directory)
    if (check_package) {
        fix_package_documentation(package_directory)
        build_and_check_package(package_directory = package_directory, 
            working_directory = working_directory, copy_tmp_files_to = copy_tmp_files_to)
    }
    old_working_directory <- setwd(working_directory)
    system(R_CMD_pdf, intern = FALSE, wait = TRUE)
    Rd_txt <- NULL
    for (file in list.files(man_directory, full.names = TRUE)) {
        R_CMD_txt <- paste("R CMD Rdconv --type=txt", file)
        Rd_txt <- c(Rd_txt, system(R_CMD_txt, intern = TRUE, 
            wait = TRUE))
    }
    writeLines(Rd_txt, con = txt_name)
    setwd(old_working_directory)
    files_copied <- c(status_pdf = file.copy(file.path(working_directory, 
        "Rd2.pdf"), pdf_path, overwrite = overwrite), status_txt = file.copy(file.path(working_directory, 
        txt_name), txt_path, overwrite = overwrite))
    if (!all(files_copied)) {
        if (!files_copied["status_txt"]) 
            stop(paste("can't write to disk: file", txt_path, 
                "already exists!\n", "You may want to set overwrite to TRUE"))
        if (!files_copied["status_pdf"]) 
            stop(paste("can't write to disk: file", pdf_path, 
                "already exists!\n", "You may want to set overwrite to TRUE"))
    }
    return(invisible(all(files_copied)))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
