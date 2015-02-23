\name{create_markdown_documentation}
\alias{create_markdown_documentation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
create_markdown_documentation(file_name, python = "python", arguments = NULL, magic_character = "%", comment_character = "#")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file_name}{
%%     ~~Describe \code{file_name} here~~
}
  \item{python}{
%%     ~~Describe \code{python} here~~
}
  \item{arguments}{
%%     ~~Describe \code{arguments} here~~
}
  \item{magic_character}{
%%     ~~Describe \code{magic_character} here~~
}
  \item{comment_character}{
%%     ~~Describe \code{comment_character} here~~
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
function (file_name, python = "python", arguments = NULL, magic_character = "\%", 
    comment_character = "#") 
{
    status <- FALSE
    if (is.null(magic_character)) {
        python_arguments <- "-h"
    }
    else {
        python_arguments <- c(arguments, paste("-c '", comment_character, 
            "'", sep = ""), paste("-m \"", magic_character, "\"", 
            sep = ""), file_name)
    }
    if (Sys.which(python) == "") {
        if (.Platform$OS.type != "unix") {
            message(paste("on Microsoft systems you may try to specify", 
                "\"python\" as something like", "\"c:/python34/python.exe\""))
        }
        stop(paste("can't locate", python))
    }
    else {
        parser <- system.file(file.path("python", "parse_markdown_comments.py"), 
            package = "documentation")
        status <- system2(python, args = c(parser, python_arguments))
        pdf_name <- paste(file_name, "_markdown.pdf", sep = "")
        tex_name <- paste(file_name, "_markdown.tex", sep = "")
        if (file.exists(tex_name) && !file.exists(pdf_name)) {
            print("=============foo")
            tools::texi2dvi(tex_name, pdf = TRUE, clean = TRUE)
        }
        status <- !as.logical(status)
    }
    return(status)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
