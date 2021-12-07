################################################################################
#
#'
#' Check child anthropometric data
#' 
#' @param df Child anthropometric data
#' @param output What output should be returned? Either `all` to return all
#'   rows of data in `df` or `check` to return only rows of data that have been
#'   flagged for checking. Default is `all`
#'
#' @return A data.frame based on `df` with additional check variables. If
#'   `output` set to `check`, result is a subset of `df` of rows flagged with
#'   issues.
#'
#
################################################################################

check_anthro_data <- function(df, output = c("all", "check")) {
  ## Calculate z-scores --------------------------------------------------------
  anthro_zscores <- df |>
    mutate(age_days = age * (365.25 / 12)) %>%
    addWGSR( 
      sex = "sex", 
      firstPart = "wt",
      secondPart = "age_days",
      index = "wfa"
    ) |>
    addWGSR(
      sex = "sex",
      firstPart = "ht",
      secondPart = "age_days",
      index = "hfa"
    ) |>
    addWGSR(
      sex = "sex",
      firstPart = "wt",
      secondPart = "ht",
      index = "wfh"
    )
  
  ## Flag z-scores using WHO criteria ------------------------------------------
  anthro_flags <- anthro_zscores |>
    flag_who(hlaz = "hfaz", waz = "wfaz", whlz = "wfhz")
  
  output <- match.arg(output)
  
  ## Check what to output
  if (output == "check") {
    ## Get a list of rows of data with flags ------------------------------------
    anthro <- anthro_flags |> 
      filter(flag != 0)
  } else {
    anthro <- anthro_flags
  }
  
  ## Return results
  anthro
}
