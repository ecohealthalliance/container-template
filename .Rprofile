# Use the local user's .Rprofile when interative.
# Good for keeping local preferences, but not always reproducible.
user_rprof <- Sys.getenv("R_PROFILE_USER", normalizePath("~/.Rprofile", mustWork = FALSE))
if(interactive() && file.exists(user_rprof)) {
  source(user_rprof)
}
rm(user_rprof)

if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}

# Set options for renv convenience
options(
  repos = c(RSPM = "https://packagemanager.rstudio.com/all/latest",
            CRAN = "https://cran.rstudio.com/"),
  renv.config.auto.snapshot = FALSE, ## Attempt to keep renv.lock updated automatically
  renv.config.rspm.enabled = TRUE, ## Use RStudio Package manager for pre-built package binaries
  renv.config.install.shortcuts = TRUE, ## Use the existing local library to fetch copies of packages for renv
  renv.config.cache.enabled = TRUE   ## Use the renv build cache to speed up install times
)

# Since RSPM does not provide Mac binaries, always install packages from CRAN
# on Mac or Windows, and from RSPM on Linux, even if renv.lock specifies otherwise
if (Sys.info()[["sysname"]] %in% c("Darwin", "Windows")){
  options(renv.config.repos.override = c(
    CRAN = "https://cran.rstudio.com/"))
} else if (Sys.info()[["sysname"]] == "Linux") {
  options(renv.config.repos.override = c(
    RSPM = "https://packagemanager.rstudio.com/all/latest"))
}
source("renv/activate.R")

# If project packages have conflicts define them here so as
# as to manage them across all sessions when building targets
if(requireNamespace("conflicted", quietly = TRUE)) {
  conflicted::conflict_prefer("filter", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("count", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("select", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("set_names", "magrittr", quiet = TRUE)
  conflicted::conflict_prefer("View", "utils", quiet = TRUE)
}
