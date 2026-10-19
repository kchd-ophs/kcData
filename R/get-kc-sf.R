#' Get simple features objects for Kansas City
#'
#' @description
#' Download a TIGER/Line shapefile containing
#'
#' - the Kansas City city boundary
#' - the Kansas City metro region boundary
#' - a set of smaller geographies intersecting with one of the above: county,
#' census tract, census block group, census block, or ZIP code tabulation area
#' (ZCTA)
#'
#' Shapefiles are downloaded from the US Census Bureau using the [tigris][tig]
#' package.
#'
#' [tig]:https://github.com/walkerke/tigris
#'
#' @details
#' Geographies smaller than the city or metro region can contain the full
#' geometry or geometries clipped to the city or metro region boundary. For
#' these geographies, when `geometry = "clipped"` two additional variables are
#' added for the feature's full area and the area within the city or metro
#' region boundary.
#'
#' # Additional resources
#'
#' - [TIGER/Line Shapefiles and TIGER/Line Files Technical Documentation][tl]
#' - [Standard Hierarchy of Census Geographic Entities][geo]
#' - [tigris package][tig]
#'
#' [tl]:https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/tiger-geo-line.html
#' [geo]:https://www2.census.gov/geo/pdfs/reference/geodiagram.pdf
#' [tig]:https://github.com/walkerke/tigris
#'
#' @param geo The shapefile geography. `"place"` returns the city boundary and
#' `"cbsa"` returns the metro region boundary.
#' @param year The shapefile year.
#' @param intersect If `geo` is not `"place"` or `"cbsa"`, this is the larger
#' geography that determines the intersection for the geography selected in
#' `geo`. If `"metro"` is selected, geographies in both Kansas and Missouri will
#' be  returned.
#' @param geometry If `geo` is not `"place"` or `"cbsa"`, return either the full
#' geometries or geometries clipped to the geography indicated in `intersect`.
#'
#' @returns A dataframe of class `sf` containing a simple feature list column.
#' @export
#'
#' @examples
#' \dontrun{
#' # Get the 2024 city boundary
#' city <- get_kc_sf(geo = "place", year = 2024)
#'
#' # Get 2024 census tracts clipped to the city boundary
#' tracts <- get_kc_sf(geo = "tract", year = 2024)
#'
#' # Get full 2024 ZCTAs that intersect with the KC metro region
#' zctas <- get_kc_sf(
#'   geo = "zcta",
#'   year = 2024,
#'   intersect = "metro",
#'   geometry = "full"
#' )
#' }
#'
get_kc_sf <- function(
  geo = c("cbsa", "place", "county", "tract", "block group", "block", "zcta"),
  year,
  intersect = c("city", "metro"),
  geometry = c("clipped", "full")
) {
  pkg <- requireNamespace("sf", quietly = TRUE)

  if (!pkg) {
    stop("The sf package must be installed to use this function.")
  }

  year <- as.numeric(year)

  geo <- match.arg(geo)

  intersect <- match.arg(intersect)

  geometry <- match.arg(geometry)

  cond1 <- all(!geo %in% c("cbsa", "place"), intersect == "city")

  cond2 <- all(!geo %in% c("cbsa", "place"), intersect == "metro")

  if (geo == "place" | cond1) {
    # Download the Missouri places shapefile
    if (year == 2010) {
      sf <- place2010
    } else {
      sf <- get_sf(geo = "place", state = 29, year = year)
    }

    # Filter for the KC boundary
    sf <- sf[which(sf$PLACEFP == "38000"), ]
  } else if (geo == "cbsa" | cond2) {
    # Download the CBSA shapefile
    sf <- get_sf(geo = "cbsa", year = year)

    # Filter for the KC metro boundary
    sf <- sf[which(grepl("Kansas City", sf$NAME)), ]
  }

  rownames(sf) <- NULL

  if (geo %in% c("cbsa", "place")) {
    return(sf)
  } else {
    parent_sf <- sf
  }

  # Download a smaller geography
  if (intersect == "city") {
    sf <- get_sf(
      geo = geo,
      state = 29, # MO only
      year = year,
      county = c("037", "047", "095", "165")
    )
  } else if (intersect == "metro") {
    ksco <- c("091", "103", "107", "121", "209")

    moco <- c("013", "025", "037", "047", "049", "095", "107", "165", "177")

    sf <- rbind(
      get_sf(geo = geo, state = 20, year = year, county = ksco),
      get_sf(geo = geo, state = 29, year = year, county = moco)
    )
  }

  # Filter for geometries in `sf` that share interior with `parent_sf`
  p <- "^GEOID(10|20)?$|IDFP00$|^ZCTA5CE00$"

  id_var <- colnames(sf)[grepl(p, colnames(sf))]

  sf <- filter_shared_interior(
    x = sf,
    y = parent_sf,
    var = id_var
  )

  var <- paste0(intersect, "_area")

  cols <- colnames(sf)

  # Get the area of each geometry
  sf$area <- sf::st_area(sf)

  # Clip `sf` using `parent_sf`
  sf_clp <- clip_sf(parent_sf, sf)

  if (geometry == "clipped") {
    sf <- sf_clp
  }

  # Get the area of the intersecting portion
  sf[[var]] <- sf::st_area(sf_clp)

  # Filter out geometries with an intersection area of 0
  sf <- sf[as.numeric(sf[[var]]) != 0, ]

  # Find the proportion of overlap for each geometry
  sf$overlap <- as.numeric(sf[[var]] / sf$area)

  cols <- c(
    cols[!cols %in% "geometry"],
    "area",
    var,
    "overlap",
    "geometry"
  )

  rownames(sf) <- NULL

  sf[, cols]
}

get_sf <- function(geo, state = NULL, year = NULL, county = NULL) {
  if (geo == "cbsa") {
    tigris::core_based_statistical_areas(year = year)
  } else if (geo == "place") {
    tigris::places(state = state, year = year)
  } else if (geo == "county") {
    tigris::counties(state = state, year = year)
  } else if (geo == "tract") {
    tigris::tracts(state = state, year = year)
  } else if (geo == "block group") {
    tigris::block_groups(state = state, county = county, year = year)
  } else if (geo == "block") {
    tigris::blocks(state = state, county = county, year = year)
  } else if (geo == "zcta") {
    sw <- if (state == 29) {
      as.character(63:65)
    } else if (state == 20) {
      as.character(66:67)
    } else {
      NULL
    }

    tigris::zctas(starts_with = sw, year = year)
  }
}

filter_shared_interior <- function(x, y, var) {
  x1 <- sf::st_filter(x, y, .predicate = sf::st_intersects)

  x2 <- sf::st_filter(x, y, .predicate = sf::st_touches)

  x1[!x1[[var]] %in% x2[[var]], ]
}

clip_sf <- function(x, y) {
  y <- sf::st_intersection(x[, "geometry"], y)

  sf::st_make_valid(y)
}
