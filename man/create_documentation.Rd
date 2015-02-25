\name{create_documentation}
\alias{create_documentation}
\title{roxygenize an R code file, output the documentation to pdf.}
\usage{
create_documentation(file_name, markdown = TRUE, roxygen = TRUE, ...)
}
\arguments{
  \item{file_name}{name your R code file to be documented.}

  \item{markdown}{set to FALSE if you do not want to parse
  markdown comments in your file.}

  \item{roxygen}{set to FALSE if you do not want to
  roxygenize your file.}

  \item{...}{arguments passed to
  \code{\link{create_roxygen_documentation}} or
  \code{\link{create_markdown_documentation}}.}
}
\value{
a logical vector indicating whether markdown comments and
roxygen annotations were parsed.
}
\description{
roxygenize an R code file, output the documentation to pdf.
}
\section{Version}{
  $Id: 9bbb752b06d887f2115e37c3e9dadd89e40c49c7 $
}
\examples{
create_template(file_name = 'my_r_file.r', type = 'roxygen_markdown')
create_documentation('my_r_file.r', overwrite = TRUE)
}
\author{
Dominik Cullmann, <dominik.cullmann@forst.bwl.de>
}

