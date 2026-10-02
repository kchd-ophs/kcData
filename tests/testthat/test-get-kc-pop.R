test_that("acs1 place regex", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs1_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs1_place_regex)
  act <- get_kc_pop(
    dataset = "acs1",
    geo = "place",
    year = 2021,
    vars = "^B01003",
    var_match = "regex",
    geoids = geoid$place
  )
  exp <- data$out$acs1_place_regex
  expect_equal(act, exp)
})

test_that("acs1 place fixed", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs1_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs1_place)
  act <- get_kc_pop(
    dataset = "acs1",
    geo = "place",
    year = 2021,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$place
  )
  exp <- data$out$acs1_place
  expect_equal(act, exp)
})

test_that("acs5 place", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs5_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs5_place)
  act <- get_kc_pop(
    dataset = "acs5",
    geo = "place",
    year = 2021,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$place
  )
  exp <- data$out$acs5_place
  expect_equal(act, exp)
})

test_that("acs5 county", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs5_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs5_county)
  act <- get_kc_pop(
    dataset = "acs5",
    geo = "county",
    year = 2021,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$county$geoid
  )
  exp <- data$out$acs5_county
  expect_equal(act, exp)
})

test_that("acs5 tract", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs5_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs5_tract)
  act <- get_kc_pop(
    dataset = "acs5",
    geo = "tract",
    year = 2021,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$tract2020$geoid[geoid$tract2020$overlap >= .1]
  )
  exp <- data$out$acs5_tract
  expect_equal(act, exp)
})

test_that("acs5 zcta", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs5_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs5_zcta1)
  act <- get_kc_pop(
    dataset = "acs5",
    geo = "zcta",
    year = 2021,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$zcta2020$geoid
  )
  exp <- data$out$acs5_zcta1
  expect_equal(act, exp)
})

test_that("acs5 zcta 2019", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$acs5_vars)
  local_mocked_bindings(get_pop_acs = function(...) data$mock$acs5_zcta2)
  act <- get_kc_pop(
    dataset = "acs5",
    geo = "zcta",
    year = 2019,
    vars = "B01003_001",
    var_match = "fixed",
    geoids = geoid$zcta2010$geoid[geoid$zcta2010$overlap >= .1]
  )
  exp <- data$out$acs5_zcta2
  expect_equal(act, exp)
})

test_that("dhc place", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$census_vars)
  local_mocked_bindings(get_pop_dec = function(...) data$mock$dhc_place)
  act <- get_kc_pop(
    dataset = "dhc",
    geo = "place",
    year = 2020,
    vars = "P12_001N",
    var_match = "fixed",
    geoids = geoid$place$geoid
  )
  exp <- data$out$dhc_place
  expect_equal(act, exp)
})

test_that("dhc county", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$census_vars)
  local_mocked_bindings(get_pop_dec = function(...) data$mock$dhc_county)
  act <- get_kc_pop(
    dataset = "dhc",
    geo = "county",
    year = 2020,
    vars = "P12_001N",
    var_match = "fixed",
    geoids = geoid$county$geoid
  )
  exp <- data$out$dhc_county
  expect_equal(act, exp)
})

test_that("dhc tract", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$census_vars)
  local_mocked_bindings(get_pop_dec = function(...) data$mock$dhc_tract)
  act <- get_kc_pop(
    dataset = "dhc",
    geo = "tract",
    year = 2020,
    vars = "P12_001N",
    var_match = "fixed",
    geoids = geoid$tract2020$geoid[geoid$tract2020$overlap >= .1]
  )
  exp <- data$out$dhc_tract
  expect_equal(act, exp)
})

test_that("dhc zcta", {
  data <- readRDS(test_path("fixtures", "data_get_kc_pop.rds"))
  local_mocked_bindings(get_pop_vars = function(...) data$mock$census_vars)
  local_mocked_bindings(get_pop_dec = function(...) data$mock$dhc_zcta)
  act <- get_kc_pop(
    dataset = "dhc",
    geo = "zcta",
    year = 2020,
    vars = "P12_001N",
    var_match = "fixed",
    geoids = geoid$zcta2020$geoid[geoid$zcta2020$overlap >= .1]
  )
  exp <- data$out$dhc_zcta
  expect_equal(act, exp)
})
