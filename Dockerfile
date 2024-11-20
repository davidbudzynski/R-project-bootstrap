# license: GPL-2.0-or-later
FROM rocker/r-ver:4.4.2

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV PANDOC_VERSION=default
# specify which vesrion of quarto to install (default is the latest)
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/setup_R.sh \
    # note the date at the end of the link here. This is the date of the P3M
    # snapshot and it will install packages in a state from that date.
    https://packagemanager.posit.co/cran/__linux__/jammy/2024-11-20
RUN /rocker_scripts/install_texlive.sh
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_python.sh


# install R packages
RUN install2.r --error --skipinstalled --ncpus -1 \
    data.table \
    # ML
    mlr3 \
    tidymodels \
    # NLP
    quanteda \
    # renv \
    psych \
    stringi \
    skimr \
    openxlsx \
    rio \
    fs \
    janitor \
    languageserver \
    styler \
    lintr \
    gt \
    flextable \
    Rcpp \
    # web
    XML \
    jsonlite \
    httr \
    curl \
    # dates and time helper
    anytime \
    # copy data from clipboard
    # datapasta \
    # quick serialization
    qs \
    # for word reports
    officer \
    # logging
    logger \
    # cleanup downloaded packages
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*
# update data.table to the dev version to use the latest features. NOTE that
#this will pull any changes from the data.table repo, so it isn't recommended if
# you want to maintein a stable environment and keep reproducibility
# RUN R -e "data.table::update_dev_pkg()"
# install all packages used by rio for I/O
RUN R -e "rio::install_formats()"

# Once you have scripts to run, they can be added to the image and run during
# the image build process (as opposed to image rung time).
# RUN Rscript file.R
