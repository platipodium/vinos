<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

# ICES data

## Statistical rectangles

ICES reporting occurs on statistical rectangles, here available as `.shp` shapefiles.

## Fishing intensity

Spatial data on fishing intensity can be obtained from
https://ices-library.figshare.com/articles/dataset/Data_for_OSPAR_request_on_the_production_of_spatial_data_layers_of_fishing_intensity_pressure/18601508 under a CC-by-4.0 license.

> ICES. 2021. Data for OSPAR request on the production of spatial data layers of fishing intensity/pressure. Data Outputs. https://doi.org/10.17895/ices.data.8294

This is 400 Mb download containing annual data 2013-2020, resolved by metier. In the subfolder `simple features`, the data is available is `.csv`, resolved by metier, or aggregated to fishery type and total.

The metier layers available are: OT_CRU, OT_DMF, OT_MIX, OT_MIX_CRU, OT_MIX_DMF_BEN, OT_MIX_DMF_PEL, OT_MIX_CRU_DMF, OT_SPF, TBB_CRU, TBB_DMF, TBB_MOL, DRB_MOL, SDN_DMF, SSC_DMF.

The layers considered sensitive by WGSFDGOV and aggregated up to two vessels or more/c-square were: total weight, total value, kW fishing hours, fishing hours.
The layers that were not considered sensitive and thus were not classified in cases where fewer than three vessels/c-square were present were: surface area in km2 (swept-area), surface area ratio, subsurface area in km2 (swept-area), subsurface area ratio. Subsurface is ≥ 2 cm penetration depth of the gear components.

The `.csv` contains the following header:

``
Year,C-square,lat,lon,fishingCategory,subsurface,surface,sar,subsar,kWH_low,kWH_upp,kWH_cov,Hour_low,Hour_upp,Hour_cov,TotWt_low,TotWt_upp,TotWt_cov,TotVal_low,TotVal_upp,TotVal_cov,wkt

```

and can be processed with `python/csquare2asc.py` to produce NetLogo-readable input.
```
