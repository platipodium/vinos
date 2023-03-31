<!--
# SPDX-FileCopyrightText: 2022-2023 NOAA National Centers for Environmental Information
# SPDX-License-Identifier: CC0-1.0
-->

# ETOPO 2022
ETOPO 2022, a global relief model with 15 arc-second resolution seamlessly integrating topographic and bathymetric data. The ETOPO 2022 model uses a combination of numerous airborne lidar, satellite-derived topography, and shipborne bathymetry datasets from U.S. national and global sources. ETOPO 2022 uses bare-earth topographic data from NASAs ICESat-2 and other vetted data sources to independently validate both the input datasets and the final ETOPO 2022 model. ETOPO 2022 is available in "Ice Surface" (top of Antarctic and Greenland ice sheets) and "Bedrock" (base of the ice sheets) versions.

The data is available from

https://data.noaa.gov/metaview/page?xml=NOAA/NESDIS/NGDC/MGG/DEM//iso/xml/etopo_2022.xml&view=getDataView&header=none

# Data extraction

15 arc second resolution equates to 0.004166666667°.  At 1920x720 cells, the lower left corner is (2,53) and the upper right corner is (10,56)

```
ncols        1920
nrows        720
xllcorner    2.000000000000
yllcorner    53.000000000000
cellsize     0.004166666667
````


A GeoTIFF can be retrieved via https://gis.ngdc.noaa.gov/arcgis/rest/services/DEM_mosaics/DEM_all/ImageServer/exportImage?bbox=2.00000,53.00000,10.00000,56.00000&bboxSR=4326&size=1920,720&imageSR=4326&format=tiff&pixelType=F32&interpolation=+RSP_NearestNeighbor&compression=LZ77&renderingRule={%22rasterFunction%22:%22none%22}&mosaicRule={%22where%22:%22Name=%27ETOPO_2022_v1_15s_bed_elev%27%22}&f=image


## Citation

Cite as:NOAA National Centers for Environmental Information. 2022: ETOPO 2022 15 Arc-Second Global Relief Model. NOAA National Centers for Environmental Information. https://doi.org/10.25921/fd45-gt74 . Accessed [date].