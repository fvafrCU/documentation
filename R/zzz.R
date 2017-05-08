.onLoad <- function(libname, pkgname) {
    if (is.character(libname) && is.character(pkgname)) {
       # soothe codetools::checkUsagePackage
    }
    warning("This package is deprecated. ", 
            "Use packages 'document' and 'excerptr' instead.")
    return(invisible(NULL))
}
