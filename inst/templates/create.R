#!/usr/bin/Rscript --vanilla
library("documentation")
md_only <- c("documentation_standard.r", "documentation_markdown.r")
for (md_file in md_only){
    create_markdown_documentation(md_file)
}
r_files <- list.files(pattern = "\\.r$")
roxy_files <- r_files[which(! (r_files  %in% md_only))]
for (roxy_file in roxy_files){
    create_documentation(roxy_file)
}
create_documentation("documentation_rnw.Rnw")
