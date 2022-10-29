
# EHA Project Template

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![container-workflow-template](https://github.com/ecohealthalliance/container-template/actions/workflows/container-workflow-template.yml/badge.svg)](https://github.com/ecohealthalliance/container-template/actions/workflows/container-workflow-template.yml)

This is repository contains a template for EcoHealth Alliance R code projects.

## Quickstart

Start a new project by running this in the R console:

```r
source("https://raw.githubusercontent.com/ecohealthalliance/container-template/download-script/use-template.R")

```

or this in the shell:

```bash
 Rscript -e "$(curl -s https://raw.githubusercontent.com/ecohealthalliance/container-template/download-script/use-template.R)"
```


This is a template repository of a containerised R workflow built on the
`targets` framework, made portable using `renv`, and ran manually or
automatically using `GitHub Actions`.
