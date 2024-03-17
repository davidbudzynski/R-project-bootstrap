---
Title: README
Author: David Budzynski
---

Inspired by [cookiecutter data science repo](https://github.com/drivendata/cookiecutter-data-science)

## Directory structure

```raw
.
├── data
│  └── raw                     <- The original, immutable data dump.
├── Dockerfile                 <- Dockerfile for building the docker image
├── .editorconfig              <- Configuration for your editor
├── LICENSE                    <- License for this project
├── Makefile                   <- Makefile with commands like `make data` or `make train
├── output
│  ├── data                    <- Processed data
│  ├── plots                   <- Generated graphics and figures to be used in reporting
│  └── reports                 <- Generated analysis as HTML, PDF, LaTeX, etc.
├── README.md                  <- The top-level README for developers using this project.
├── references                 <- Data dictionaries, manuals, and all other explanatory materials.
├── rstudio-project-file.Rproj <- RStudio project file
└── src                        <- Source code for use in this project.
```

## Usage

1. Initialize the project by running `make init`
