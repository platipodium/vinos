<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

# Northsea Fisheries ABM

This Agent-ased model of North Sea fisheries considers action pathways of its primary agents - fishing boats from the German small-vessel fleet - for sustained fishery under global resource change change and fishery exclusion constraints.

## Entitites

- small-vessel fishing boats `breed [boats boat]`
- small-vessel fishing gears `breed [gears gear]`
- resource patches

## Data sources

Spatial data is collected from a variety of sources, among them geospatial contextual data, species distribution data, and fishery landings data.

### Geospatial physical, political, and environmental data

- **Bathymetric data** was obtained 2022-01-07 from GEBCO Compilation Group (2021) GEBCO 2021 Grid (https://doi.org/10.5285/c6612cbe-50b3-0cff-e053-6c86abc09f8f). You can go to https://download.gebco.net to download the data as NetCDF, GeoTIFF, PNG and Esri ASCII.
- EmodNet provides human activities at https://www.emodnet-humanactivities.eu/download-data.php. After providing your country and sector, the **wind farm polygon areas** are freely available.
- The NOAH habitat atlas provides swept area ratio and on simulated chlorophyll
- Roadways are used from Openstreetmap
- National park areas are obtained from NLWKN
- ICES provides statistical rectangles and the plaice box
- Exclusive economic zone ("Duck bill")

### Species probability presences

The data was obtained from Nik Probst, based on Random Forest species distribution modeling for Merlangus, Platessa, Solea, Crangon and Sprattus.

### Image-based processing

Portable Network Graphics (png) images were used with the following projection information:

```
nrows=120
ncols=180
xmin=2
ymin=53
xmax=10
ymax=56
projection=+proj=longlat +datum=WGS84 +no_defs
```

From the NetCDF, the range was restricted to -82 .. 0 m, then exported to `.ps` and further processed via `.pnm` to yield a `.png`. The resulting file was then resampled to 180 x 120 pixels.

## Viable implementation

- Action pathway is gear selection (later target species)
- gear has properties: gear-width => influences catch, gear-drag => influences fuel cost
- after two trips, we compare the value (income - cost)\*value_factor between two trips

## TODO

- Feedback on resource by fishery
- Oil price effect on costs
