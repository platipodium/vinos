<!--
# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
-->

# Southern North Sea Coastline

This is a shapefile of the SNS waterbody, generated from the EEA coastline polygon available at 
https://www.eea.europa.eu/data-and-maps/data/eea-coastline-for-analysis-2

The waterbody polygon was generated by 
* adding a domain layer for entire domain North sea and Baltic sea
* subtracting coastline (land polygon) from domain layer resulting in waterbody
* adding a domain layer for only North sea
* clipping waterbody with North sea domain layer