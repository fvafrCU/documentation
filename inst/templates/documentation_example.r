#!/usr/bin/Rscript --vanilla
# The roxygen header starts next line.
#' \emph{file} documentation_example.r
#'
#' provide a real life example for \pkg{documentation}.
#'
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: c292952dbede3c2450d513a0d394603f89d6f8b8 $
#' @docType data
#' @name A Header for
NULL
# ROXYGEN_STOP

#% load packages, load local code, define local functions, set options
# You should stick to that order: if you define a function of a name which 
# is used as a (function) name in a package you load, you _do_ want your 
# version to mask the packages' version.  

##% load packages
library("methods") # load an example package from the standard library

# Set a cran mirror to avoid interactive junk.
r <- getOption("repos")   
r["CRAN"] <- "http://ftp5.gwdg.de/pub/misc/cran/"
options(repos = r)

if (! "documentation" %in% rownames(installed.packages())) {
    # load the documentation package through devtools.
    if (! "httr" %in% rownames(installed.packages())) {
        install.packages("httr")
    }
    if (.Platform$OS.type == "windows") {
        library(httr)
        set_config(use_proxy(url="10.127.255.17", port=8080))
    }
    if (! "devtools" %in% rownames(installed.packages())) {
      install.packages("devtools")
    }
    devtools::install_github("fvafrCU/documentation")
}

# install required packages if need be and load them afterwards, see 
# ?documentation:::provide_packages.
documentation:::provide_packages(c("ggplot2"))

##% load local code
# This would usually be functions defined and stored away in files.
# For now we just we just create a file containing R options 
# and then source it. 
cat(file = "tmp.R", "options(warn = 2) # treat warnings as errors \n") 
source("tmp.R")

##% define local functions
# ROXYGEN_START

#' FIXME
#'
#' @author FIXME
#' @section Version: FIXME
#' @param file FIXME
#' @param bg FIXME
#' @return FIXME
openPDF <- function(file, bg=TRUE) {
    message("This function is a verbatim copy of the openPDF() function from
Bioconductor: Open software development for computational biology and
bioinformatics R. Gentleman, V. J. Carey, D. M. Bates, B.Bolstad, M.
Dettling, S. Dudoit, B. Ellis, L. Gautier, Y. Ge, and others 2004,
Genome Biology, Vol. 5, R80

It is copyright by R. Gentleman, V. J. Carey, D. M. Bates, B.Bolstad, M.
  Dettling, S. Dudoit, B. Ellis, L. Gautier, Y. Ge, and others 2004. ")

   OST <- .Platform$OS.type
   if (OST=="windows")
      shell.exec(file)
   else
      if (OST == "unix") {
         bioCOpt <- getOption("BioC")
         pdf <- getOption("pdfviewer")
         msg <- NULL
         if (is.null(pdf))
             msg <- "getOption('pdfviewer') is NULL"
         else if (length(pdf)==1 && nchar(pdf[[1]])==0)
             msg <- "getOption('pdfviewer') is ''"
         if (!is.null(msg))
             stop(msg, "; please use 'options(pdfviewer=...)'")
         cmd <- paste(pdf,file)
         if( bg )
            cmd <- paste(cmd, "&")
         system(cmd)
      }
    return(TRUE)
}

#' write data to disk to pretend we read from a csv file
#' 
#' I just want to provide a common "read data from disk" example. So I write to
#' disk first. 
#' The function doesn't \code{\link{return}} anything sensible, it's used for
#' its side effects: it creates a subdirectory within the current \R working
#' directory and writes data into a csv file in that subdirectory.
#' 
#' @note Since the data is created within the function, it disappears after the
#' function terminates, so we don't have to clean up. We would use
#' \code{\link{on.exit}} if we had to.
#' @author Dominik Cullmann <dominik.cullmann@@forst.bwl.de>  
#' @section Version:* $Id: c292952dbede3c2450d513a0d394603f89d6f8b8 $  
#' @param subdirectory Name of the subdirectory to create.
#' @return invisibly NULL. This is no good.  
fake_data <- function(subdirectory) {
    # This structure was created by a call to dput() on an existing data.frame
    # in an R session long, long gone.
    old_data <- 
        structure(list(Baumart = structure(c(17L, 16L, 15L, 14L, 13L, 
                                             12L, 11L, 10L, 9L, 8L, 7L, 6L, 5L, 
                                             4L, 3L, 2L, 1L),
                                           .Label = c("sonst. Weichholz", 
                                                      "Pappeln", "Erlen", 
                                                      "Birken", 
                                                      "sonst. Hartholz", 
                                                      "Hainbuche", "Bergahorn", 
                                                      "Esche", "Roteiche", 
                                                      "Eichen", "Buche", 
                                                      "sonst. Nadelh.", 
                                                      "Lärchen", "Kiefer", 
                                                      "Douglasie", 
                                                      "Weißtanne", "Fichte"), 
                                           class = "factor"), 
                       value = c(33.9691456012294, 7.99971033422973, 
                                 3.37185094122167, 5.58481905493661, 
                                 1.76833653476758, 0.469877064925086, 
                                 21.8136258163657, 7.05250096043027,
                                 0.538397233960814, 4.91372646945832,
                                 3.65022666154437, 1.43595082597003,
                                 2.17737610449481, 1.24868228966577,
                                 1.08279677295428, 0.724697656550134,
                                 2.19827967729543), 
                       typ = c("Nadelholz", 
                               "Nadelholz", "Nadelholz", "Nadelholz", 
                               "Nadelholz", "Nadelholz", "Laubholz", "Laubholz",
                               "Laubholz", "Laubholz", "Laubholz", "Laubholz", 
                               "Laubholz", "Laubholz", "Laubholz", "Laubholz", 
                               "Laubholz")
                       ), 
                  .Names = c("Baumart", "value", "typ"), 
                  row.names = c(NA, -17L), 
                  class = "data.frame")

    if (! file.exists(subdirectory)) dir.create(subdirectory)
    write.csv2(old_data, file = file.path(subdirectory, "art_prozente.csv"), 
               row.names = FALSE)
    return(invisible(NULL))

}
# ROXYGEN_STOP

##% set "global" options
# We overwrite (mask) the options set from the options file. Had we done 
# it the other way round, we might be tempted to assume warn still to be 
# set to one, albeit it would have been overwritten by the sourced code.
options(warn = 1) 

#% Analyize the data
data_directory <- "input_data"

##% create data
fake_data(data_directory)

##% load data
art_prozente <- read.csv2(file = file.path(data_directory, "art_prozente.csv"))

##% plot sorted data
###% set up common colors
greens <-  c(rgb(124,252,0, maxColorValue = 255), 
             rgb(0,100,0, maxColorValue = 255))

###% create a local output directory
graphics_directory <- "graphics"
if (! file.exists(graphics_directory)) dir.create(graphics_directory)

###% do a ggplot2 graphic
# ggplot2 is a package that lets you do nice graphics with a couple of
# lines of code. 

####% sort data by value
art_prozente_sorted <- transform(art_prozente, 
                                 Baumart = reorder(Baumart, value))

####% create plot
x11(width = 12, height = 8)
the_plot <- ggplot(art_prozente_sorted,
                   aes(y = value, 
                       x = Baumart, 
                       fill = typ
                       ),
                   group = typ
                   ) 
the_plot <- the_plot + geom_bar(stat = "identity", 
                                position = position_dodge()) +
geom_text(aes(label=paste(round(value,1), "%"), y = -1 ), size = 4) + 
coord_flip() + scale_fill_manual(values =  greens, 
                                 name = "",
                                 guide = FALSE)  +
ylab ("Anteil von Hundert") + 
theme(axis.title =  element_text(color = "grey", size = 20),
      axis.text =  element_text(color = "black", size = 16))  

plot(the_plot)
####% save graphic
ggsave(file.path(graphics_directory, "arten_anteile.jpeg"),
       width = 12, height = 8
       )
dev.off()

###% redo the graphic manually
# ggplot2 gives us nice graphics, but we want nicer ones. 
# So we need more lines of code and a lot of manual settings.

####% sort data by value, but different
art_prozente_sorted <- art_prozente[order(art_prozente$value), ]

####% write the graphic directly into the local output directory
cairo_pdf(bg = "grey98", file.path(graphics_directory, "arten_anteile.pdf"),
          width = 7, height = 6.5)

####% set the limits of the abscissa
x_max  <- 40
x_min  <- 0
par(omi = c(0.65, 0.95, 0.75, 0.75), mai = c(0.3, 2, 0.35, 0), mgp = c(5, 3, 0),
    family = "Lato Light", las = 1)  
####% create plot
x <- barplot(art_prozente_sorted$value, names.arg = FALSE, horiz = TRUE, 
             border = NA, xlim = c(x_min, x_max),
             col = greens[1], cex.names = 0.85, axes = FALSE)
####% add title and note
mtext("Baumartenflächen im Gesamtwald",  3,  line = 1.3,  adj = 0,  cex = 1.2, 
      outer = TRUE)
text(x_max, 21.5, "Alle Angaben in Prozent", adj = 1, xpd = TRUE, cex = 0.65, 
     font = 3)
####% create ordinate labels
for (i in 1:length(art_prozente_sorted$Baumart)) {
    if (art_prozente_sorted$typ[i] %in% c("Nadelholz")) {
        font_type <- 2 #"bold"
    } else {
        font_type <- 1 #"plain"
    }
    print(font_type)
    text(-9, x[i], art_prozente_sorted$Baumart[i], xpd = TRUE, adj = 1, 
         cex = 0.85, font = font_type)
    text(-3.5, x[i], round(art_prozente_sorted$value[i], 1), xpd = TRUE, 
         adj = 1, cex = 0.85, font = font_type)
}
####% plot conifers in different color
conifers <- art_prozente_sorted$value
conifers[which(art_prozente_sorted$typ == "Laubholz")] <- 0
x2 <- barplot(conifers, names.arg = FALSE, horiz = TRUE, border = NA, 
              xlim = c(x_min, x_max), col = greens[2], cex.names = 0.85, 
              axes = FALSE, add = TRUE)
####% create shading rectangles
width <-  5
steps <- 8
for (i in (1:steps) -1 ) {
    if (i %% 2 == 0){
        rect(i * width, -0.5, (i + 1) * width, 28, 
             col = rgb(191, 239, 255, 120, maxColorValue = 255), 
             border = NA
             )
    } else {
        rect(i * width, -0.5, (i + 1) * width, 28, 
             col = rgb(191, 239, 255, 80, maxColorValue = 255), 
             border = NA
             )
    }
}
####% create abscissa labels
width <-  10
x <- seq(from = x_min, to = x_max, by = width)
mtext(x, at = x, 1, line = 0, cex = 0.8)

dev.off()
if (interactive()) openPDF(file.path(graphics_directory, "arten_anteile.pdf"))

#% collect garbage  
# We created a local options file on our file system, which we should remove
# now.
file.remove("tmp.R")
#% create documentation
if (.Platform$OS.type == "windows") {
    documentation::create_documentation("documentation_example.r", 
                                        overwrite = TRUE,
                                        python = "C:/CU/python34/python.exe")
} else {
    documentation::create_documentation("documentation_example.r", 
                                        overwrite = TRUE,
                                        arguments = "--latex")
}
if (interactive()) {
    openPDF("documentation_example.pdf")
    openPDF("documentation_example.r_markdown.pdf")
}

