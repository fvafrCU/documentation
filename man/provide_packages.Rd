\name{provide_packages}
\alias{provide_packages}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
provide_packages(packages, mirror = "http://ftp5.gwdg.de/pub/misc/cran/")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{packages}{
%%     ~~Describe \code{packages} here~~
}
  \item{mirror}{
%%     ~~Describe \code{mirror} here~~
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
function (packages, mirror = "http://ftp5.gwdg.de/pub/misc/cran/") 
{
    status = NULL
    missing_packages <- get_missing_packages(packages)
    is_installation_required <- as.logical(length(missing_packages))
    if (is_installation_required) {
        install.packages(missing_packages, repos = mirror)
    }
    for (package in packages) {
        tmp <- library(package, character.only = TRUE, logical.return = TRUE)
        status <- c(status, tmp)
    }
    return(invisible(all(status)))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
