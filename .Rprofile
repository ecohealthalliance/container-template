# Use the local user's .Rprofile when interactive.
# Good for keeping local preferences and shortcuts, but not always reproducible.
local({
  user_rprof <- Sys.getenv("R_PROFILE_USER", file.path(Sys.getenv("HOME"), ".Rprofile"))
  if(interactive() && file.exists(user_rprof)) source(user_rprof)
})

# Load .env environment variables
if (file.exists(".env")) {
  if(isTRUE(suppressWarnings(readBin(".env", "character", 2))[2] == "GITCRYPT")) {
    message(".env file is encrypted, not reading. Use git-crypt unlock to decrypt")
  } else {
    try(readRenviron(".env"))
  }
}

options(
  repos = c(RSPM = "https://packagemanager.rstudio.com/all/latest",
            CRAN = "https://cran.rstudio.com/"),
  renv.config.auto.snapshot = TRUE, ## Attempt to keep renv.lock updated automatically
  tidyverse.quiet = TRUE
)

# Since RSPM does not provide Mac binaries, always install packages from CRAN
# on mac or windows, even if renv.lock specifies they came from RSPM
if (Sys.info()[["sysname"]] %in% c("Darwin", "Windows")) {
  options(renv.config.repos.override = c(
    CRAN = "https://cran.rstudio.com/",
    INLA = "https://inla.r-inla-download.org/R/testing"))
} else if (Sys.info()[["sysname"]] == "Linux") {
  options(renv.config.repos.override = c(
    RSPM = "https://packagemanager.rstudio.com/all/latest",
    INLA = "https://inla.r-inla-download.org/R/testing"))
}

# Load the local library
if(file.exists("renv/activate.R")) source("renv/activate.R")

# If project packages have conflicts define them here, we start with common ones
if(requireNamespace("conflicted", quietly = TRUE)) {
  conflicted::conflict_prefer("filter", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("count", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("select", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("set_names", "magrittr", quiet = TRUE)
  conflicted::conflict_prefer("View", "utils", quiet = TRUE)
}
