
# ---- Load packages ----
# Only list packages here that you expect to use in most of your targets or
# in this script. Packages used only within certain targets are best
# referred to with `::` syntax, or in the `tar_target(..., packages = "pkgname")`
# argument. `_targets_packages.R` lists packages used interactively but not
# in your workflow
library(targets)
library(tarchetypes)
library(tidyverse)

# Load all the functions in the `R/` directory
targets::tar_source(files = "R") 


# ---- Options ----
# By default we use the `qs` format for faster read/write of targets
tar_option_set(
  resources = tar_resources(
    qs = tar_resources_qs(preset = "fast")),
  format = "qs"
)



# ---- Targets Plan ----

data_targets <- tar_plan(
)

analysis_targets <- tar_plan(
)

plot_targets <- tar_plan(
)

plot_file_targets <- tar_plan(
)

output_targets <- tar_plan(
  # Make the plan a target so README updates when it is changed
  tar_file(plan_targets, "_targets.R"), 
  tar_render(readme, path = "README.Rmd"),
  
  # Render any reports
  tar_render(report_template,
             path = "reports/report-template.Rmd"),
  
  # Extract useful numbers from elsewhere in the workflow
  summarized_quantities = summarize_quantities(),
  
  # Make a README in the outputs/ directory to view all figures
  tar_target_raw("all_plot_files", parse(text = paste0("c(", paste(map_chr(plot_file_targets, \(x) x$settings$name), collapse = ", "), ")"))),
  tar_render(outputs_readme, path = "outputs/README.Rmd", params = all_plot_files),
)

# ---- Final targets list  ----
list(
  data_targets,
  analysis_targets,
  plot_targets,
  plot_file_targets,
  output_targets
)