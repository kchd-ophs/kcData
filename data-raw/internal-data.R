place2010 <- readRDS("data-raw/2010_place.rds")
load("data/geoid.rda")

usethis::use_data(
  geoid,
  place2010,
  internal = TRUE,
  overwrite = TRUE
)
