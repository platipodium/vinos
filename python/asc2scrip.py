# -*- coding: utf-8 -*-
"""
# This script creates from an ESRII ASC raster data file
# a SCRIP compliant NetCDF file.
#
SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
SPDX-FileCopyrightText: 2014-2021 Helmholtz-Zentrum Geesthacht
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import netCDF4
import sys
import numpy as np
import time


def create_scrip(header, data):
    nlon = int(header["NROWS"])
    nlat = int(header["NCOLS"])
    ll_lon = header["XLLCORNER"]
    ll_lat = header["YLLCORNER"]
    delta_lon = header["CELLSIZE"]
    delta_lat = header["CELLSIZE"]  # always square

    filename = header["NAME"].replace(".asc", "_scrip.nc")

    nc = netCDF4.Dataset(filename, "w", format="NETCDF3_CLASSIC")

    nc.createDimension("grid_size", nlon * nlat)
    nc.createDimension("grid_corners", 4)
    nc.createDimension("grid_rank", 2)

    grid_dims = nc.createVariable("grid_dims", "i4", ("grid_rank"))
    grid_imask = nc.createVariable("grid_imask", "i4", ("grid_size"))

    grid_center_lat = nc.createVariable("grid_center_lat", "f8", ("grid_size"))
    grid_center_lat.units = "degrees"

    grid_center_lon = nc.createVariable("grid_center_lon", "f8", ("grid_size"))
    grid_center_lon.units = "degrees"

    grid_corner_lat = nc.createVariable(
        "grid_corner_lat", "f8", ("grid_size", "grid_corners")
    )
    grid_corner_lat.units = "degrees"

    grid_corner_lon = nc.createVariable(
        "grid_corner_lon", "f8", ("grid_size", "grid_corners")
    )
    grid_corner_lon.units = "degrees"

    var = nc.createVariable(header["VARIABLE"], "f8", ("grid_size"))
    var.units = "unknown"
    var.coordinates = ["grid_center_lon grid_center_lat"]
    var.missing_value = header["NODATA_VALUE"]

    # Meta data
    nc.history = (
        "Created "
        + time.ctime(time.time())
        + " by "
        + sys.argv[0]
        + " from "
        + sys.argv[1]
    )
    nc.creator = "Carsten Lemmen <carsten.lemmen@hereon.de>"
    nc.license = "Creative Commons Attribution Share-Alike (CC-BY-SA 4.0)"
    nc.copyright = "Helmholtz-Zentrum hereon GmBH"
    nc.Conventions = "SCRIP"

    grid_dims[:] = [nlon, nlat]
    grid_imask[:] = 1

    ilon = np.array(range(0, nlon))
    jlat = np.array(range(0, nlat))

    glon = ll_lon + (ilon + 0.5) * delta_lon
    glat = ll_lat + (jlat + 0.5) * delta_lat

    for j in jlat:
        k = ilon + j * nlon
        grid_center_lon[k] = glon
    for i in ilon:
        k = jlat + i * nlat
        grid_center_lat[k] = glat

    grid_corner_lon[:, 0] = grid_center_lon[:] - 0.5 * delta_lon
    grid_corner_lon[:, 1] = grid_center_lon[:] + 0.5 * delta_lon
    grid_corner_lat[:, 0] = grid_center_lat[:] - 0.5 * delta_lat
    grid_corner_lat[:, 2] = grid_center_lat[:] + 0.5 * delta_lat
    grid_corner_lon[:, 2] = grid_corner_lon[:, 1]
    grid_corner_lon[:, 3] = grid_corner_lon[:, 0]
    grid_corner_lat[:, 1] = grid_corner_lat[:, 0]
    grid_corner_lat[:, 3] = grid_corner_lat[:, 2]

    var[:] = data.flatten()
    nc.close()


def asc_reader(filename):
    header_rows = 6  # six rows for header information
    header = {"NAME": filename, "VARIABLE": "var"}
    row_ite = 1

    with open(filename, "rt") as fid:
        for line in fid:
            if row_ite <= header_rows:
                line = line.split(" ", 1)
                header[line[0]] = float(line[1])
            else:
                break

            row_ite = row_ite + 1
    # read data array
    data = np.loadtxt(filename, skiprows=header_rows, dtype="float64")
    return header, data


def main():
    if len(sys.argv) < 2:
        return

    header, data = asc_reader(sys.argv[1])
    create_scrip(header, data)


if __name__ == "__main__":
    main()
