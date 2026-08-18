# Geographic identifiers (GEOIDs)

Geographic identifiers (GEOIDs) for Kansas City and other intersecting
regions. For census tracts and ZCTAs, GEOIDs are included if 10% or more
of a geometry's area is within the Kansas City boundary. See the US
Census Bureau page [Understanding Geographic
Identifiers](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)
for more information on GEOIDs.

## Usage

``` r
geoid
```

## Format

A list of character vectors containing GEOIDs

- state:

  2-digit state FIPS code

- cbsa:

  5-digit core-based statistical area code

- place:

  2-digit state FIPS code and 5-digit place FIPS code

- county:

  2-digit state FIPS code and 3-digit county FIPS code

- tract2010:

  2-digit state FIPS code, 3-digit county FIPS code, and 6-digit census
  tract code, 2010-2019

- tract2020:

  2-digit state FIPS code, 3-digit county FIPS code, and 6-digit census
  tract code, 2020-2024

- zcta2010:

  5-digit ZIP code tabulation area code, 2010-2019

- zcta2020:

  5-digit ZIP code tabulation area code, 2020-2024

## Source

US Census Bureau TIGER/Line Shapefiles
