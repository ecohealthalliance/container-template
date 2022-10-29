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
  "https://github.com/ecohealthalliance/container-template/archive/refs/heads/download-script.zip",
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
    new_name <- gsub("container-template", project_name, pfile, fixed = TRUE)
    file.rename(pfile, new_name)
    pfile <- new_name
  }
  # Replace any text of placeholders with the project name
  lines <- readLines(pfile, warn = FALSE)
  updated_lines <- gsub("container-template", project_name, lines, fixed = TRUE)
  cat(paste(updated_lines, collapse = "\n"), file = pfile)
}


setwd(template_directory)
invisible(file.remove('README.md'))
invisible(file.rename('README-template.Rmd', "README.Rmd"))

system("Rscript -e 'invisible()'")
org = "ecohealthalliance"

initialize_script <- paste0('
message("Installing packages")
invisible(capture.output((renv::restore())))
message("Testing `targets` pipeline")
targets::tar_make(reporter = "silent")
message("Setting up Git Repository")
invisible(gert::git_init())
invisible(gert::git_add("."))
invisible(gert::git_commit("Initial commit of project template"))
response <- gh::gh("POST orgs/', org, '/repos", ort = "', org, '", name = "', project_name, '", type = "private")')
system(paste("Rscript -e '", initialize_script, "'"))


cleanup_script <- '
renv::clean()
renv::update()
renv::snapshot()'

system(paste("Rscript -e '", cleanup_script, "'"))

file.remove("use-template.R")
