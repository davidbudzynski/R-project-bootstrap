# license: GPL-2.0-or-later
FROM rocker/r-ver:4.6.1

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/davidbudzynski/R-project-bootstrap" \
      org.opencontainers.image.vendor="David Budzyński" \
      org.opencontainers.image.authors="David Budzyński <56514985+davidbudzynski@users.noreply.github.com>"

ENV PANDOC_VERSION=default
# specify which version of quarto to install (default is the latest)
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/setup_R.sh \
    # note the date at the end of the link here. This is the date of the P3M
    # snapshot and it will install packages in a state from that date. The
    # distro codename (noble = Ubuntu 24.04) must match the base image.
    https://packagemanager.posit.co/cran/__linux__/noble/2026-08-15
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
    # renv is intentionally not used: package versions are already pinned by
    # the P3M date snapshot above, and the entire environment is the image.
    # renv \
    psych \
    stringi \
    skimr \
    openxlsx \
    openxlsx2 \
    rio \
    fs \
    here \
    janitor \
    languageserver \
    styler \
    lintr \
    gt \
    flextable \
    Rcpp \
    # web
    XML \
    xml2 \
    jsonlite \
    httr2 \
    curl \
    # dates and time helper
    anytime \
    # copy data from clipboard
    # datapasta \
    # quick serialization
    qs2 \
    # for word reports
    officer \
    # logging
    logger \
    # development tooling
    testthat \
    withr \
    devtools \
    # cleanup downloaded packages
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*
# update data.table to the dev version to use the latest features. NOTE that
# this will pull any changes from the data.table repo, so it isn't recommended if
# you want to maintain a stable environment and keep reproducibility
# RUN R -e "data.table::update_dev_pkg()"
# install all packages used by rio for I/O
RUN R -e "rio::install_formats()"

# install air, the modern R formatter (a Rust binary, not an R package). The
# base image ships no curl CLI, so install it first. The installer adds air to
# the shell profile PATH, which non-interactive Docker steps do not source, so
# symlink the binary into /usr/local/bin if needed.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -LsSf https://github.com/posit-dev/air/releases/latest/download/air-installer.sh | sh \
    && if ! command -v air >/dev/null 2>&1; then \
         find "${HOME}" -type f -name air -exec ln -sf {} /usr/local/bin/air \; ; \
       fi \
    && air --version

# Once you have scripts to run, they can be added to the image and run during
# the image build process (as opposed to image run time).
# RUN Rscript file.R
