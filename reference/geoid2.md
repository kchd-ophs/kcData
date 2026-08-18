# Geographic identifiers

US Census Bureau geographic identifiers (GEOIDs) for areas that
intersect with Kansas City at several levels of geography.

## Usage

``` r
geoid2
```

## Format

A list containing 8 dataframes.

- state:

  GEOID for Missouri

- cbsa:

  GEOID for Kansas City, KS-MO (core based statistical area)

- place:

  GEOID for Kansas City

- county:

  GEOIDs for counties intersecting with Kansas City

- tract2010:

  GEOIDs for census tracts intersecting with Kansas City (2010)

- tract2020:

  GEOIDs for census tracts intersecting with Kansas City (2020)

- zcta2010:

  GEOIDs for ZIP code tabulation areas intersecting with Kansas City
  (2010)

- zcta2020:

  GEOIDs for ZIP code tabulation areas intersecting with Kansas City
  (2020)

## Source

US Census Bureau TIGER/Line Shapefiles

## Details

Each element of `geoid2` is a dataframe containing GEOIDs for the areas
within a given geography level that intersect with Kansas City.
Additional details are included when available, such as area names, or
useful, such as county FIPS or census tract codes. For census tracts and
ZCTAs, the proportion of each area that overlaps with Kansas City is
included.

See the US Census Bureau web page [Understanding Geographic
Identifiers](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)
for more information on GEOIDs.
