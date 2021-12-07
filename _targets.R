################################################################################
#
# Project build script
#
################################################################################

# Load packages (in packages.R) and load project-specific functions in R folder
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)

# Set build options ------------------------------------------------------------


# Groups of targets ------------------------------------------------------------

## Data input
data_targets <- tar_plan(
  nutrition_data = zscorer::anthro2,
  nutrition_data_check = check_anthro_data(df = nutrition_data),
  nutrition_data_issues = check_anthro_data(df = nutrition_data, output = "check"),
  nutrition_data_clean = nutrition_data_check |> filter(flag != 0)
)


## Analysis targets
analysis_targets <- tar_plan(
  wasting_recode = find_child_wasting(
    df = nutrition_data_clean, index = "whz", zscore = "wfhz"
  ),
  wasting_prevalence = sum(wasting_recode[["wfhz"]], na.rm = TRUE) / nrow(wasting_recode)
)


## Report targets
report_targets <- tar_plan(
  tar_render(
    example_report, path = "reports/example_report.Rmd", 
    output_dir = "outputs", knit_root_dir = here::here()
  )
)

## Deploy targets


# List targets -----------------------------------------------------------------

list(
  data_targets,
  analysis_targets,
  report_targets
)
