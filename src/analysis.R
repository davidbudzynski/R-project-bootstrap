# Example analysis pipeline for the R project bootstrap template.
#
# This script demonstrates the recommended project layout:
#   - paths are anchored with {here} so the script runs from any directory
#   - intermediate data goes to output/data
#   - figures go to output/plots
#   - summary reports go to output/reports
#
# Replace the synthetic data generation with a real read from data/raw,
# for example: rio::import(here::here("data", "raw", "your_data.csv")).

library(data.table)
library(ggplot2)

here::i_am("src/analysis.R")
source(here::here("src", "helpers.R"))

set.seed(2026)

# --- data -------------------------------------------------------------------

# Placeholder for reading the immutable raw data from data/raw.
n <- 1000
sales <- data.table(
    month = sample(month.abb, n, replace = TRUE),
    region = sample(c("north", "south", "east", "west"), n, replace = TRUE),
    amount = round(rlnorm(n, meanlog = 4, sdlog = 0.8), 2)
)

# --- intermediate data -------------------------------------------------------

dir.create(here::here("output", "data"), recursive = TRUE, showWarnings = FALSE)
rio::export(sales, here::here("output", "data", "sales_clean.csv"))

# --- plots -------------------------------------------------------------------

dir.create(
    here::here("output", "plots"),
    recursive = TRUE,
    showWarnings = FALSE
)

monthly <- aggregate_monthly(sales)
plot <- ggplot(monthly, aes(x = factor(month, levels = month.abb), y = total)) +
    geom_col() +
    labs(x = "Month", y = "Total sales", title = "Monthly sales")

ggsave(
    here::here("output", "plots", "monthly_sales.png"),
    plot,
    width = 8,
    height = 5
)

# --- reports -----------------------------------------------------------------

dir.create(
    here::here("output", "reports"),
    recursive = TRUE,
    showWarnings = FALSE
)

summary <- sales[,
    .(
        n = .N,
        total = sum(amount),
        mean = mean(amount)
    ),
    by = region
]

gt::gt(summary) |>
    gt::tab_header(title = "Sales summary by region") |>
    gt::gtsave(here::here("output", "reports", "sales_summary.html"))

message("Analysis complete. Outputs written to output/.")
