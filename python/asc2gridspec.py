# -*- coding: utf-8 -*-
"""
This script creates from an ESRII ASC raster data file
a GRIDSPEC compliant NetCDF file.

SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
SPDX-FileCopyrightText: 2014-2021 Helmholtz-Zentrum Geesthacht
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import netCDF4
import sys
import numpy as np
import time

def create_gridspec(header, data):

    nlon = int(header["NCOLS"])
    nlat = int(header["NROWS"])
    ll_lon = header["XLLCORNER"]
    ll_lat = header["YLLCORNER"]
    delta_lon = header["CELLSIZE"]
    delta_lat = header["CELLSIZE"] # always square
    missing_value = header["NODATA_VALUE"]

    filename  = header["NAME"].replace(".asc", "_gridspec.nc")

    nc=netCDF4.Dataset(filename,'w',format='NETCDF3_CLASSIC')

    nc.createDimension('bound',2)
    nc.createDimension('lon',nlon)
    nc.createDimension('lat',nlat)

    lon = nc.createVariable('lon','f8',('lon'))
    lon.bounds='lon_bnds'
    lon.units='degree_east'
    lon.long_name='longitude'
    lon.standard_name='longitude'

    lon_bnds = nc.createVariable('lon_bnds','f8',('lon','bound'))

    lat = nc.createVariable('lat','f8',('lat'))
    lat.bounds='lat_bnds'
    lat.units='degree_north'
    lat.long_name='latitude'
    lat.standard_name='latitude'

    lat_bnds = nc.createVariable('lat_bnds','f8',('lat','bound'))

    # Meta data
    nc.Conventions = "CF-1.8"
    nc.history = "Created " + time.ctime(time.time()) + " by " + sys.argv[0] + " from " + sys.argv[1]
    nc.creator = "Carsten Lemmen <carsten.lemmen@hereon.de>"
    nc.license = "Creative Commons Attribution (CC-BY 4.0)"
    nc.copyright = '2023 Helmholtz-Zentrum hereon GmbH, 2021-2023 International Council for the Exploration of the Seas (ICES)'
    nc.institution_id = 'https://ror.org/03qjp1d79, https://ror.org/03hg53255',

    ilon=np.array(range(0,nlon))
    jlat=np.array(range(0,nlat))

    lon[:]=ll_lon+(ilon+0.5)*delta_lon
    lon_bnds[:,0]=lon[:]-0.5*delta_lon
    lon_bnds[:,1]=lon[:]+0.5*delta_lon

    lat[:]=np.flip(ll_lat+(jlat+0.5)*delta_lat)
    lat_bnds[:,0]=lat[:]-0.5*delta_lat
    lat_bnds[:,1]=lat[:]+0.5*delta_lat

    var = nc.createVariable(header["VARIABLE"],'f4',('lat','lon'))
    var.coordinates='lon lat'
    var.units=''
    var.missing_value = missing_value
    var[:] = data

    nc.close()

def asc_reader(filename):

    header_rows = 6 # six rows for header information
    header = {"NAME": filename, "VARIABLE": "var"}
    row_ite = 1

    with open(filename, 'rt') as fid:
      for line in fid:
        if row_ite <= header_rows:
          line = line.split(" ", 1)
          header[line[0]] = float(line[1])
        else:
          break

        row_ite = row_ite+1
    # read data array
    data  = np.loadtxt(filename, skiprows=header_rows, dtype='float64')
    return header, data

def main():
    if len(sys.argv) < 2: return

    header, data = asc_reader(sys.argv[1])
    create_gridspec(header, data)

if __name__ == "__main__":
    main()
