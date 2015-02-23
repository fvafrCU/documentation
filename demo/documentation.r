#!/usr/bin/Rscript --vanilla
# Rscript does not load methods, which is required by utils::package.skeleton()
library(methods)
library(documentation)
working_directory <- file.path(dirname(tempdir()), 'documentation_demo')
unlink(working_directory, recursive = TRUE)
dir.create(working_directory)
setwd(working_directory)
create_documentation(system.file('templates/documentation_template.r', 
                                 package='documentation'))
create_template(file_name = 'my_r_file.r')
create_documentation(file_name = 'my_r_file.r')
second_working_directory <- file.path(dirname(tempdir()),
                                      'documentation_demo_2')
unlink(second_working_directory, recursive = TRUE)
dir.create(second_working_directory)
create_documentation(file_name = 'my_r_file.r', 
                     output_directory = second_working_directory)
for (file_name in list.files(system.file('templates',
                                         package = 'documentation'))) {
    if (file_name == 'documentation.Rnw' ) {
        template_path <- file.path('templates', file_name)
        template_file <- system.file(template_path, package = 'documentation')
        file.copy(template_file, file_name)
        create_documentation(file_name)
        ## of course we can still Sweave the file, we just need to rename it to
        ## avoid overwriting the roxygen documentation just created.
        sweave_file <- 'sweave.Rnw'
        file.copy(file_name, sweave_file)
        Sweave(sweave_file)
        tools::texi2dvi(sub("Rnw$", "tex", sweave_file), pdf = TRUE)
    } else {
        type <- sub('.R$', '', gsub('documentation_', '', file_name))
        message(paste('=======', file_name, '======='))
        create_template(type = type)
        switch(type,
               'standard' = create_documentation(file_name, 
                                                 magic_character = '', 
                                                 roxygen = FALSE), 
               'markdown' = create_documentation(file_name, roxygen = FALSE),
               'template' = message('We already have done this.'), 
               create_documentation(file_name)
               )
    }
}
