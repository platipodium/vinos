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

def create_gridspec(df, filename: pathlib.Path, bbox = (3, 53 , 10, 56)):

    res = 0.01
    fill_value = -9999.0

    df = df[df["cell_ll_lon"] >= bbox[0]]
    df = df[df["cell_ll_lat"] >= bbox[1] - res]
    df = df[df["cell_ll_lon"] <= bbox[2]]
    df = df[df["cell_ll_lat"] <= bbox[3] - res].reset_index()

    n = len(df)
    if (n<1) : return

    ll_lon = df["cell_ll_lon"].min()
    ll_lat = df["cell_ll_lat"].min()
    ur_lon = df["cell_ll_lon"].max() + res
    ur_lat = df["cell_ll_lat"].max() + res

    nlon = int(round((ur_lon - ll_lon) / res))
    nlat = int(round((ur_lat - ll_lat) / res))

    filename  =  pathlib.Path(filename.stem + "_gridspec.nc")

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
    df["ilon"] = np.round((df["cell_ll_lon"] - ll_lon) / res).astype(int)
    df["ilat"] = np.round((df["cell_ll_lat"] - ll_lat) / res).astype(int)

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

    for y, year in enumerate(years):
        tdf = df[df["year"] == year]
        if len(tdf) < 1: continue

        print(f"... in year {year} with {len(tdf)} data points")

        gvar = np.zeros((nlat, nlon)) + fill_value
        for i in tdf.index:
            gvar[tdf["ilat"][i],tdf["ilon"][i]] = tdf['fishing_hours'][i]
            var = nc.variables.get(f'fishing_hours')
            var[y,:,:] = gvar

        tdf = ddf[ddf["year"] == year]
        if len(tdf) < 1: continue

        gvar = np.zeros((nlat, nlon)) + fill_value
        for i in tdf.index:
            gvar[tdf["ilat"][i],tdf["ilon"][i]] = tdf['fishing_hours'][i]
            var = nc.variables.get(f'fishing_hours_de')
            var[y,:,:] = gvar

    nc.close()

def main():

    if len(sys.argv) < 2:
        directory = pathlib.Path('/Users/Lemmen/Downloads/fleet-daily-csvs-100-v2-2019')
    else:
        directory = pathlib.Path(sys.argv[1])

    files = list(directory.glob('*27.csv'))
    dfs = []

    parquet_name = pathlib.Path(files[0].stem[:4] + ".parquet")
    netcdf_name = pathlib.Path(parquet_name.stem + '.nc')

    if parquet_name.is_file():
        #table = pyarrow.parquet.read_table(parquet_name)
        df = pd.read_parquet(parquet_name) #table.to_pandas()
    else:
      with tqdm(total=len(files), unit="file") as progress:

        for csv in files:
            _df = pd.read_csv(csv, usecols={'date', 'cell_ll_lat',
                 'cell_ll_lon', 'flag', 'geartype', 'fishing_hours'},
                  dtype={'flag':str, 'fishing_hours':float})
            dfs.append(_df[_df.geartype=='trawlers'])
            progress.update(1)

      df = pd.concat(dfs, ignore_index=True)

      df['date'] = pd.to_datetime(df['date'])
      df['year'] = df['date'].dt.year

      df.to_parquet(path=parquet_name)

    create_gridspec(df, netcdf_name)
    return df

if __name__ == "__main__":
    df = main()
