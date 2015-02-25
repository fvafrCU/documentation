#!/usr/bin/Rscript --vanilla
library('documentation')
library('RUnit')
# create files
wd <- getwd()
demo('documentation')
package_suite <- defineTestSuite('doc',
                                 dirs = file.path(wd, 'runit'),
                                 testFileRegexp = '^.*\\.r',
                                 testFuncRegexp = '^test_+')

test_result <- runTestSuite(package_suite)
printTextProtocol(test_result, showDetails = TRUE)
html_file <- paste(package_suite$name, 'html', sep = '.')
printHTMLProtocol(test_result, fileName = html_file)
html <- file.path(getwd(), html_file)
if (interactive()) browseURL(paste0('file:', html))
