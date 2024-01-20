# SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de

.PHONY: all

all: download unzip

download: etopo_2022_15s.tiff

etopo_2022_15s.tiff:
	curl --output $@ 'https://gis.ngdc.noaa.gov/arcgis/rest/services/DEM_mosaics/DEM_all/ImageServer/exportImage?bbox=2.00000,53.00000,10.00000,56.00000&bboxSR=4326&size=1920,720&imageSR=4326&format=tiff&pixelType=F32&interpolation=+RSP_NearestNeighbor&compression=LZ77&renderingRule={%22rasterFunction%22:%22none%22}&mosaicRule={%22where%22:%22Name=%27ETOPO_2022_v1_15s_bed_elev%27%22}&f=image'

clean:
	@rm -f etopo_2022_15s.tiff
