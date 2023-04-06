<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH

SPDX-License-Identifier: CC0-1.0
-->

This directory contains graphical elements used in the NetLogo model and its documentations

## Image-based processing 

Portable Network Graphics (png) images were used with the following projection information to fit to the 
geospatial environment of the model. 

```
nrows=120
ncols=180
xmin=2
ymin=53
xmax=10
ymax=56
projection=+proj=longlat +datum=WGS84 +no_defs
```

From a NetCDF, the range was restricted to -82 .. 0 m, then exported to `.ps` and further processed via `.pnm` to yield a `.png`.  The resulting file was then resampled to 180 x 120 pixels.

## Flowchart

The flowchart was generated from a miro, publicly available at https://miro.com/app/board/o9J_lr2i62o=/


