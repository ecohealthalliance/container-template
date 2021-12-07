######################## LOAD R PACKAGES #######################################

################################################################################
#
#' R packages needed to run any/most {targets} workflows
#
################################################################################

library(targets)
library(tarchetypes)
library(dplyr)
#library(tidyverse)
library(here)
library(knitr)
library(rmarkdown)

################################################################################
#
#' Additional R packages needed to run your specific workflow
#' 
#' * Delete or hash out code for R packages you don't need for your workflow
#' * Insert code here to load additional R packages that your workflow requires
#
################################################################################

library(zscorer)
library(nipnTK)
library(nutricheckr)
