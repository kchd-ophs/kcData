# KC-area GEOIDs

Geographic identifiers (GEOIDs) for the Kansas City area.

## Usage

``` r
geoid2
```

## Format

A list of dataframes.

- state:

  Missouri GEOID

- cbsa:

  Kansas City, KS-MO, GEOID

- place:

  Kansas City GEOID

- county:

  County GEOIDs and county FIPs codes

- tract2011:

  2011 census tract GEOIDs, tract codes, and proportion of area
  overlapping with Kansas City

- tract2020:

  2020 census tract GEOIDs, tract codes, and proportion of area
  overlapping with Kansas City

- zcta2012:

  2012 ZCTA GEOIDs and proportion of area overlapping with Kansas City

- zcta2020:

  2020 ZCTA GEOIDs and proportion of area overlapping with Kansas City

## Source

US Census Bureau TIGER/Line Shapefiles

## Details

Each element of `geoid2` is a dataframe containing area names, if
applicable, and GEOIDs for a given geography level. `place`, `county`,
`tract2011`, and `tract2020` contain the commonly used shorter codes
(i.e., without the state FIPS code) for those levels. `tract2011`,
`tract2020`, `zcta2012`, and `zcta2020` contain a variable `overlap`
which is the proportion of each area within the Kansas City boundary.

See the US Census Bureau web page [Understanding Geographic
Identifiers](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)
for more information on GEOIDs.
