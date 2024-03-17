---
Title: README
Author: David Budzynski
---

Inspired by [cookiecutter data science
repo](https://github.com/drivendata/cookiecutter-data-science)

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

### initializing the project

To initialize the project, simply run `make init`. This will rename the
`rstudio-project-file.Rproj` to the name of the directory you are currently in.

### Development and analysis

After initializing the project, you can start developing your analysis, by
adding any code to the `src` directory. You can also add any data to the
`data/raw` directory.

### GNU Make and the Makefile

By using a Makefile, you can define targets that will run certain commands. For
example, you can define a target that will run your analysis, or clean the
project. To be able to use it, you need to have GNU Make installed on your
system. Learn more about GNU Make [here](https://www.gnu.org/software/make/) To
read more about the existing Makefile, see the `Makefile` in the root of the
project.

Most likely the most common targets you will use are:

1. lint
2. analysis
3. clean
4. all (lint and analysis)
  
To run the analysis target, you need to provide the commands that will run the
analysis.

Additionally, the Makefile contain docker-specific targets, that will allow to
build image and run the analysis in the container.

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
