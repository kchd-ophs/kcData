# Create `geoid2`

# tigris package website showing the availability of datasets by year:
# https://github.com/walkerke/tigris

library(dplyr)

options(tigris_use_cache = TRUE)

devtools::load_all()

# Function to convert sf to dataframe with GEOID and proportion of overlap
config_sf <- function(sf) {
  var <- c(
    "geoid" = colnames(sf)[grepl("^GEOID(10|20)?$", colnames(sf))],
    "tract_code" = "TRACTCE"
  )

  sf |>
    sf::st_drop_geometry() |>
    mutate(overlap = as.numeric(city_area / area)) |>
    select(any_of(var), overlap)
}

geoid <- list()

# State
geoid$state <- tribble(
  ~name, ~geoid,
  "Missouri", "29"
)

# CBSA
geoid$cbsa <- tribble(
  ~name, ~geoid,
  "Kansas City, MO-KS", "28140"
)

# Place
geoid$place <- tribble(
  ~name, ~geoid, ~place_fips,
  "Kansas City", "2938000", "38000"
)

# County
geoid$county <- tribble(
  ~name, ~geoid, ~county_fips,
  "Cass", "29037", "037",
  "Clay", "29047", "047",
  "Jackson", "29095", "095",
  "Platte", "29165",  "165"
)

# Tract
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

geoid$tract2011 <- tract2011

geoid$tract2020 <- tract2020

# ZCTA
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

geoid$zcta2012 <- zcta2012

geoid$zcta2020 <- zcta2020

geoid2 <- geoid

# Save
usethis::use_data(geoid2, overwrite = T)
