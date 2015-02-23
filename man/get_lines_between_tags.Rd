\name{get_lines_between_tags}
\alias{get_lines_between_tags}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get_lines_between_tags(file_name, keep_tagged_lines = TRUE, begin_pattern = "ROXYGEN_START", end_pattern = "ROXYGEN_STOP", from_firstline = TRUE, to_lastline = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file_name}{
%%     ~~Describe \code{file_name} here~~
}
  \item{keep_tagged_lines}{
%%     ~~Describe \code{keep_tagged_lines} here~~
}
  \item{begin_pattern}{
%%     ~~Describe \code{begin_pattern} here~~
}
  \item{end_pattern}{
%%     ~~Describe \code{end_pattern} here~~
}
  \item{from_firstline}{
%%     ~~Describe \code{from_firstline} here~~
}
  \item{to_lastline}{
%%     ~~Describe \code{to_lastline} here~~
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
function (file_name, keep_tagged_lines = TRUE, begin_pattern = "ROXYGEN_START", 
    end_pattern = "ROXYGEN_STOP", from_firstline = TRUE, to_lastline = TRUE) 
{
    R_code_lines <- readLines(file_name)
    found_begin_tag <- any(grepl(begin_pattern, R_code_lines))
    found_end_tag <- any(grepl(end_pattern, R_code_lines))
    if (found_begin_tag || found_end_tag) {
        if (!found_begin_tag) {
            begin_line_indices <- 1
        }
        else {
            begin_line_indices <- grep(begin_pattern, R_code_lines)
        }
        if (!found_end_tag) {
            end_line_indices <- 1
        }
        else {
            end_line_indices <- grep(end_pattern, R_code_lines)
        }
        if (!keep_tagged_lines) {
            begin_line_indices <- begin_line_indices + 1
            end_line_indices <- end_line_indices - 1
        }
        if (from_firstline) {
            if (begin_line_indices[1] > end_line_indices[1]) {
                begin_line_indices <- c(1, begin_line_indices)
            }
        }
        if (to_lastline) {
            if (end_line_indices[1] < begin_line_indices[1]) {
                end_line_indices <- c(end_line_indices, length(R_code_lines))
            }
        }
    }
    else {
        if (from_firstline && to_lastline) {
            begin_line_indices <- 1
            end_line_indices <- length(R_code_lines)
        }
        else {
            return(NULL)
        }
    }
    if (length(begin_line_indices) != length(end_line_indices)) {
        stop("found unequal number of begin and end tags")
    }
    if (length(begin_line_indices) != length(end_line_indices)) {
        stop("found unequal number of begin and end tags")
    }
    if (!all(begin_line_indices <= end_line_indices)) {
        stop("begin and end tags not in proper order")
    }
    selected_lines <- eval(parse(text = paste("R_code_lines[c(", 
        paste(paste(begin_line_indices, end_line_indices, sep = ":"), 
            collapse = ","), ")]")))
    return(selected_lines)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
