#' Geographic identifiers
#'
#' @description
#' US Census Bureau geographic identifiers (GEOIDs) for areas that intersect
#' with Kansas City at several levels of geography.
#'
#' @details
#' Each element of `geoid` is a dataframe containing GEOIDs for areas
#' intersecting with Kansas City within a given geography level. When a smaller
#' portion of the GEOID is commonly used, that code is included. For census
#' tracts and ZCTAs, the proportion of each area that overlaps with Kansas City
#' is included.
#'
#' See the US Census Bureau web page [Understanding Geographic Identifiers][cen]
#' for more information on GEOIDs.
#'
#' [cen]:https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html
#'
#' @format A list containing `r length(geoid)` dataframes.
#' \describe{
#'   \item{state}{GEOID for Missouri}
#'   \item{cbsa}{GEOID for Kansas City, KS-MO (core based statistical area)}
#'   \item{place}{GEOID and place FIPS code for Kansas City}
#'   \item{county}{GEOIDs and county FIPS codes for counties intersecting with
#'   Kansas City}
#'   \item{tract2000}{GEOIDs, tract codes, and proportion of overlap for census
#'   tracts intersecting with Kansas City in 2000}
#'   \item{tract2010}{GEOIDs, tract codes, and proportion of overlap for census
#'   tracts intersecting with Kansas City in 2010}
#'   \item{tract2020}{GEOIDs, tract codes, and proportion of overlap for census
#'   tracts intersecting with Kansas City in 2020}
#'   \item{zcta2000}{GEOIDs and proportion of overlap for ZIP code tabulation
#'   areas intersecting with Kansas City in 2000}
#'   \item{zcta2010}{GEOIDs and proportion of overlap for ZIP code tabulation
#'   areas intersecting with Kansas City in 2010}
#'   \item{zcta2020}{GEOIDs and proportion of overlap for ZIP code tabulation
#'   areas intersecting with Kansas City in 2020}
#' }
#'
#' @source US Census Bureau TIGER/Line Shapefiles
#'
#' @name geoid
#' @keywords datasets
"geoid"
