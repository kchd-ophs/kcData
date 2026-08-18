test_that("cbsa", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = function(...) data$mock$cbsa)
  act <- get_kc_sf(geo = "cbsa", year = 2024)
  exp <- data$out$cbsa
  expect_equal(act, exp)
})

test_that("place", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = function(...) data$mock$place)
  act <- get_kc_sf(geo = "place", year = 2024)
  exp <- data$out$place
  expect_equal(act, exp)
})

test_that("county city clipped", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$place, data$mock$county_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "county",
      year = 2024,
      intersect = "city",
      geometry = "clipped"
    )
  )
  exp <- data$out$county$city_clipped
  expect_equal(act, exp)
})

test_that("county city full", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$place, data$mock$county_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "county",
      year = 2024,
      intersect = "city",
      geometry = "full"
    )
  )
  exp <- data$out$county$city_full
  expect_equal(act, exp)
})

test_that("zcta city clipped", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$place, data$mock$zcta_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "zcta",
      year = 2024,
      intersect = "city",
      geometry = "clipped"
    )
  )
  exp <- data$out$zcta$city_clipped
  expect_equal(act, exp)
})

test_that("zcta city full", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$place, data$mock$zcta_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "zcta",
      year = 2024,
      intersect = "city",
      geometry = "full"
    )
  )
  exp <- data$out$zcta$city_full
  expect_equal(act, exp)
})

test_that("zcta metro clipped", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$cbsa, data$mock$zcta_ks, data$mock$zcta_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "zcta",
      year = 2024,
      intersect = "metro",
      geometry = "clipped"
    )
  )
  exp <- data$out$zcta$metro_clipped
  expect_equal(act, exp)
})

test_that("county metro full", {
  data <- readRDS(test_path("fixtures", "data_get_kc_sf.rds"))
  local_mocked_bindings(get_sf = mock_output_sequence(
    data$mock$cbsa, data$mock$county_ks, data$mock$county_mo
  ))
  act <- suppressWarnings(
    get_kc_sf(
      geo = "county",
      year = 2024,
      intersect = "metro",
      geometry = "full"
    )
  )
  exp <- data$out$county$metro_full
  expect_equal(act, exp)
})

test_that("place 2010", {
  act <- suppressWarnings(
    get_kc_sf("place", 2010)
  )
  exp <- place2010
  rownames(exp) <- NULL
  expect_equal(act, exp)
})
