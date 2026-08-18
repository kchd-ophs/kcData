#' Geographic identifiers
#'
#' @description
#' US Census Bureau geographic identifiers (GEOIDs) for areas that intersect
#' with Kansas City at several levels of geography.
#'
#' @details
#' Each element of `geoid2` is a dataframe containing GEOIDs for the areas
#' within a given geography level that intersect with Kansas City. Additional
#' details are included when available, such as area names, or useful, such as
#' county FIPS or census tract codes. For census tracts and ZCTAs, the
#' proportion of each area that overlaps with Kansas City is included.
#'
#' See the US Census Bureau web page [Understanding Geographic Identifiers][cen]
#' for more information on GEOIDs.
#'
#' [cen]:https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html
#'
#' @format A list containing `r length(geoid2)` dataframes.
#' \describe{
#'   \item{state}{GEOID for Missouri}
#'   \item{cbsa}{GEOID for Kansas City, KS-MO (core based statistical area)}
#'   \item{place}{GEOID for Kansas City}
#'   \item{county}{GEOIDs for counties intersecting with Kansas City}
#'   \item{tract2010}{GEOIDs for census tracts intersecting with Kansas City
#'   (2010)}
#'   \item{tract2020}{GEOIDs for census tracts intersecting with Kansas City
#'   (2020)}
#'   \item{zcta2010}{GEOIDs for ZIP code tabulation areas intersecting with
#'   Kansas City (2010)}
#'   \item{zcta2020}{GEOIDs for ZIP code tabulation areas intersecting with
#'   Kansas City (2020)}
#' }
#'
#' @source US Census Bureau TIGER/Line Shapefiles
#'
#' @name geoid2
#' @keywords datasets
"geoid2"
