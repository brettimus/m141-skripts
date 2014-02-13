#!/usr/bin/Rscript

# Load knitr
#
library(knitr)

# Get all .RMD file names from directory
# NOTE: regex used - case insensitive on the file suffix
#
rmds <- list.files(pattern="*\\.(R|r)(M|m)(D|d)")

# Check if there were actually any labs in the current directory
#
if (is.na(rmds[1])) {
  print("Could not find any .rmd labs. Are you sure you're in the right directory?")
} else {
  # Record number of files without .RMD extension
  #
  all <- list.files()
  num_bad_labs <- length(all) - length(rmds)
  
  # Create a directory for the .HTML files
  #
  html_dir <- file.path(getwd(),"labs_html")
  dir.create(html_dir)
  
  # Loop through and convert each .RMD file
  #
  for (i in 1:length(rmds)) {
   
    # Create the output path, including the new .HTML filename
    #
    out <- file.path(html_dir,
                        paste(
			  unlist(strsplit(rmds[i],"\\."))[1],
			  ".html",
			  sep=""
			)
		     )
    # Finally, do the conversion
    # (quiet suppresses output, but sometimes figures still load)
    # !(should wrap this in a tryCatch at some point)
    #
    knitr::knit2html(input=rmds[i],output=out, quiet=T)
  }

  ################################################################################################
  # BEGIN the search for deviant files
  #
  if (num_bad_labs != 0) {
    
    names <- character()    # char vector for deviants' names
    exts <- character()     # char vector for deviant filetypes
    
    for (i in 1:length(all)) {
      # This is inefficient but it's fine since we only deal with max 50 files...
      if (!all[i] %in% rmds) {
        name <- strsplit(all[i],"_")[[1]][1]   # strsplit(..) returns a list
	ext <- strsplit(all[i],"\\.")[[1]][2]  # NOTE use of "\\." for regex
	# Add the deviant to the vectors! Mwahaha!
	names <- append(names,name)
	exts <- append(exts,ext)
      }
     }
     
    # Create dataframe of deviants
    bad_eggs <- data.frame(NAMES=names,EXTS=exts, stringsAsFactors=F)
    # Alert user
    print(paste("There are",num_bad_labs,"labs with improper filetypes."))
    print("I shall list them for you:")
    for (i in 1:nrow(bad_eggs)) {
      msg <- paste(bad_eggs[i,1]," submitted a .",bad_eggs[i,2]," file", sep="")
      print(msg)
    }
  }
  #
  # END of deviant file check 
  ################################################################################
  
}