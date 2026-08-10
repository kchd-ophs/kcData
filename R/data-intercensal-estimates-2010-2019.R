#' Intercensal population estimates, 2010-2019
#'
#' @description
#' Kansas City population estimates for 2010-2019. According to the [US Census
#' Bureau][ic1], "Once produced, the intercensal estimates become the preferred
#' series of data for the decade."
#'
#' [ic1]: https://www.census.gov/programs-surveys/popest/technical-documentation/research/intercensal-estimates.html
#'
#' @format A dataframe with `r nrow(intercensal_estimates_2010_2019)` rows and
#' `r ncol(intercensal_estimates_2010_2019)` columns.
#' \describe{
#'   \item{year}{Year}
#'   \item{estimate}{Resident population estimate as of July 1 of the year}
#' }
#'
#' @source [US Census Bureau, City and Town Intercensal Population Totals:
#' 2010-2020][ic2]
#'
#' [ic2]: https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2010-2020-cities.html
#'
#' @name intercensal_estimates_2010_2019
#' @keywords datasets
"intercensal_estimates_2010_2019"
