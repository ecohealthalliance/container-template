
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Containerised R workflow template

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![container-workflow-template](https://github.com/ecohealthalliance/container-template/actions/workflows/container-workflow-template.yml/badge.svg)](https://github.com/ecohealthalliance/container-template/actions/workflows/container-workflow-template.yml)
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

<img src=https://miro.medium.com/max/2617/1*8mUtip6z_oydfLi4P86KUw.png />

This repository, contains a template [GitHub
Actions](https://docs.github.com/en/actions) workflow with its
corresponding `.yml` file that illustrates how [GitHub
Actions](https://docs.github.com/en/actions) can be used to run and
maintain an R workflow that uses `targets` and `renv`.

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

The example/template workflow can be found inside the `.github` folder
and is shown below:

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
  #schedule:
  #  - cron: "0 8 * * *"
      
jobs:
  container-workflow-tempalte:
    runs-on: ubuntu-latest                                # Run on GitHub Actions runner
    #runs-on: [self-hosted, linux, x64, onprem-aegypti]   # Run the workflow on EHA aegypti runner
    #runs-on: [self-hosted, linux, x64, onprem-prospero]  # Run the workflow on EHA prospero runner
    container:
      image: rocker/verse:4.1.2
      
    steps:
      - uses: actions/checkout@v2
    
      - name: Install system dependencies
        run: |
          apt-get update && apt-get install -y --no-install-recommends \
          libcurl4-openssl-dev \
          libssl-dev
      
      - name: Restore R packages
        run: |
          renv::restore()
        shell: Rscript {0}
    
      - name: Run targets workflow
        run: |
          targets::tar_make()
        shell: Rscript {0}
```

In this example, we show a data quality check workflow report for a
nutrition survey of children 6-59 months old.

### The trigger

The trigger for GitHub Actions is specified in these lines in the
workflow YAML file:

``` yaml
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
  #schedule:
  #  - cron: "0 8 * * *"
```

This workflow automatically runs when there is a **push** or **pull
request** event to the main branch of the repository. This workflow has
also been set to have the option to be run manually from the GitHub
Actions page for any branch of the repository through the
`workflow-dispatch` specification in the workflow YAML file.

GitHub Actions can also be scheduled to run at specific times and
frequency using the `schedule` specification in the workflow YAML file
using [POSIX cron syntax](https://en.wikipedia.org/wiki/Cron). Scheduled
workflows run on the latest commit on the default or base branch. The
shortest interval you can run scheduled workflows is once every 5
minutes. In the example workflow, the `schedule` specification has been
set to run at 8 am everyday but this has been hashed out. If you would
like to schedule your workflow runs, remove the hash and then set the
POSIX cron syntax to the frequency that you require.

### The job

The job for GitHub Actions is specified in these lines in the workflow
YAML file:

``` yaml
jobs:
  container-workflow-template:
    runs-on: ubuntu-latest                                # Run on GitHub Actions runner
    #runs-on: [self-hosted, linux, x64, onprem-aegypti]   # Run the workflow on EHA aegypti runner
    #runs-on: [self-hosted, linux, x64, onprem-prospero]  # Run the workflow on EHA prospero runner
    container:
      image: rocker/verse:4.1.2
```

The job named `container-workflow-template` is specified to run on
runners hosted by GitHub Actions. These runners can be identified
through a tag that specifies the operating software followed by the
version. In the example workflow, the line specifying
`runs-on: ubuntu-latest` runs the workflow on a machine hosted by GitHub
Actions with the latest Ubuntu operating software.

The job can also be run on a self-hosted GitHub Actions runner that is
installed on EHA’s high performance computing machines using the
`runs-on` workflow YAML specification. Tags unique to this GitHub runner
are used to identify the specific machine to use. Syntax on how to
specify these runners are shown but hashed out.

To further make the GitHub Actions workflow more robust and
reproducible, we setup a container at the **job** level. The container
specified is a versioned R image that has `tidyverse` and other R
publishing tools installed. This container image would generally be
adequate for most workflows that require data wrangling and manipulation
using the `tidyverse` tools and reporting using `rmarkdown`. Some
projects/workflows (like those using spatial packages such as `sf`) may
benefit from using a different R image so change the container
specification accordingly. To read more about available R images, see
<https://www.rocker-project.org/images/>.

## Using this GitHub Actions workflow template

This repository has been set as a private template repository. This
means that this can be used by EHA staff for creating new repositories
with the same filesystem.

This can be done as follows:

1.  In your GitHub account, go to the EcoHealth Alliance organisation
    (<https://github.com/ecohealthalliance>) then click on the green
    button labeled `New`.

2.  You will now be directed to the `Create new repository` page. Here,
    right at the top, you will see the `Repository template` heading.
    Click on the drop down button right below this that says
    `No template`. You will then see all the available templates within
    EHA. Select the template named
    `ecohealthalliance/container-template`.

3.  Give your new repository a name, set the appropriate repository
    visibility, and then click on `Create repository`.

4.  You will now have a new repository the contents of which are the
    same files and structure as this template repository.

5.  You can now make the necessary changes and additions that are
    specific to your workflow.

## Using `git-crypt` to encrypt files in your workflow

Your project may contain a mix of public and private content. Being able
to encrypt the private contents of your project is very useful. It is
recommended that you use PGP (Pretty Good Privacy) encryption,
implemented by the program
[`git-crypt`](https://github.com/AGWA/git-crypt). It takes a bit to set
up but once activated makes sharing secure and seamless. To setup PGP
and `git-crypt` on your project that is based on this template, see the
[*Encryption* chapter of the EHA Modeling and Analytics
Handbook](https://ecohealthalliance.github.io/eha-ma-handbook/13-encryption.html).

Once you have enabled `git-crypt` on your project, you will need to make
the following edits to the `container-workflow-template.yml` file to be
able to perform symmetric key decryption described
[here](https://ecohealthalliance.github.io/eha-ma-handbook/13-encryption.html#extra-use-a-symmetric-key-for-automated-processes).
Here is the `container-workflow-template.yml` file updated to allow and
perform symmetric key decryption:

``` yaml
name: container-workflow-encrypted-template

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
  #schedule:
  #  - cron: "0 8 * * *"

env:
  GIT_CRYPT_KEY64: ${{ secrets.GIT_CRYPT_KEY64 }}
      
jobs:
  container-workflow-encrypted-tempalte:
    runs-on: ubuntu-latest                                # Run on GitHub Actions runner
    #runs-on: [self-hosted, linux, x64, onprem-aegypti]   # Run the workflow on EHA aegypti runner
    #runs-on: [self-hosted, linux, x64, onprem-prospero]  # Run the workflow on EHA prospero runner
    container:
      image: rocker/verse:4.1.2
      
    steps:
      - uses: actions/checkout@v2
    
      - name: Install system dependencies
        run: |
          apt-get update && apt-get install -y --no-install-recommends \
          git-crypt \
          libcurl4-openssl-dev \
          libssl-dev
          
      - name: Decrypt repository using symmetric key
        run: |
          echo $GIT_CRYPT_KEY64 > git_crypt_key.key64 && base64 -di git_crypt_key.key64 > git_crypt_key.key && git-crypt unlock git_crypt_key.key
          rm git_crypt_key.key git_crypt_key.key64
      
      - name: Restore R packages
        run: |
          renv::restore()
        shell: Rscript {0}
    
      - name: Run targets workflow
        run: |
          targets::tar_make()
        shell: Rscript {0}
```

Once you have edited your worklfow YAML file and before you push the
changes to GitHub, you will then have to add the symmetric key to your
GitHub repository as a secret.

First, generate a symmetric key by running this in your project
directory. This key can be regenerated at any time so there is no need
keep it. 

``` bash
# export key to tmp folder; convert it to base64 and display the key; then delete it
git-crypt export-key /tmp/key; base64 -i /tmp/key; rm /tmp/key
```

The key can now be used to decrypt the repository, and you
can provide it to GitHub Actions as a secret environment variable (see
<https://docs.github.com/en/actions/security-guides/encrypted-secrets>). 
Add it to GitHub’s secret environment variable field as `GIT_CRYPT_KEY64`.


