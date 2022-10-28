#!/usr/bin/env Rscript

read_input <- function(prompt) {
  if (interactive()) {
    out <- readline(prompt)
  } else {
    cat(prompt);
    out <- readLines("stdin",n=1);
    cat( "\n" )
  }
  out
}


temp_directory <- tempfile(pattern = "dir")
working_directory <- getwd()
dirname <- basename(working_directory)
zipfile <- tempfile(fileext = ".zip")

message("Downloding template...\n")
download.file(
  "https://github.com/ecohealthalliance/container-template/archive/refs/heads/main.zip",
  quiet = TRUE,
  destfile = zipfile)
unzip(zipfile, exdir = temp_directory)
temp_template_directory <- list.files(temp_directory, full.names = TRUE)
template_directory <- tempfile(pattern = "dir")
invisible(file.rename(temp_template_directory, template_directory))
invisible(file.remove(zipfile))


name_prompt <- paste0("Enter project name (or press Enter to use current directory, '", dirname, "'): ")
project_name <- read_input(name_prompt)

projfiles <- list.files(template_directory, all.files = TRUE, full.names = TRUE, recursive = TRUE)

message("Modifying template to use '", project_name, "' as name")
for (pfile in projfiles) {
  # Rename any files with the template name to the project name
  if(grepl("container-template", pfile)) {
    file.rename(pfile, gsub("container-template", project_name, pfile, fixed = TRUE))
  }
  # Replace any text of placeholders with the project name
  lines <- readLines(pfile)
  updated_lines <- gsub("container-template", project_name, lines, fixed = TRUE)
  cat(paste(updated_lines, collapse = "\n"), pfile)
}

setwd(template_directory)
system2("Rscript initialize-template.R")
