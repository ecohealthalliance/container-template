# Use the local user's .Rprofile when interative.
# Good for keeping local preferences, but not always reproducible.
user_rprof <- Sys.getenv("R_PROFILE_USER", normalizePath("~/.Rprofile", mustWork = FALSE))
if(interactive() && file.exists(user_rprof)) {
  source(user_rprof)
}

if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}

if (Sys.info()[['sysname']] %in% c('Linux', 'Windows')) {
  options(repos = c(RSPM = "https://packagemanager.rstudio.com/all/latest"))
} else {
  ## For Mac users, we'll default to installing from CRAN/MRAN instead, since
  ## RSPM does not yet support Mac binaries.
  options(repos = c(CRAN = "https://cran.rstudio.com/"),
          pkgType = "both")
  # options(renv.config.mran.enabled = TRUE) ## TRUE by default
}



options(
  renv.config.repos.override = getOption("repos"),
  renv.config.auto.snapshot = FALSE, ## Don't keep renv.lock updated automatically (messes up GitHub Actions)
  renv.config.rspm.enabled = TRUE, ## Use RStudio Package manager for pre-built package binaries
  renv.config.install.shortcuts = TRUE, ## Use the existing local library to fetch copies of packages for renv
  renv.config.cache.enabled = TRUE   ## Use the renv build cache to speed up install times
)

source("renv/activate.R")


