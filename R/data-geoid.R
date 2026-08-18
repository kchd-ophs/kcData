#' Geographic identifiers (superseded)
#'
#' @description
#' **This dataset has been superseded by [geoid2], which will eventually be
#' renamed `geoid`, and the current `geoid` will be removed from the package.**
#'
#' Geographic identifiers (GEOIDs) for Kansas City and other intersecting
#' regions. For census tracts and ZCTAs, GEOIDs are included if 10% or more of a
#' geometry's area is within the Kansas City boundary. See the US Census Bureau
#' page [Understanding Geographic Identifiers][cen] for more information on
#' GEOIDs.
#'
#' [cen]:https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html
#'
#' @format A list of character vectors containing GEOIDs
#' \describe{
#'   \item{state}{2-digit state FIPS code}
#'   \item{cbsa}{5-digit core-based statistical area code}
#'   \item{place}{2-digit state FIPS code and 5-digit place FIPS code}
#'   \item{county}{2-digit state FIPS code and 3-digit county FIPS code}
#'   \item{tract2010}{2-digit state FIPS code, 3-digit county FIPS code, and
#'   6-digit census tract code, 2010-2019}
#'   \item{tract2020}{2-digit state FIPS code, 3-digit county FIPS code, and
#'   6-digit census tract code, 2020-2024}
#'   \item{zcta2010}{5-digit ZIP code tabulation area code, 2010-2019}
#'   \item{zcta2020}{5-digit ZIP code tabulation area code, 2020-2024}
#' }
#'
#' @source US Census Bureau TIGER/Line Shapefiles
#'
#' @name geoid
#' @keywords datasets
"geoid"
