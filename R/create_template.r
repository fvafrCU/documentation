create_template <- function(type = 'template', file_name = '.') {
    if (! is.character(type)) stop(paste('type has got to be a character',
                                          'vector of length 1'
                                          )
    )
    if (length(type) != 1) stop(paste('type has got to be a character',
                                          'vector of length 1'
                                          )
    )

    available_types <- c('template', 'standard', 'roxygen', 'markdown',
                             'roxygen_markdown')
    if (! type  %in% available_types) stop(paste('type must be in c("', 
                                                 paste(available_types, 
                                                       collapse = '", "'
                                                       ),
                                                 '")',
                                                 sep = ''
                                                 )
    )
    template_name <- paste('documentation_', type, '.r', sep = '')
    template_path <- file.path('templates', template_name)
    template_file <- system.file(template_path, package = 'documentation')
    status <- file.copy(template_file, file_name)
    return(status)
}



