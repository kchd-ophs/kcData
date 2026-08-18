#' Get population data for Kansas City
#'
#' @description
#' Download population data for Kansas City from the decennial census or the
#' American Community Survey (ACS). Summary levels are place, county, census
#' tract, census block group, census block (decennial census only), and ZIP code
#' tabulation area (ZCTA). Data sets are downloaded from the US Census Bureau
#' using the [tidycensus][tc] package.
#'
#' [tc]:https://walker-data.com/tidycensus/index.html
#'
#' @details
#' ACS and census variables can be explored at the [Census Reporter][cr] website
#' or by using [tidycensus::load_variables()] to download variables for a
#' specific data set.
#'
#' GEOIDs can be obtained from US Census Bureau shapefiles or from the data set
#' `geoid` in this package.
#'
#' By default, `state = 29` is included in the call to the relevant tidycensus
#' function.
#'
#' # Additional resources
#'
#' - [Decennial census website][dc]
#' - [American Community Survey website][acs]
#' - [List of US Census Bureau data sets available via API][api]
#' - [Census Reporter][cr] (ACS tables and variables reference)
#'
#' [dc]:https://www.census.gov/programs-surveys/decennial-census.html
#' [acs]:https://www.census.gov/programs-surveys/acs.html
#' [api]:https://api.census.gov/data.html
#' [cr]:https://censusreporter.org/
#'
#' @param dataset The data set to download. Passed to the `dataset` argument in
#' [tidycensus::load_variables()] and either `survey` in [tidycensus::get_acs()]
#' or `sumfile` in [tidycensus::get_decennial()].
#' @param geo The data set geography (summary level).
#' @param year The data set year.
#' @param vars The variables to download. Either a vector of variable names or a
#' regular expression pattern.
#' @param var_match Use `"fixed"` to match variable names in `vars` exactly or
#' `"regex"` to match them to a regular expression pattern.
#' @param geoids A vector of GEOIDs to filter the output.
#' @param ... Additional arguments passed to [tidycensus::get_acs()] or
#' [tidycensus::get_decennial()], such as `key` for the user's census API key.
#'
#' @returns A dataframe.
#' @export
#'
#' @examples
#' \dontrun{
#' # Download place-level data from the 2024 1-year ACS
#' acs1_2024_place <- get_kc_pop(
#'   dataset = "acs1",
#'   geo = "place",
#'   year = 2024,
#'   vars = "^B01",
#'   var_match = "regex",
#'   geoids = geoid$place,
#'   key = keyring::key_get("census-api-key")
#' )
#'
#' # Download ZCTA-level data from the 2023 5-year ACS
#' acs5_2023_zcta <- get_kc_pop(
#'   dataset = "acs5",
#'   geo = "zcta",
#'   year = 2023,
#'   vars = "B01001_001",
#'   var_match = "fixed",
#'   geoids = geoid$zcta2020,
#'   key = keyring::key_get("census-api-key")
#' )
#'
#' # Download census block-level data from the 2020 census
#' block <- get_kc_sf(
#'   geo = "block",
#'   year = 2024,
#'   intersect = "city",
#'   geometry = "full"
#' )
#'
#' geoid_block <- block$GEOID20
#'
#' census_2020_block <- get_kc_pop(
#'   dataset = "dhc",
#'   geo = "block",
#'   year = 2020,
#'   vars = "P12_001N",
#'   var_match = "fixed",
#'   geoids = geoid_block,
#'   county = sub("^29", "", geoid$county),
#'   key = keyring::key_get("census-api-key")
#' )
#' }
#'
get_kc_pop <- function(
  dataset,
  geo = c("place", "county", "tract", "block group", "block", "zcta"),
  year,
  vars,
  var_match = c("fixed", "regex"),
  geoids = NULL,
  ...
) {
  geo <- match.arg(geo)

  var_match <- match.arg(var_match)

  # Get variable table
  vtbl <- get_pop_vars(year, dataset)

  # Filter table using `vars`
  if (var_match == "fixed") {
    vtbl <- vtbl[which(vtbl$name %in% vars), ]
  } else if (var_match == "regex") {
    vtbl <- vtbl[grepl(vars, vtbl$name), ]
  }

  # Rename column in `vtbl`
  names(vtbl) <- sub("name", "variable", names(vtbl))

  if (grepl("acs", dataset)) {
    # Arguments for `get_pop_acs()`
    args <- list(
      survey = dataset,
      geography = geo,
      year = year,
      variables = vtbl$variable,
      state = 29,
      ...
    )

    if (geo == "zcta") {
      # Add `zcta` argument to `args`
      args <- append(args, list(zcta = geoids))

      # Remove `state` argument conditionally
      if (year > 2019) {
        args <- args[!grepl("state", names(args))]
      }
    }

    # Get ACS data
    df <- get_pop_acs(args)

    # Filter data by GEOID
    if (geo != "zcta" & !is.null(geoids)) {
      df <- df[df$GEOID %in% geoids, ]
    }
  } else {
    # Arguments for `get_pop_dec()`
    args <- list(
      sumfile = dataset,
      geography = geo,
      year = year,
      variables = vtbl$variable,
      state = 29,
      ...
    )

    if (geo %in% c("county", "tract", "block group", "block")) {
      # Add `county` argument to `args`
      args <- append(args, list(county = c("037", "047", "095", "165")))
    }

    # Get decennial census data
    df <- get_pop_dec(args)

    # Filter data by GEOID
    if (!is.null(geoids)) {
      df <- df[df$GEOID %in% geoids, ]
    }
  }

  # Join variable details from `vtbl`
  df$row_order <- 1:nrow(df)

  df <- merge(df, vtbl, by = "variable")

  cols <- colnames(vtbl)[2:ncol(vtbl)]

  if (grepl("acs", dataset)) {
    cols <- c("GEOID", "NAME", "variable", "estimate", "moe", cols)
  } else {
    cols <- c("GEOID", "NAME", "variable", "value", cols)
  }

  df <- df[order(df$row_order), cols]

  rownames(df) <- NULL

  df
}

get_pop_vars <- function(year, dataset) {
  tidycensus::load_variables(year = year, dataset = dataset)
}

get_pop_acs <- function(arg_list) {
  do.call(tidycensus::get_acs, arg_list)
}

get_pop_dec <- function(arg_list) {
  do.call(tidycensus::get_decennial, arg_list)
}
