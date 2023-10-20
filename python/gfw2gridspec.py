# -*- coding: utf-8 -*-
"""
This script extracts from Global Fishery Watch (gfw)
the data for the North Sea and saves as gridspec netCDF

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>


Table Schema
 - date: Date in YYYY-MM-DD format
 - cell_ll_lat: the latitude of the lower left corner of the grid cell, in decimal degrees
 - cell_ll_lon: the longitude of the lower left corner of the grid cell, in decimal degrees
 - flag: flag state, in iso3 format
 - geartype: geartype, see above description of gear types
 - hours: hours that vessels of this gear type and flag were present in this gridcell on this day
 - fishing_hours: hours that vessels of this geartype and flag were fishing in this grid cell on this day
 - mmsi_present: number of MMSI of this flag state and geartype that visited this grid cell on this day

"""

import netCDF4
import sys
import numpy as np
import time
import pandas as pd
import pathlib
import datetime
from tqdm import tqdm
import pyarrow

bbox = (3, 53 , 10, 56)

def create_gridspec(df, filename: pathlib.Path, ires=np.nan):

    if ires == np.nan: ires = 100
    res = 1/ires

    fill_value = -9999.0

    df['lon'] = df["cell_ll_lon"] + 0.01 / 2
    df['lat'] = df["cell_ll_lat"] + 0.01 / 2

    n = len(df)
    if (n<1) : return

    ll_lon, ll_lat, ur_lon, ur_lat = bbox

    nlon = int(round((ur_lon - ll_lon) / res))
    nlat = int(round((ur_lat - ll_lat) / res))

    filename  =  pathlib.Path(filename.stem + "_" + str(ires) + "_gridspec.nc")

    nc=netCDF4.Dataset(filename,'w',format='NETCDF4')

    nc.createDimension('time',0)
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
    nc.history = "Created " + time.ctime(time.time()) + " by " + sys.argv[0] #+ " from " + sys.argv[1]
    nc.creator = "Carsten Lemmen <carsten.lemmen@hereon.de>"
    nc.license = "Creative Commons Attribution Share-Alike (CC-BY-SA 4.0)"
    nc.copyright = "Global Fishing Watch"
    nc.Conventions = "CF-1.7"

    ilon=np.array(range(0,nlon))
    jlat=np.array(range(0,nlat))

    lon[:]=ll_lon+(ilon+0.5)*res
    lon_bnds[:,0]=lon[:]-0.5*res
    lon_bnds[:,1]=lon[:]+0.5*res

    lat[:]=ll_lat+(jlat+0.5)*res
    lat_bnds[:,0]=lat[:]-0.5*res
    lat_bnds[:,1]=lat[:]+0.5*res

    # define the index
    df["ilon"] = np.round((df["lon"] - res / 2 - ll_lon) / res).astype(int)
    df["ilat"] = np.round((df["lat"] - res / 2 - ll_lat) / res).astype(int)

    years = df["year"].unique()

    year = nc.createVariable('time','f8',('time'))
    year.units=f'year'
    year.standard_name='year'
    year[:] = years

    var = nc.createVariable('fishing_hours','f4',('time','lat','lon'), fill_value=fill_value)
    var.coordinates='lon lat'
    var.units='h'

    var = nc.createVariable('fishing_hours_de','f4',('time','lat','lon'), fill_value=fill_value)
    var.coordinates='lon lat'
    var.units='h'

    ddf = df[df["flag"] == "DEU"]

    glon, glat = np.meshgrid(lon[:], lat[:])

    asc_header = {'NCOLS': nlon, 'NROWS': nlat, 'XLLCORNER': ll_lon, 'YLLCORNER': ll_lat,
              'CELLSIZE': res, 'NODATA_VALUE': fill_value}

    license = {'History': f'Created {time.ctime(time.time())}  by {sys.argv[0]}',
              'SPDX-FileContributor': 'Carsten Lemmen <carsten.lemmen@hereon.de',
              'SPDX-FileCopyrightText': '2023 Global Fishery Watch',
              'SPDX-License-Identifier': 'CC-BY-4.0',
              'Units': 'h',
    }


    for y, year in enumerate(years):
        tdf = df[df["year"] == year].groupby(['ilon', 'ilat']).agg({'fishing_hours': 'sum'}).reset_index()

        if len(tdf) < 1: continue

        print(f"... in year {year} with {len(tdf)} data points")

        gvar = np.zeros_like(glon) #+ fill_value
        indices = np.column_stack((tdf["ilat"].values, tdf["ilon"].values))
        gvar[indices[:, 0], indices[:, 1]] = tdf["fishing_hours"].values
        nc.variables.get(f'fishing_hours')[y,:,:] = gvar

        # Add writing of ESRCII asc file
        asc_filename  =  pathlib.Path(filename.stem + "_" + str(y) + "_" + str(ires) + ".asc")
        with open(asc_filename, 'w') as fid:
            [fid.writelines(f'{key}\t{str(value)}\n') for key,value in asc_header.items()]
            np.savetxt(fid, gvar.round().astype(int), fmt='%d', delimiter='\t')
        asc_filename =  pathlib.Path(filename.stem + "_" + str(y) + "_" + str(ires) + ".asc.license")
        with open(filename, 'w') as fid:
            [fid.writelines(f'{key}\t{str(value)}\n') for key,value in license.items()]

        tdf = ddf[ddf["year"] == year].groupby(['ilon', 'ilat']).agg({'fishing_hours': 'sum'}).reset_index()
        if len(tdf) < 1: continue

        gvar = np.zeros_like(glon) # + fill_value
        indices = np.column_stack((tdf["ilat"].values, tdf["ilon"].values))
        gvar[indices[:, 0], indices[:, 1]] = tdf["fishing_hours"].values
        nc.variables.get(f'fishing_hours_de')[y,:,:] = gvar

        # Add writing of ESRCII asc file
        asc_filename  =  pathlib.Path(filename.stem + "_" + str(y) + "_" + str(ires) + "_de.asc")
        with open(asc_filename, 'w') as fid:
            [fid.writelines(f'{key}\t{str(value)}\n') for key,value in asc_header.items()]
            np.savetxt(fid, gvar.round().astype(int), fmt='%d', delimiter='\t')
        asc_filename =  pathlib.Path(filename.stem + "_" + str(y) + "_" + str(ires) + "_de.asc.license")
        with open(filename, 'w') as fid:
            [fid.writelines(f'{key}\t{str(value)}\n') for key,value in license.items()]

    nc.close()




def main():

    if len(sys.argv) < 2:
        directory = pathlib.Path('/Users/Lemmen/Downloads/fleet-daily-csvs-100-v2-2019')
    else:
        directory = pathlib.Path(sys.argv[1])

    files = list(directory.glob('*.csv'))
    dfs = []

    parquet_name = pathlib.Path(files[0].stem[:4] + ".parquet")
    netcdf_name = pathlib.Path(parquet_name.stem + '.nc')

    if parquet_name.is_file():
        df = pd.read_parquet(parquet_name) #table.to_pandas()
    else:
      with tqdm(total=len(files), unit="file") as progress:

        for csv in files:
            _df = pd.read_csv(csv, usecols={'date', 'cell_ll_lat',
                 'cell_ll_lon', 'flag', 'geartype', 'fishing_hours'},
                  dtype={'flag':str, 'fishing_hours':float})

            _df = _df[_df['geartype'] == 'trawlers' ]
            _df = _df[_df['cell_ll_lat'] >= bbox[1] ]
            _df = _df[_df['cell_ll_lat']  < bbox[3] ]
            _df = _df[_df['cell_ll_lon'] >= bbox[0] ]
            _df = _df[_df['cell_ll_lon']  < bbox[2] ]

            dfs.append(_df)
            progress.update(1)

      df = pd.concat(dfs, ignore_index=True)

      df['date'] = pd.to_datetime(df['date'])
      df['year'] = df['date'].dt.year

      df.to_parquet(path=parquet_name)

    #create_gridspec(df, netcdf_name, res=0.01)
    for r in [1,2,5,10]:
        create_gridspec(df, netcdf_name, ires=r)
    return df

if __name__ == "__main__":
    df = main()
