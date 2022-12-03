# List packages here that you expect to use in most of your target building
# These packages are loaded by default and also using the {tflow} add-in
# to load `packages.R` and `R/*.R` files (typically bound to Ctrl+Alt+P)
#
# In general, avoid adding too many packages to this file - only ones that
# You need to load for most of your workflow.  Use `::` in your functions
# For packages that you only call a few functions from, or attach packages
# to specific targets using the `tar_target(..., packages = "PACKAGE")` argument.
#
# Packages that don't need to be loaded but need to still be installed should be
# listed in the `_targets_package.R` file.

library(targets)
library(tarchetypes)
library(tidyverse)
#library(tidymodels)