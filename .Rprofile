if (file.exists(".env")) {
  try(readRenviron(".env"))
}

options(
  repos = c(RSPM = "https://packagemanager.rstudio.com/all/latest",
            CRAN = "https://cran.rstudio.com/"),
  
  renv.config.auto.snapshot = TRUE, ## Attempt to keep renv.lock updated automatically
  renv.config.rspm.enabled = TRUE, ## Use RStudio Package manager for pre-built package binaries
  renv.config.install.shortcuts = TRUE, ## Use the existing local library to fetch copies of packages for renv
  renv.config.cache.enabled = TRUE,   ## Use the renv build cache to speed up install times
  renv.config.cache.symlinks = TRUE,  ## Keep full copies of packages locally than symlinks to make the project portable in/out of containers
  renv.config.install.transactional = FALSE,
  renv.config.synchronized.check = FALSE,
  
  mc.cores = min(parallel::detectCores(), 4)
  
)

if (!Sys.getenv("USE_CAPSULE") != "") {
  if (file.exists("renv/activate.R")) {
    source("renv/activate.R")
  } else {
    message("No renv/activate.R")
  }
} else {
  message("Skipping renv load. Use {capsule} commands.")
}

# Use the local user's .Rprofile when interactive.
# Good for keeping local preferences, but not always reproducible.
user_rprof <- Sys.getenv("R_PROFILE_USER", normalizePath("~/.Rprofile", mustWork = FALSE))
if(interactive() && file.exists(user_rprof)) {
  source(user_rprof)
}
rm(user_rprof)

# If project packages have conflicts define them here
if(requireNamespace("conflicted", quietly = TRUE)) {
  conflicted::conflict_prefer("filter", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("count", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("select", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("geom_rug", "ggplot2", quiet = TRUE)
  conflicted::conflict_prefer("set_names", "magrittr", quiet = TRUE)
  conflicted::conflict_prefer("View", "utils", quiet = TRUE)
}
