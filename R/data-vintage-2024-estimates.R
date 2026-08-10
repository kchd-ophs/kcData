#' Vintage 2024 population estimates
#'
#' @description
#' Kansas City population estimates for 2021-2024. According to the [US Census
#' Bureau][v1], "Vintage 2024 is the most recent completed vintage and
#' consistent set of estimates."
#'
#' [v1]: https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-cities-and-towns.html
#'
#' @format A dataframe with `r nrow(vintage_2024_estimates)` rows and
#' `r ncol(vintage_2024_estimates)` columns.
#' \describe{
#'   \item{year}{Year}
#'   \item{estimate}{Resident population estimate as of July 1 of the year}
#' }
#'
#' @source [US Census Bureau, City and Town Intercensal Population Totals:
#' 2020-2024][v2]
#'
#' [v2]: https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-cities-and-towns.html
#'
#' @name vintage_2024_estimates
#' @keywords datasets
"vintage_2024_estimates"
