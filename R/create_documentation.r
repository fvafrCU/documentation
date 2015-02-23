create_documentation <- function(file_name,
                                 markdown = TRUE,
                                 roxygen = TRUE,
                                 ...
                                 ) {
    if (length(file_name) == 0) {stop('give a file_name!')}
    status_markdown  <- status_roxygen <- FALSE

    dots <- list(...)
    roxygen_defaults <- append(formals(create_roxygen_documentation),
                               formals(get_lines_between_tags)
                               )
    markdown_defaults <- formals(create_markdown_documentation)
    known_defaults <- append(roxygen_defaults, markdown_defaults)
    if (! all(names(dots) %in% names(known_defaults))) {
        stop(paste("got unkown argument(s): ",
                   paste(names(dots)[! names(dots) %in% names(known_defaults)],
                         collapse = ', ')))
    }
    arguments <- append(list(file_name = file_name), dots)
    if (markdown) {
        use <- modifyList(markdown_defaults, arguments)
        arguments_to_use <- use[names(use) %in% names(markdown_defaults)]
        # use only non-empty arguments
        arguments_to_use <- arguments_to_use[arguments_to_use != '']
        status_markdown <- do.call("create_markdown_documentation",
                                   arguments_to_use)
    }
    if (roxygen) {
        use <- modifyList(roxygen_defaults, arguments)
        arguments_to_use <- use[names(use) %in% names(roxygen_defaults)]
        # use only non-empty arguments
        arguments_to_use <- arguments_to_use[arguments_to_use != '']
        status_roxygen <- do.call("create_roxygen_documentation",
                                   arguments_to_use)
    }
    status <- c(markdown = status_markdown, roxygen = status_roxygen)
    return(invisible(status))
}
create_roxygen_documentation <- function(
                                         file_name,
                                         output_directory = '.',
                                         overwrite = FALSE,
                                         check_package = TRUE,
                                         copy_tmp_files_to = NULL,
                                         working_directory = tempdir(),
                                         ...
                                         ) {
    #% define variables
    out_file_name <- sub('.Rnw$', '.r', basename(file_name))
    package_name <- gsub('_', '.',
                         sub('.[rRS]$|.Rnw$', '', out_file_name, perl = TRUE)
                         )
    man_directory <- file.path(working_directory, package_name, 'man')
    package_directory <- file.path(working_directory, package_name)
    pdf_name <- sub('[rRS]$', 'pdf', out_file_name)
    pdf_path  <-  file.path(output_directory, pdf_name)
    txt_name <- sub('[rRS]$', 'txt', out_file_name)
    txt_path  <-  file.path(output_directory, txt_name)
    # out_file_name may contain underscores, which need to be escaped for
    # LaTeX.
    file_name_tex <- gsub('_', "\\_", out_file_name, fixed = TRUE)
    pdf_title <- paste('\'Roxygen documentation for file', file_name_tex, '\'')
    R_CMD_pdf <- paste('R CMD Rd2pdf --no-preview --internals',
                           '--title=',  pdf_title,
                           man_directory)
    # R CMD command line options mustn't have spaces around equal signs:
    R_CMD_pdf <- gsub('= ', '=', R_CMD_pdf)
    #% create temporary directory
    unlink(working_directory, recursive = TRUE)
    dir.create(working_directory)
    #% get the roxygen code
    roxygen_code <- get_lines_between_tags(file_name, ...)
    if (is.null(roxygen_code) || ! any(grepl("^#+'", roxygen_code))) {
        stop(paste("Couldn't find roxygen comments in file", file_name,
                   "\n You shoud set from_firstline and to_lastline to FALSE.")
        )
    }
    #% write new file to disk
    writeLines(roxygen_code, con = file.path(working_directory, out_file_name))
    #% create a package from new file
    package.skeleton(code_files = file.path(working_directory, out_file_name),
                     name = package_name, path = working_directory, 
                     force = TRUE)
    #% create documentation from roxygen comments for the package
    roxygenize(package.dir = package_directory)
    #% check if the package compiles
    if (check_package) {
        ##% first streamline the documentation
        fix_package_documentation(package_directory)
        ##% now check
        build_and_check_package(package_directory = package_directory,
                                working_directory = working_directory,
                                copy_tmp_files_to = copy_tmp_files_to
                                )
    }
    #% create documentation from Rd-files
    ##% first change to the temporary directory
    #######% we don't want to write to disk without knowing where we are.
    #######%
    old_working_directory <- setwd(working_directory)
    ##% create pdf
    system(R_CMD_pdf, intern = FALSE, wait = TRUE)
    ##% create txt
    Rd_txt <- NULL
    for (file in list.files(man_directory, full.names = TRUE)) {
        R_CMD_txt <- paste('R CMD Rdconv --type=txt', file)
        Rd_txt <- c(Rd_txt, system(R_CMD_txt, intern = TRUE, wait = TRUE))
    }
    writeLines(Rd_txt, con = txt_name)
    ##% go back to the output directory
    setwd(old_working_directory)
    #% copy pdf to output_directory
    files_copied <- c(status_pdf = file.copy(file.path(working_directory,
                                                       'Rd2.pdf'),
                                             pdf_path,
                                             overwrite = overwrite),
                      status_txt = file.copy(file.path(working_directory,
                                                       txt_name),
                                             txt_path,
                                             overwrite = overwrite)
                     )
    if (! all(files_copied)) {
        if (! files_copied["status_txt"])
            stop(paste("can't write to disk: file", txt_path,
                       'already exists!\n',
                       'You may want to set overwrite to TRUE'))
        if (! files_copied["status_pdf"])
            stop(paste("can't write to disk: file", pdf_path,
                       'already exists!\n',
                       'You may want to set overwrite to TRUE'))
    }
    return(invisible(all(files_copied)))
}

create_markdown_documentation <- function(file_name, python = 'python',
                                          arguments = NULL,
                                          magic_character = '%',
                                          comment_character ='#'
                                          ) {
    status <- FALSE
    if (is.null(magic_character)) {
        python_arguments <- '-h'
    } else {
        python_arguments <- c(arguments,
                       paste("-c '", comment_character, "'", sep =''),
                       paste('-m "', magic_character, '"', sep =''),
                       file_name)
    }
    if (Sys.which(python) == ""){
        if (.Platform$OS.type != 'unix') {
            message(paste('on Microsoft systems you may try to specify',
                          '"python" as something like',
                          '"c:/python34/python.exe"')
            )
        }
        stop(paste("can't locate", python))
    } else {
        parser <- system.file(file.path('python', 'parse_markdown_comments.py'),
                              package = 'documentation'
                              )
        status <- system2(python, args = c(parser, python_arguments))
        pdf_name <- paste(file_name, '_markdown.pdf', sep = '')
        tex_name <- paste(file_name, '_markdown.tex', sep = '')
        # parse_markdown_comments.py tries to tex the tex file. If it does not
        # succeed, we use the tools package.
        if (file.exists(tex_name) && ! file.exists(pdf_name)) {
                print('=============foo')
                tools::texi2dvi(tex_name, pdf = TRUE, clean = TRUE)
        }
        # python exit code 0 corresponds to TRUE, values <> 0 correspond to
        # FALSE
        status <- ! as.logical(status)
    }
    return(status)
}

