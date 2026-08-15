# Small pure functions extracted from the analysis so they can be unit
# tested in isolation.

# Summarise total sales per month from a data.table of sales records.
aggregate_monthly <- function(sales) {
    sales[, .(total = sum(amount)), by = month]
}
