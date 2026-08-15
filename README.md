---
Title: README
Author: David Budzynski
---

Inspired by [cookiecutter data science
repo](https://github.com/drivendata/cookiecutter-data-science)

## Directory structure

```raw
.
├── .dockerignore              <- Files excluded from the docker build context
├── .editorconfig              <- Configuration for your editor
├── .gitignore                 <- Files ignored by git
├── air.toml                   <- Configuration for the air formatter
├── data
│  └── raw                     <- The original, immutable data dump.
├── Dockerfile                 <- Dockerfile for building the docker image
├── LICENSE                    <- License for this project
├── Makefile                   <- Makefile with commands like `make data` or `make train`
├── output
│  ├── data                    <- Processed data
│  ├── plots                   <- Generated graphics and figures to be used in reporting
│  └── reports                 <- Generated analysis as HTML, PDF, LaTeX, etc.
├── README.md                  <- The top-level README for developers using this project.
├── references                 <- Data dictionaries, manuals, and all other explanatory materials.
├── rstudio-project-file.Rproj <- RStudio project file
├── src
│  ├── analysis.R              <- Example analysis pipeline (run with `make analysis`)
│  └── helpers.R               <- Pure helper functions, unit tested in tests/
└── tests
   └── testthat                <- testthat tests (run with `make test`)
```

## Usage

### Initializing the project

To initialize the project, simply run `make init`. This will rename the
`rstudio-project-file.Rproj` to the name of the directory you are currently in.

### Development and analysis

After initializing the project, you can start developing your analysis, by
adding any code to the `src` directory. You can also add any data to the
`data/raw` directory.

Paths in the scripts are anchored to the project root with the `here` package,
so they work regardless of the working directory or whether you run them inside
the docker container or on your local machine. Use `here::here()` when reading
from `data/raw` and writing to `output/`.

### GNU Make and the Makefile

By using a Makefile, you can define targets that will run certain commands. For
example, you can define a target that will run your analysis, or clean the
project. To be able to use it, you need to have GNU Make installed on your
system. Learn more about GNU Make [here](https://www.gnu.org/software/make/) To
read more about the existing Makefile, see the `Makefile` in the root of the
project.

Most likely the most common targets you will use are:

1. lint
2. format
3. test
4. analysis
5. clean
6. all (lint, test and analysis)

Additionally, the Makefile contain docker-specific targets, that will allow to
build image and run the analysis in the container.

### Formatting and linting with air

[air](https://posit-dev.github.io/air/) is the modern R formatter. Unlike
`styler`, it is a Rust binary rather than an R package, which makes it extremely
fast and easy to install. It is pre-bundled with Positron and VS Code, and can
be installed for command line use with `brew install air` or
`uv tool install air-formatter`. Within the docker image, air is already
installed.

- `make lint` checks that all R files are formatted with
  `air format . --check` and lints the code with `lintr`.
- `make format` applies air formatting in place.

The `air.toml` file pins the formatter settings (80 columns, 4-space indent, LF
line endings) so behaviour is identical across editors and CI.

### Docker

The project contains a `Dockerfile` that will allow you to build a docker image.
This image uses the Rocker project as base image, and installs all the necessary
packages and dependencies. You need to pay attention to the `Dockerfile` as it
contains important information about the image, like the R version, and the
packages that are installed. Make sure to update the `Dockerfile` with the
correct information. For example, if you want to use a different version of R,
you can change that, as well as the packages that are installed. In order to
make sure your entire project is reproducible, you need to add run the analysis
as part of the docker image build process. This can be done by adding the
`analysis` target to the `Dockerfile`.

```Dockerfile
RUN make analysis
```

Once you have built the image, you can run the analysis in the container. This
will allow you to add volume mounts, and run the analysis in a controlled
environment and be able to see the results of your analysis executed in the
container. To run the image, you can use the following command:

```bash
make docker-run
```

Docker is a very powerful tool, and it is a complex topic. To learn more about
it, specifically about using docker with R, you can read [Building reproducible
analytical pipelines with R](https://raps-with-r.dev/).

### Reproducibility with P3M date snapshots

All R packages are installed from a [Posit Package
Manager](https://packagemanager.posit.co/) (P3M) date snapshot, which pins every
package version to a specific date and provides precompiled Linux binaries. This
means package versions are reproducible without a separate dependency manager
such as `renv`; the entire environment is the container image.

To update the environment:

1. pick a new date (today is a good default) and update the date in the P3M URL
   in the `Dockerfile`,
2. rebuild the image with `make docker-build`,
3. bump the base image tag (`rocker/r-ver`) if you also want a newer R version.

Note that the distro codename in the P3M URL (`noble`, i.e. Ubuntu 24.04) must
match the base image.

## Project specific information

This is the place where you can add any information that is specific to your
project. For example, you can add information about the data, the analysis, or
any other information that is relevant to the project that will help other
developers understand it better.