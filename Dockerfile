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
# prevent renv from creating symlinks
RUN echo 'options(renv.config.cache.symlinks = FALSE)' >> /root/.Rprofile
# install R packages 
RUN install2.r --error --skipinstalled --ncpus -1 \
    data.table \
    mlr3 \
    tidymodels \
    renv \
    psych \
    stringi \
    skimr \
    openxlsx \
    rio \
    fs \
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*
# update data.table to the dev version
RUN R -e "data.table::update_dev_pkg()"
# install all packages used by rio for I/O
RUN R -e "rio::install_formats()"

EXPOSE 8787

CMD ["/init"]