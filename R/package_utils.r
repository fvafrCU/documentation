remove_package_Rd <- function(package_directory) {
    package_name <- basename(package_directory)
    package_rd <- paste(package_name, '-package.Rd', sep = '')
    status <- file.remove(file.path(package_directory, 'man', package_rd))
    return(invisible(status))
}

clean_description <- function(package_directory) {
    description_file <- file.path(package_directory, 'DESCRIPTION') 
    description <-  readLines(description_file)
    description <-  sub('(License: ).*', '\\1GPL', description)
    status <- writeLines(description, con = description_file)
    return(invisible(status))
}

fix_package_documentation <- function(package_directory) {
    remove_package_Rd(package_directory)
    clean_description(package_directory)
    return(invisible(NULL))
}

build_and_check_package <- function(package_directory, working_directory,
                                    copy_tmp_files_to) {
    on.exit(setwd(old_working_directory))
    # change to the template directory: we don't want to write to disk without
    # knowing where we are.
    old_working_directory <- setwd(working_directory)

    system(paste('R CMD build', package_directory))
    list.files(working_directory)
    package_name <- basename(package_directory)
    tar_ball <- list.files(pattern = paste(package_name, '.*tar.gz$', 
                                           sep = ''))
    r_cmd_check_status <- system(paste('R CMD check ', tar_ball))
    if (! is.null(copy_tmp_files_to)) {
        ## copy temporary files to see what R CMD check output was
        if(! file.exists(copy_tmp_files_to)) dir.create(copy_tmp_files_to)
        file.copy(working_directory, copy_tmp_files_to, overwrite = TRUE,
                  recursive = TRUE
                  )
    } else {
        if(r_cmd_check_status != 0) {
            message('You may want to set copy_tmp_files_to and rerun.')
        }
    }
    if(r_cmd_check_status != 0) {
        stop('R CMD check failed. Fix your sources.')
    }
    return(invisible(r_cmd_check_status))
}


