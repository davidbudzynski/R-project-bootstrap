library(testthat)
library(here)

source(here::here("src", "helpers.R"))

test_that("aggregate_monthly sums total sales by month", {
    sales <- data.table::data.table(
        month = c("Jan", "Jan", "Feb"),
        amount = c(1, 2, 3)
    )

    result <- aggregate_monthly(sales)

    expect_equal(nrow(result), 2)
    expect_equal(result[month == "Jan", total], 3)
    expect_equal(result[month == "Feb", total], 3)
})
