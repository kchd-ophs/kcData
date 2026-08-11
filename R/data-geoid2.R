#' KC-area GEOIDs
#'
#' @description
#' Geographic identifiers (GEOIDs) for the Kansas City area.
#'
#' @details
#' Each element of `geoid2` is a dataframe containing area names, if
#' applicable, and GEOIDs for a given geography level. `place`, `county`,
#' `tract2011`, and `tract2020` contain the commonly used shorter codes (i.e.,
#' without the state FIPS code) for those levels. `tract2011`, `tract2020`,
#' `zcta2012`, and `zcta2020` contain a variable `overlap` which is the
#' proportion of each area within the Kansas City boundary.
#'
#' See the US Census Bureau web page [Understanding Geographic Identifiers][cen]
#' for more information on GEOIDs.
#'
#' [cen]:https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html
#'
#' @format A list of dataframes.
#' \describe{
#'   \item{state}{Missouri GEOID}
#'   \item{cbsa}{Kansas City, KS-MO, GEOID}
#'   \item{place}{Kansas City GEOID}
#'   \item{county}{County GEOIDs and county FIPs codes}
#'   \item{tract2011}{2011 census tract GEOIDs, tract codes, and proportion of
#'   area overlapping with Kansas City}
#'   \item{tract2020}{2020 census tract GEOIDs, tract codes, and proportion of
#'   area overlapping with Kansas City}
#'   \item{zcta2012}{2012 ZCTA GEOIDs and proportion of area overlapping with
#'   Kansas City}
#'   \item{zcta2020}{2020 ZCTA GEOIDs and proportion of area overlapping with
#'   Kansas City}
#' }
#'
#' @source US Census Bureau TIGER/Line Shapefiles
#'
#' @name geoid2
#' @keywords datasets
"geoid2"
