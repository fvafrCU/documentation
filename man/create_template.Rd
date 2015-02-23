\name{create_template}
\alias{create_template}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
create_template(type = "template", file_name = ".")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{type}{
%%     ~~Describe \code{type} here~~
}
  \item{file_name}{
%%     ~~Describe \code{file_name} here~~
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
function (type = "template", file_name = ".") 
{
    if (!is.character(type)) 
        stop(paste("type has got to be a character", "vector of length 1"))
    if (length(type) != 1) 
        stop(paste("type has got to be a character", "vector of length 1"))
    available_types <- c("template", "standard", "roxygen", "markdown", 
        "roxygen_markdown")
    if (!type \%in\% available_types) 
        stop(paste("type must be in c(\"", paste(available_types, 
            collapse = "\", \""), "\")", sep = ""))
    template_name <- paste("documentation_", type, ".r", sep = "")
    template_path <- file.path("templates", template_name)
    template_file <- system.file(template_path, package = "documentation")
    status <- file.copy(template_file, file_name)
    return(status)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
