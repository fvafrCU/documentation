\name{create_markdown_documentation}
\alias{create_markdown_documentation}
\title{parse markdown comments.}
\usage{
create_markdown_documentation(file_name, python = "python",
  arguments = NULL, magic_character = "\%", comment_character = "#")
}
\arguments{
  \item{file_name}{name of or path to the file to be parsed
  through parse_markdown_comments.py.}

  \item{python}{name of or path to a python binary.}

  \item{comment_character}{the character indicating a
  comment line. In R this is '#'. You only need to change
  it if you want to run this function on a file containing
  code other than R. But then you might be better off using
  parse_markdown_comments.py directly.}

  \item{magic_character}{the magic character indicating a
  markdown comment.}

  \item{arguments}{a character vector of further arguments
  passed to parse_markdown_comments.py.}
}
\value{
TRUE on success, FALSE otherwise.
}
\description{
A wrapper to parse_markdown_comments.py.
}
\note{
should normally be invoked via
\code{\link{create_documentation}}. You could also run the
python code directly.
}
\section{Version}{
  $Id: 9bbb752b06d887f2115e37c3e9dadd89e40c49c7 $
}
\author{
Dominik Cullmann, <dominik.cullmann@forst.bwl.de>
}

