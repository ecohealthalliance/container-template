#!/usr/bin/env Rscript

temp_directory <- tempfile(pattern = "dir")
working_directory <- getwd()
dirname <- basename(working_directory)
zipfile <- tempfile(fileext = ".zip")

message("Downloding template...")
download.file(
  "https://github.com/ecohealthalliance/container-template/archive/refs/heads/main.zip",
  quiet = TRUE,
  destfile = zipfile)
unzip(zipfile, exdir = temp_directory)
temp_template_directory <- list.files(temp_directory, full.names = TRUE)
template_directory <- tempfile(pattern = "dir")
file.rename(temp_template_directory, template_directory)
file.remove(zipfile)


name_prompt <- paste0("Enter project name (or press Enter to use current directory, '", dirname, "'): ")
project_name <- readline(name_prompt)

projfiles <- list.files(template_directory, all.files = TRUE, full.names = TRUE, recursive = TRUE)

for (pfile in projfiles) {
  if(grepl("container-template", pfile)) {
    file.rename(pfile, gsub("container-template", project_name, pfile, fixed = TRUE))
  }
}

projfiles <- list.files(template_directory, all.files = TRUE, full.names = TRUE, recursive = TRUE)
