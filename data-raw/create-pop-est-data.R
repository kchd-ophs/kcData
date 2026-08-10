# Create population estimates datasets

library(tidyverse)

# Intercensal population estimates, 2010-2020
# https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2010-2020-cities.html

ic <- readxl::read_excel("data-raw/sub-ip-est2020int-pop-29.xlsx", skip = 3)

colnames(ic)[1] <- "name"

ic <- ic |>
  filter(name == "Kansas City city, Missouri") |>
  select(`2010`:`2019`) |>
  pivot_longer(
    cols = everything(),
    names_to = "year",
    values_to = "estimate"
  )

# Vintage 2024 population estimates
# https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-cities-and-towns.html

vin <- read.csv("data-raw/sub-est2024_29.csv")

colnames(vin) <- tolower(colnames(vin))

vin <- vin |>
  filter(name == "Kansas City city") |>
  select(starts_with("popestimate")) |>
  pivot_longer(
    cols = everything(),
    names_to = "year",
    values_to = "estimate"
  ) |>
  mutate(year = sub("popestimate", "", year))

# Save data

intercensal_estimates_2010_2019 <- ic

vintage_2024_estimates <- vin

usethis::use_data(intercensal_estimates_2010_2019, overwrite = T)
usethis::use_data(vintage_2024_estimates, overwrite = T)
