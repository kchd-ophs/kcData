# Get simple features objects for Kansas City

Download a TIGER/Line shapefile for a geography level consisting of
areas that contain or intersect with Kansas City, MO.

## Usage

``` r
get_kc_sf(
  geo = c("cbsa", "place", "county", "tract", "block group", "block", "zcta"),
  year,
  intersect = c("city", "metro"),
  clipped = TRUE
)
```

## Arguments

- geo:

  The shapefile's geography level.

- year:

  The shapefile's year.

- intersect:

  The intersecting geography level. Ignored when `geo` is `"place"` or
  `"cbsa"`.

- clipped:

  Logical: Should clipped or full geometries be returned? Ignored when
  `geo` is `"place"` or `"cbsa"`.

## Value

A dataframe of class `sf` containing a simple feature list column.

## Details

Geography levels smaller than the city (place) or metro region (CBSA)
can contain either full geometries or geometries clipped to an
intersecting geometry (indicated in `intersect`). Two additional
variables are added to these shapefiles: the feature's area and the
portion of the feature's area within the intersecting geometry.

Shapefiles are downloaded from the US Census Bureau using the
[tigris](https://github.com/walkerke/tigris) package.

## Additional resources

- [TIGER/Line Shapefiles and TIGER/Line Files Technical
  Documentation](https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/tiger-geo-line.html)

- [Standard Hierarchy of Census Geographic
  Entities](https://www2.census.gov/geo/pdfs/reference/geodiagram.pdf)

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the 2024 city boundary
city <- get_kc_sf(geo = "place", year = 2024)

# Get 2024 census tracts clipped to the city boundary
tracts <- get_kc_sf(geo = "tract", year = 2024)

# Get full 2024 ZCTAs that intersect with the KC metro region
zctas <- get_kc_sf(
  geo = "zcta",
  year = 2024,
  intersect = "metro",
  clipped = FALSE
)
} # }
```
