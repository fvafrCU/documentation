\name{create_documentation}
\alias{create_documentation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
create_documentation(file_name, markdown = TRUE, roxygen = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file_name}{
%%     ~~Describe \code{file_name} here~~
}
  \item{markdown}{
%%     ~~Describe \code{markdown} here~~
}
  \item{roxygen}{
%%     ~~Describe \code{roxygen} here~~
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
function (file_name, markdown = TRUE, roxygen = TRUE, ...) 
{
    if (length(file_name) == 0) {
        stop("give a file_name!")
    }
    status_markdown <- status_roxygen <- FALSE
    dots <- list(...)
    roxygen_defaults <- append(formals(create_roxygen_documentation), 
        formals(get_lines_between_tags))
    markdown_defaults <- formals(create_markdown_documentation)
    known_defaults <- append(roxygen_defaults, markdown_defaults)
    if (!all(names(dots) \%in\% names(known_defaults))) {
        stop(paste("got unkown argument(s): ", paste(names(dots)[!names(dots) \%in\% 
            names(known_defaults)], collapse = ", ")))
    }
    arguments <- append(list(file_name = file_name), dots)
    if (markdown) {
        use <- modifyList(markdown_defaults, arguments)
        arguments_to_use <- use[names(use) \%in\% names(markdown_defaults)]
        arguments_to_use <- arguments_to_use[arguments_to_use != 
            ""]
        status_markdown <- do.call("create_markdown_documentation", 
            arguments_to_use)
    }
    if (roxygen) {
        use <- modifyList(roxygen_defaults, arguments)
        arguments_to_use <- use[names(use) \%in\% names(roxygen_defaults)]
        arguments_to_use <- arguments_to_use[arguments_to_use != 
            ""]
        status_roxygen <- do.call("create_roxygen_documentation", 
            arguments_to_use)
    }
    status <- c(markdown = status_markdown, roxygen = status_roxygen)
    return(invisible(status))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
