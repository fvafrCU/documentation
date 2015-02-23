get_lines_between_tags <- function(file_name, keep_tagged_lines = TRUE,
                         begin_pattern = 'ROXYGEN_START', 
                         end_pattern = 'ROXYGEN_STOP',
                         from_firstline = TRUE, 
                         to_lastline = TRUE
                         ) {
    R_code_lines <- readLines(file_name)
    found_begin_tag <- any(grepl(begin_pattern, R_code_lines))
    found_end_tag <- any(grepl(end_pattern, R_code_lines))

    if (found_begin_tag || found_end_tag) {
        if(! found_begin_tag) {
            begin_line_indices <- 1
        } else {
            begin_line_indices <- grep(begin_pattern, R_code_lines) 
        }
        if(! found_end_tag) {
            end_line_indices <- 1
        } else {
            end_line_indices <- grep(end_pattern, R_code_lines) 
        }
        if (! keep_tagged_lines){
            begin_line_indices <- begin_line_indices + 1 
            end_line_indices <- end_line_indices - 1
        }
        if (from_firstline) {
            if (begin_line_indices[1] > end_line_indices[1]) {
                begin_line_indices  <- c(1, begin_line_indices)
            }
        }
        if (to_lastline) {
            if (end_line_indices[1] < begin_line_indices[1]) {
                end_line_indices  <- c(end_line_indices, length(R_code_lines))
            }
        }
    } else {
        ## no tagged lines found
        if (from_firstline && to_lastline) {
            begin_line_indices <- 1
            end_line_indices <- length(R_code_lines)
        } else {
            ## file contains neither end_pattern nor begin_pattern and should 
            ## not be used from first to last line. 
            return(NULL)
        }
    }
    if (length(begin_line_indices) != length(end_line_indices)){
        stop('found unequal number of begin and end tags')
    }
    if (length(begin_line_indices) != length(end_line_indices)){
        stop('found unequal number of begin and end tags')
    }
    if (! all(begin_line_indices <= end_line_indices)) {
        stop('begin and end tags not in proper order')
    }
    selected_lines <- eval(parse(
                               text = paste('R_code_lines[c(', 
                                            paste(paste(begin_line_indices, 
                                                        end_line_indices,
                                                        sep = ':'), 
                                                  collapse = ',')
                                            , ')]'
                                            )
                               )
    )
    return(selected_lines)
}

