# AGENTS.md

## Commands (run through GNU Make)

- `make lint` — `air format . --check` then `lintr::lint_dir()`
- `make format` — applies `air format .` in place
- `make test` — `testthat::test_dir('tests/testthat')` (tests live in `tests/testthat/`; there is no package-style `tests/testthat.R` runner)
- `make analysis` — `Rscript src/analysis.R`
- `make all` — lint + test + analysis
- `make init` — renames `rstudio-project-file.Rproj` to the directory basename (idempotent; safe to re-run)
- `make clean` — wipes `output/*` (regenerable; `.gitkeep` restored)
- Container: `make docker-build`, `make docker-run`, `make docker-save-image`, `make docker-load-image`. Defaults to `docker`; override with `make CONTAINER_TOOL=podman docker-build`.

## Environment gotchas

- The dev environment is the **Docker image**, not the host: host R 4.6.1 has none of the project packages installed (testthat, lintr, here, data.table, etc.). Run lint/test/analysis inside the container (`make docker-build` then `make docker-run`), or install the packages locally first. `air` is also only installed inside the image — verify with `command -v air` before running `make lint`/`make format` on the host.
- **`air` is the formatter, not `styler`.** It is a Rust binary, not an R package (styler is only installed in the image as a fallback). `air.toml` pins 80 cols, 4-space indent, arrow assignment, LF. Match it when writing code.
- `.lintr` disables `object_usage_linter` because data.table's non-standard evaluation produces false positives, and sets `indentation_linter(indent = 4L)` to agree with air.
- **No `renv`.** Package versions are pinned by the P3M date snapshot in the `Dockerfile` (`https://packagemanager.posit.co/cran/__linux__/noble/<date>`). The distro codename (`noble`, Ubuntu 24.04) must match the base image `rocker/r-ver:4.6.1`. To update the environment: bump the date in the Dockerfile, `make docker-build`, and optionally bump the base tag for a newer R.
- Paths are anchored with `here`: read from `data/raw`, write to `output/`; scripts call `here::i_am("src/analysis.R")`. Never hard-code absolute paths.
- `output/data`, `output/plots`, `output/reports` are gitignored except `.gitkeep` — all generated/regenerable, never commit their contents.

## Git workflow

- Conventional commit messages (`docs:`, `fix:`, `style:`, `build:`, `chore:`); work on type-prefixed branches (e.g. `chore/...`); changes land via pull requests on GitHub.
- AI agents are helpers, not authors: never add `Co-authored-by:` (or any similar authorship attribution) when committing or opening pull requests.