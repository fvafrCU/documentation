provide_packages <- function(packages,
                             mirror = "http://ftp5.gwdg.de/pub/misc/cran/") {
    status = NULL
    missing_packages <- get_missing_packages(packages)
    is_installation_required <- as.logical(length(missing_packages))
    if(is_installation_required) {
        install.packages(missing_packages, repos = mirror)
    }
    for (package in packages) {
        tmp <- library(package, character.only = TRUE,  logical.return = TRUE)
        status <- c(status, tmp)
    }
    return(invisible(all(status)))  
}
get_missing_packages <- function(required_packages) {
    installed_packages <- as.character(installed.packages()[ ,1])
    is_required_and_installed <- required_packages  %in% installed_packages
    missing_packages <- required_packages[which(! is_required_and_installed)]
    return(missing_packages)
}
is_pandoc_installed <- function() {
    return(as.logical(length(Sys.which('pandoc'))))
}
install_pandoc <- function() {
    switch(.Platform$OS.type,
           'windows' = {
               provide_packages('installr')
               installr::install.pandoc()
           }
           , stop(paste('this is intended for windows, not for ',
                        .Platform$OS.type, '. Use your package/ports manager ',
                        'or compile pandoc from source.', sep = ''
                        )
           )              
       )
    return(invisible())
}
provide_pandoc <- function() {
    if (! is_pandoc_installed()) install_pandoc()
    return(invisible())
}
