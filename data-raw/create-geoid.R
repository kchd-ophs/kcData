# Create `geoid`

# tigris package website showing the availability of datasets by year:
# https://github.com/walkerke/tigris

library(dplyr)

options(tigris_use_cache = TRUE)

devtools::load_all()

# Function to convert `sf` to dataframe with GEOID and proportion of overlap
config_sf <- function(sf, type = c("tract", "zcta")) {
  if (type == "tract") {
    var <- c(
      colnames(sf)[grepl("^GEOID|^CTIDFP", colnames(sf))],
      colnames(sf)[grepl("^TRACTCE([0-1]0)?$", colnames(sf))]
    )

    var <- setNames(var, c("geoid", "tract_code"))
  } else if (type == "zcta") {
    var <- colnames(sf)[grepl("^ZCTA5", colnames(sf))]

    var <- setNames(var, "geoid")
  }

  sf |>
    sf::st_drop_geometry() |>
    dplyr::select(dplyr::all_of(var), overlap)
}

geoid <- list()

# State
geoid$state <- tribble(
  ~name      , ~geoid ,
  "Missouri" , "29"
)

# CBSA
geoid$cbsa <- tribble(
  ~name                , ~geoid  ,
  "Kansas City, MO-KS" , "28140"
)

# Place
geoid$place <- tribble(
  ~name         , ~geoid    , ~place_fips ,
  "Kansas City" , "2938000" , "38000"
)

# County
geoid$county <- tribble(
  ~name     , ~geoid  , ~county_fips ,
  "Cass"    , "29037" , "037"        ,
  "Clay"    , "29047" , "047"        ,
  "Jackson" , "29095" , "095"        ,
  "Platte"  , "29165" , "165"
)

# Tract
tract2000 <- get_kc_sf(
  geo = "tract",
  year = 2000,
  intersect = "city",
  clipped = FALSE
)

tract2010 <- get_kc_sf(
  geo = "tract",
  year = 2010,
  intersect = "city",
  clipped = FALSE
)

tract2020 <- get_kc_sf(
  geo = "tract",
  year = 2020,
  intersect = "city",
  clipped = FALSE
)

geoid$tract2000 <- config_sf(tract2000, "tract")

geoid$tract2010 <- config_sf(tract2010, "tract")

geoid$tract2020 <- config_sf(tract2020, "tract")

# ZCTA
zcta2000 <- get_kc_sf(
  geo = "zcta",
  year = 2000,
  intersect = "city",
  clipped = FALSE
)

zcta2010 <- get_kc_sf(
  geo = "zcta",
  year = 2010,
  intersect = "city",
  clipped = FALSE
)

zcta2020 <- get_kc_sf(
  geo = "zcta",
  year = 2020,
  intersect = "city",
  clipped = FALSE
)

geoid$zcta2000 <- config_sf(zcta2000, "zcta")

geoid$zcta2010 <- config_sf(zcta2010, "zcta")

geoid$zcta2020 <- config_sf(zcta2020, "zcta")

# Save
usethis::use_data(geoid, overwrite = T)
