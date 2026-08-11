# Create `geoid`

# Get GEOIDs for regions of Kansas City. For census tracts and ZCTAs, GEOIDs are
# included if 10% or more of their area is within the Kansas City boundary.

# tigris package website showing the availability of datasets by year:
# https://github.com/walkerke/tigris

options(tigris_use_cache = TRUE)

devtools::load_all()

config_sf <- function(sf) {
  var <- colnames(sf)[grepl("^GEOID(10|20)?$", colnames(sf))]

  sf |>
    sf::st_drop_geometry() |>
    dplyr::mutate(frac = as.numeric(city_area / area)) |>
    dplyr::filter(frac >= .1) |>
    dplyr::pull(.data[[var]]) |>
    sort()
}

geoid <- list()

# State
geoid$state <- c("Missouri" = "29")

# CBSA
geoid$cbsa <- c("Kansas City, MO-KS Metro Area" = "28140")

# Place
geoid$place <- c("Kansas City" = "2938000")

# County
geoid$county <- c(
  "Cass" = "29037",
  "Clay" = "29047",
  "Jackson" = "29095",
  "Platte" = "29165"
)

# Tract
# yr <- 2011:2024
#
# sftract <- lapply(yr, \(x) {
#   get_kc_sf("tract", x, "city", "clipped")
# })
#
# names(sftract) <- paste0("tract", yr)
#
# idtract <- lapply(sftract, get_geoids)
#
# df <- setmeup::batch_compare(idtract)

tract2011 <- get_kc_sf(
  geo = "tract",
  year = 2011,
  intersect = "city",
  geometry = "clipped"
)

tract2011 <- config_sf(tract2011)

tract2020 <- get_kc_sf(
  geo = "tract",
  year = 2020,
  intersect = "city",
  geometry = "clipped"
)

tract2020 <- config_sf(tract2020)

geoid$tract2010 <- tract2011

geoid$tract2020 <- tract2020

# ZCTA
# yr <- 2012:2024
#
# sfzcta <- lapply(yr, \(x) {
#   get_kc_sf("zcta", x, "city", "clipped")
# })
#
# names(sfzcta) <- paste0("zcta", yr)
#
# idzcta <- lapply(sfzcta, get_geoids)
#
# df <- setmeup::batch_compare(idzcta)

zcta2012 <- get_kc_sf(
  geo = "zcta",
  year = 2012,
  intersect = "city",
  geometry = "clipped"
)

zcta2012 <- config_sf(zcta2012)

zcta2020 <- get_kc_sf(
  geo = "zcta",
  year = 2020,
  intersect = "city",
  geometry = "clipped"
)

zcta2020 <- config_sf(zcta2020)

geoid$zcta2010 <- zcta2012

geoid$zcta2020 <- zcta2020

# Save
usethis::use_data(geoid, overwrite = T)
