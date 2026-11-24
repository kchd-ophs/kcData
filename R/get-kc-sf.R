#' Get simple features objects for Kansas City
#'
#' @description
#' Download a TIGER/Line shapefile for a geography level consisting of areas
#' that contain or intersect with Kansas City, MO.
#'
#' @details
#' Geography levels smaller than the city (place) or metro region (CBSA) can
#' contain either full geometries or geometries clipped to an intersecting
#' geometry (indicated in `intersect`). Two additional variables are added to
#' these shapefiles: the feature's area and the portion of the feature's area
#' within the intersecting geometry.
#'
#' Shapefiles are downloaded from the US Census Bureau using the [tigris][tig]
#' package.
#'
#' [tig]:https://github.com/walkerke/tigris
#'
#' # Additional resources
#'
#' - [TIGER/Line Shapefiles and TIGER/Line Files Technical Documentation][tl]
#' - [Standard Hierarchy of Census Geographic Entities][geo]
#'
#' [tl]:https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/tiger-geo-line.html
#' [geo]:https://www2.census.gov/geo/pdfs/reference/geodiagram.pdf
#'
#' @param geo The shapefile's geography level.
#' @param year The shapefile's year.
#' @param intersect The intersecting geography level. Ignored when `geo` is
#' `"place"` or `"cbsa"`.
#' @param clipped Logical: Should clipped or full geometries be returned?
#' Ignored when `geo` is `"place"` or `"cbsa"`.
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
#'   clipped = FALSE
#' )
#' }
#'
get_kc_sf <- function(
  geo = c("cbsa", "place", "county", "tract", "block group", "block", "zcta"),
  year,
  intersect = c("city", "metro"),
  clipped = TRUE
) {
  pkg <- requireNamespace("sf", quietly = TRUE)

  if (!pkg) {
    stop("The sf package must be installed to use this function.")
  }

  year <- as.numeric(year)

  geo <- match.arg(geo)

  intersect <- match.arg(intersect)

  if (!is.logical(clipped) | is.na(clipped)) {
    stop("`clipped` must be `TRUE` or `FALSE`")
  }

  cond1 <- all(!geo %in% c("cbsa", "place"), intersect == "city")

  cond2 <- all(!geo %in% c("cbsa", "place"), intersect == "metro")

  if (geo == "place" | cond1) {
    # Download the Missouri places shapefile
    sf <- get_sf(geo = "place", state = 29, year = year)

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
    co <- c("037", "047", "095", "165")

    sf <- get_sf(geo = geo, state = 29, year = year, county = co)
  } else if (intersect == "metro") {
    ksco <- c("091", "103", "107", "121", "209")

    moco <- c("013", "025", "037", "047", "049", "095", "107", "165", "177")

    sf <- rbind(
      get_sf(geo = geo, state = 20, year = year, county = ksco),
      get_sf(geo = geo, state = 29, year = year, county = moco)
    )
  }

  # Filter for geometries in `sf` that share interior with `parent_sf`
  p <- switch(
    geo,
    county = "^COUNTYFP$",
    tract = "^TRACTCE",
    `block group` = "^BKGPIDFP|^GEOID",
    block = "^BLKIDFP|^GEOID",
    zcta = "^ZCTA5CE"
  )

  # p <- "^GEOID(10|20)?$|IDFP00$|^ZCTA5CE00$"

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

  if (clipped) {
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
