# Get population data for Kansas City

Download population data for Kansas City from the decennial census or
the American Community Survey (ACS). Summary levels are place, county,
census tract, census block group, census block (decennial census only),
and ZIP code tabulation area (ZCTA). Data sets are downloaded from the
US Census Bureau using the
[tidycensus](https://walker-data.com/tidycensus/index.html) package.

## Usage

``` r
get_kc_pop(
  dataset,
  geo = c("place", "county", "tract", "block group", "block", "zcta"),
  year,
  vars,
  var_match = c("fixed", "regex"),
  geoids = NULL,
  ...
)
```

## Arguments

- dataset:

  The data set to download. Passed to the `dataset` argument in
  [`tidycensus::load_variables()`](https://walker-data.com/tidycensus/reference/load_variables.html)
  and either `survey` in
  [`tidycensus::get_acs()`](https://walker-data.com/tidycensus/reference/get_acs.html)
  or `sumfile` in
  [`tidycensus::get_decennial()`](https://walker-data.com/tidycensus/reference/get_decennial.html).

- geo:

  The data set geography (summary level).

- year:

  The data set year.

- vars:

  The variables to download. Either a vector of variable names or a
  regular expression pattern.

- var_match:

  Use `"fixed"` to match variable names in `vars` exactly or `"regex"`
  to match them to a regular expression pattern.

- geoids:

  A vector of GEOIDs to filter the output.

- ...:

  Additional arguments passed to
  [`tidycensus::get_acs()`](https://walker-data.com/tidycensus/reference/get_acs.html)
  or
  [`tidycensus::get_decennial()`](https://walker-data.com/tidycensus/reference/get_decennial.html),
  such as `key` for the user's census API key.

## Value

A dataframe.

## Details

ACS and census variables can be explored at the [Census
Reporter](https://censusreporter.org/) website or by using
[`tidycensus::load_variables()`](https://walker-data.com/tidycensus/reference/load_variables.html)
to download variables for a specific data set.

GEOIDs can be obtained from US Census Bureau shapefiles or from the data
set `geoid` in this package.

By default, `state = 29` is included in the call to the relevant
tidycensus function.

## Additional resources

- [Decennial census
  website](https://www.census.gov/programs-surveys/decennial-census.html)

- [American Community Survey
  website](https://www.census.gov/programs-surveys/acs.html)

- [List of US Census Bureau data sets available via
  API](https://api.census.gov/data.html)

- [Census Reporter](https://censusreporter.org/) (ACS tables and
  variables reference)

## Examples

``` r
if (FALSE) { # \dontrun{
# Download place-level data from the 2024 1-year ACS
acs1_2024_place <- get_kc_pop(
  dataset = "acs1",
  geo = "place",
  year = 2024,
  vars = "^B01",
  var_match = "regex",
  geoids = geoid$place$geoid
)

# Download ZCTA-level data from the 2023 5-year ACS
acs5_2023_zcta <- get_kc_pop(
  dataset = "acs5",
  geo = "zcta",
  year = 2023,
  vars = "B01001_001",
  var_match = "fixed",
  geoids = geoid$zcta2020$geoid[geoid$zcta2020$overlap >= .1]
)

# Download census block-level data from the 2020 census
block <- get_kc_sf(
  geo = "block",
  year = 2024,
  intersect = "city",
  geometry = "full"
)

geoid_block <- block$GEOID20

census_2020_block <- get_kc_pop(
  dataset = "dhc",
  geo = "block",
  year = 2020,
  vars = "P12_001N",
  var_match = "fixed",
  geoids = geoid_block,
  county = geoid$county$county_fips
)
} # }
```
