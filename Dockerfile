FROM rocker/r-ver:4.3.3

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2023.12.0+369
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=1.4.550

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/setup_R.sh \
    https://packagemanager.posit.co/cran/__linux__/jammy/2024-03-01
RUN /rocker_scripts/install_texlive.sh
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_python.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server

# setup git credentials
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

#FIXME: this is not working
RUN git config --global user.name "${GIT_USER_NAME}"
RUN git config --global user.email "${GIT_USER_EMAIL}"

# copy ssh keys so it is possible to clone private repositories and commit
# changes from within the container

ARG SSH_PRIVATE_KEY

RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 0600 /root/.ssh/id_rsa && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# install R packages 
RUN install2.r --error --skipinstalled --ncpus -1 \
    data.table \
    # ML
    mlr3 \
    tidymodels \
    # NLP
    quanteda \
    renv \
    psych \
    stringi \
    skimr \
    openxlsx \
    rio \
    fs \
    janitor \
    languageserver \
    styler \
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
    datapasta \
    # quick serialization
    qs \
    # for word reports
    officer \
    # logging
    logger \
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*
# update data.table to the dev version
RUN R -e "data.table::update_dev_pkg()"
# install all packages used by rio for I/O
RUN R -e "rio::install_formats()"

EXPOSE 8787

CMD ["/init"]