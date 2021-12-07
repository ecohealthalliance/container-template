
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Containerised R workflow template

<!-- badges: start -->

\[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)\](<https://www.repostatus.org/#wip>
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

This is a template repository of a containerised R workflow built on the
`targets` framework, made portable using `renv`, and ran manually or
automatically using `GitHub Actions`.

## GitHub Actions

[GitHub Actions](https://docs.github.com/en/actions) allows automation,
customisation, and execution of your research project workflows right in
your GitHub repository.

In gist, [GitHub Actions](https://docs.github.com/en/actions) is a
*workflow* composed of a *job* or a number of *jobs*. The *job/s* are
then composed of *steps* that control the order in which *actions* are
run in order to complete a *job/s*. This *workflow* is scheduled or
triggered by a specific *event* and runs on what is called a *runner* -
a server that has the [GitHub
Actions](https://docs.github.com/en/actions) runner application
installed - that is either hosted by GitHub, or self-hosted on your own
machines.

This whole **workflow** including the **event** trigger and the
**runner** on which the **workflow** will run in are specified and
detailed using a workflow `.yml` file that is saved inside a directory
named `.github` within your GitHub repository in which you want to use
[GitHub Actions](https://docs.github.com/en/actions) on.

This repository, contains a template [GitHub
Actions](https://docs.github.com/en/actions) workflow with its
corresponding `.yml` file that illustrates how [GitHub
Actions](https://docs.github.com/en/actions) can be used to run and
maintain an R workflow that uses `targets` and `renv`.

<!--- INSERT IMAGE OF THE COMPONENTS HERE --->

## Using containers in GitHub Actions workflow

A **container** is a standard unit of software that packages up code and
all its dependencies so the application runs quickly and reliably from
one computing environment to another.

**Containers** can be used within a [GitHub
Actions](https://docs.github.com/en/actions) workflow and can be
specified either at the **job** level or at the **step** level. If
specified at the **job** level, all the **steps** within that **job**
will be run inside that container. When specified at the **steps**
level, different containers can be used for each **step**.

The example/template workflow can be found inside the `.github` folder.

The basic [GitHub Actions](https://docs.github.com/en/actions) workflow
that uses a container with the image of the most recent version of R and
that runs on GitHub runners is specified as follows:

``` yaml
name: container-workflow-template

on:
  push:
    branches:
      - main
      - master
  pull_request:
    branches:
      - main
      - master
  workflow_dispatch:
    branches:
      - '*'
      
jobs:
  container-workflow-tempalte:
    runs-on: [self-hosted, linux, x64, onprem-aegypti]    # Run the workflow on EHA aegypti runner
    #runs-on: ubuntu-latest                               # Run on GitHub Actions runner
    container:
      image: rocker/r-ver:4.1.2
      
    steps:
      - uses: actions/checkout@v2
      
      - name: Restore R packages
        run: |
          renv::restore(clean = TRUE)
        shell: Rscript {0}
    
      - name: Run targets workflow
        run: |
          targets::tar_make()
        shell: Rscript {0}
```

In this example, we show a data quality check workflow report for a
nutrition survey of children 6-59 months old. The container is setup at
the **job** level and as such each step is performed within the
specified container. This workflow is triggered by any ***push*** or
***pull request*** to the main/master branch of the repository and can
be manually run from the GitHub Actions page of the repository.
