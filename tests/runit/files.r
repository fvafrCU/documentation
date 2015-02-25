test_md <- function() {
    for (file_name in list.files(full.names = TRUE, 
                                 system.file('expected_files', 
                                             package = 'documentation'),
                                 pattern = "\\.md"
                                 )
    ) {
        working_directory <- file.path(dirname(tempdir()), 'documentation_demo')
        current <- readLines(file.path(working_directory, basename(file_name)))
        reference  <- readLines(file_name)
        # delete lines containing differing git Id tags
        current <- grep("*\\$Id:*", current, invert = TRUE, value = TRUE)
        reference <- grep("*\\$Id:*", reference, invert = TRUE, value = TRUE)
        checkTrue(identical(current, reference))
    }
}
test_txt <- function() {
    for (file_name in list.files(full.names = TRUE, 
                                 system.file('expected_files', 
                                             package = 'documentation'),
                                 pattern = "\\.txt"
                                 )
    ) {
        working_directory <- file.path(dirname(tempdir()), 'documentation_demo')
        current <- readLines(file.path(working_directory, basename(file_name)))
        reference  <- readLines(file_name)
        # delete lines containing differing git Id tags
        current <- grep("*\\$Id:*", current, invert = TRUE, value = TRUE)
        reference <- grep("*\\$Id:*", reference, invert = TRUE, value = TRUE)
        checkTrue(identical(current, reference))
    }
}
