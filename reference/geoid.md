# Geographic identifiers

US Census Bureau geographic identifiers (GEOIDs) for areas that
intersect with Kansas City at several levels of geography.

## Usage

``` r
geoid
```

## Format

A list containing 10 dataframes.

- state:

  GEOID for Missouri

- cbsa:

  GEOID for Kansas City, KS-MO (core based statistical area)

- place:

  GEOID and place FIPS code for Kansas City

- county:

  GEOIDs and county FIPS codes for counties intersecting with Kansas
  City

- tract2000:

  GEOIDs, tract codes, and proportion of overlap for census tracts
  intersecting with Kansas City in 2000

- tract2010:

  GEOIDs, tract codes, and proportion of overlap for census tracts
  intersecting with Kansas City in 2010

- tract2020:

  GEOIDs, tract codes, and proportion of overlap for census tracts
  intersecting with Kansas City in 2020

- zcta2000:

  GEOIDs and proportion of overlap for ZIP code tabulation areas
  intersecting with Kansas City in 2000

- zcta2010:

  GEOIDs and proportion of overlap for ZIP code tabulation areas
  intersecting with Kansas City in 2010

- zcta2020:

  GEOIDs and proportion of overlap for ZIP code tabulation areas
  intersecting with Kansas City in 2020

## Source

US Census Bureau TIGER/Line Shapefiles

## Details

Each element of `geoid` is a dataframe containing GEOIDs for areas
intersecting with Kansas City within a given geography level. When a
smaller portion of the GEOID is commonly used, that code is included.
For census tracts and ZCTAs, the proportion of each area that overlaps
with Kansas City is included.

See the US Census Bureau web page [Understanding Geographic
Identifiers](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)
for more information on GEOIDs.
