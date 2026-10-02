# Make data to test `get_kc_pop()`

devtools::load_all()

# Mocked variable tables
acs1_vars <- data.frame(
  name = "B01003_001",
  label = "Estimate!!Total",
  concept = "TOTAL POPULATION"
)

acs5_vars <- data.frame(
  name = "B01003_001",
  label = "Estimate!!Total",
  concept = "TOTAL POPULATION",
  geography = "block group"
)

census_vars <- data.frame(
  name = "P12_001N",
  label = " !!Total:",
  concept = "SEX BY AGE FOR SELECTED AGE CATEGORIES"
)

# Mocked input data: ACS
df <- data.frame(
  survey = c("acs1", "acs1", rep("acs5", 5)),
  geography = c("place", "place", "place", "county", "tract", "zcta", "zcta"),
  year = c(rep(2021, 6), 2019),
  variables = "B01003_001",
  state = 29,
  key = keyring::key_get("census-api-key")
)

ls <- split(df, 1:nrow(df))

mock1 <- lapply(ls, \(args) {
  if (args$geography == "zcta") {
    if (args$year > 2019) {
      args <- args[!grepl("state", names(args))]
      args <- append(
        args,
        list(zcta = geoid$zcta2020$geoid[geoid$zcta2020$overlap >= .1])
      )
    } else {
      args <- append(
        args,
        list(zcta = geoid$zcta2010$geoid[geoid$zcta2010$overlap >= .1])
      )
    }
  }

  get_pop_acs(args)
})

names(mock1) <- paste0(
  df$survey, "_", df$geography,
  c("_regex", rep("", 4), 1, 2)
)

# Output data: ACS
ls <- list(
  dataset = as.list(c("acs1", "acs1", rep("acs5", 5))),
  geo = list("place", "place", "place", "county", "tract", "zcta", "zcta"),
  year = as.list(c(rep(2021, 6), 2019)),
  vars = as.list(c("^B01003", rep("B01003_001", 6))),
  var_match = as.list(c("regex", rep("fixed", 6))),
  geoids = c(
    as.list(rep(geoid$place$geoid, 3)),
    list(geoid$county$geoid),
    list(geoid$tract2020$geoid[geoid$tract2020$overlap >= .1]),
    list(geoid$zcta2020$geoid[geoid$zcta2020$overlap >= .1]),
    list(geoid$zcta2010$geoid[geoid$zcta2010$overlap >= .1])
  ),
  key = keyring::key_get("census-api-key")
)

out1 <- purrr::pmap(ls, get_kc_pop)

names(out1) <- names(mock1)

# Mocked input data: Census
df <- data.frame(
  sumfile = "dhc",
  geography = c("place", "county", "tract", "zcta"),
  year = 2020,
  variables = "P12_001N",
  state = 29,
  key = keyring::key_get("census-api-key")
)

ls <- split(df, 1:nrow(df))

mock2 <- lapply(ls, get_pop_dec)

names(mock2) <- paste0(df$sumfile, "_", df$geography)

# Output data: Census
ls <- list(
  dataset = "dhc",
  geo = list("place", "county", "tract", "zcta"),
  year = 2020,
  vars = "P12_001N",
  var_match = "fixed",
  geoids = list(
    geoid$place$geoid,
    geoid$county$geoid,
    geoid$tract2020$geoid[geoid$tract2020$overlap >= .1],
    geoid$zcta2020$geoid[geoid$zcta2020$overlap >= .1]
  ),
  key = keyring::key_get("census-api-key")
)

out2 <- purrr::pmap(ls, get_kc_pop)

names(out2) <- names(mock2)

# Save
data <- list(
  mock = c(
    list(acs1_vars = acs1_vars),
    list(acs5_vars = acs5_vars),
    list(census_vars = census_vars),
    mock1, mock2
  ),
  out = c(out1, out2)
)

saveRDS(data, "tests/testthat/fixtures/data_get_kc_pop.rds")
