# Import 2010 place TIGER/Line shapefile and convert to sf

# Source: https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.2010.html#list-tab-790442341

library(sf)

place <- st_read(
  list.files("data-raw/tl_2010_29_place10", "shp$", full.names = TRUE)
)

place <- place[place$PLACEFP10 == "38000", ]

saveRDS(place, "data-raw/2010_place.rds")
