# Create `geoid2`

# tigris package website showing the availability of datasets by year:
# https://github.com/walkerke/tigris

library(dplyr)

options(tigris_use_cache = TRUE)

devtools::load_all()

# Function to convert sf to dataframe with GEOID and proportion of overlap
config_sf <- function(sf) {
  var <- c(
    "geoid" = colnames(sf)[grepl("^ZCTA5|^GEOID(10|20)?$", colnames(sf))][1],
    "tract_code" = "TRACTCE",
    "tract_code" = "TRACTCE10"
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
tract2010 <- get_kc_sf(
  geo = "tract",
  year = 2010,
  intersect = "city",
  geometry = "clipped"
)

tract2010 <- config_sf(tract2010)

tract2020 <- get_kc_sf(
  geo = "tract",
  year = 2020,
  intersect = "city",
  geometry = "clipped"
)

tract2020 <- config_sf(tract2020)

geoid$tract2010 <- tract2010

geoid$tract2020 <- tract2020

# ZCTA
zcta2010 <- get_kc_sf(
  geo = "zcta",
  year = 2010,
  intersect = "city",
  geometry = "clipped"
)

zcta2010 <- config_sf(zcta2010)

zcta2020 <- get_kc_sf(
  geo = "zcta",
  year = 2020,
  intersect = "city",
  geometry = "clipped"
)

zcta2020 <- config_sf(zcta2020)

geoid$zcta2010 <- zcta2010

geoid$zcta2020 <- zcta2020

geoid2 <- geoid

# Save
usethis::use_data(geoid2, overwrite = T)
