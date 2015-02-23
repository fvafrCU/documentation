\name{build_and_check_package}
\alias{build_and_check_package}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
build_and_check_package(package_directory, working_directory, copy_tmp_files_to)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{package_directory}{
%%     ~~Describe \code{package_directory} here~~
}
  \item{working_directory}{
%%     ~~Describe \code{working_directory} here~~
}
  \item{copy_tmp_files_to}{
%%     ~~Describe \code{copy_tmp_files_to} here~~
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
function (package_directory, working_directory, copy_tmp_files_to) 
{
    on.exit(setwd(old_working_directory))
    old_working_directory <- setwd(working_directory)
    system(paste("R CMD build", package_directory))
    list.files(working_directory)
    package_name <- basename(package_directory)
    tar_ball <- list.files(pattern = paste(package_name, ".*tar.gz$", 
        sep = ""))
    r_cmd_check_status <- system(paste("R CMD check ", tar_ball))
    if (!is.null(copy_tmp_files_to)) {
        if (!file.exists(copy_tmp_files_to)) 
            dir.create(copy_tmp_files_to)
        file.copy(working_directory, copy_tmp_files_to, overwrite = TRUE, 
            recursive = TRUE)
    }
    else {
        if (r_cmd_check_status != 0) {
            message("You may want to set copy_tmp_files_to and rerun.")
        }
    }
    if (r_cmd_check_status != 0) {
        stop("R CMD check failed. Fix your sources.")
    }
    return(invisible(r_cmd_check_status))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
