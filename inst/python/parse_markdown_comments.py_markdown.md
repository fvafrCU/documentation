#  markdown comments for various source files
 
  extract markdown-like comments from (source code) file, convert them to
  valid markdown and run pandoc on it.
  Since the comment characters for different languages change, this program
  can be adjusted to use the comment character used in your file by command
  line arguments.
 
  author: Dominik Cullmann  
  copyright: 2014-2015, Dominik Cullmann  
  license: BSD 3-Clause
  version: 0.1-4  
  maintainer: Dominik cullmann  
  email: dominik.cullmann@forst.bwl.de  
  status: prototype  

#  import modules
##  *This* is an example markdown comment of heading level 2
  **This** is an example of a markdown paragraph: markdown recognizes
  only six levels of heading, so we use seven levels to mark
  "normal" text.
  Here you can use the full
  [markdown syntax](http://daringfireball.net/projects/markdown/syntax).
  *Note* the trailing line: markdown needs an empty line to end a
  paragraph.
 
#  setup the markdown markup...
#  read the file into an arrays
#  read header
#  read body
##  only keep lines matching markdown markup
###  remove 7 heading levels
  empty lines (ending markdown paragraphs) are not written by
  file.write(), so we replace them by newlines.
 
#  parse command line arguments
#  write md file
#  run pandoc
#  If on posix...
##  ... tex it
##  ... warn otherwise
