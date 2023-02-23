# -*- coding: utf-8 -*-
"""
# This script creates from a C-Square point data file
# a GRIDSPEC compliant NetCDF file.
#
# @copyright (C) 2023 Helmholtz-Zentrum hereon GmbH
# @author Carsten Lemmen
#
"""

import netCDF4
import sys
import numpy as np
import time
import pandas as pd
import pathlib

def create_gridspec(df, filename: pathlib.Path, bbox = (3, 53 , 10, 56)):

    res = 0.05
    fill_value = -9999.0

    df = df[df["lon"] >= bbox[0]]
    df = df[df["lat"] >= bbox[1]]
    df = df[df["lon"] <= bbox[2]]
    df = df[df["lat"] <= bbox[3]].reset_index()

    n = len(df)
    if (n<1) : return

    ll_lon = df["lon"].min() - res/2
    ll_lat = df["lat"].min() - res/2
    ur_lon = df["lon"].max() + res/2
    ur_lat = df["lat"].max() + res/2

    nlon = int(round((ur_lon - ll_lon) / res)) 
    nlat = int(round((ur_lat - ll_lat) / res))   

    filename  =  pathlib.Path(str(filename).replace(".csv", "_gridspec.nc"))

    nc=netCDF4.Dataset(filename,'w',format='NETCDF3_CLASSIC')

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
    nc.copyright = "Helmholtz-Zentrum hereon GmBH"
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
    df["ilon"] = np.round((df["lon"] - res/2 - ll_lon) / res).astype(int)
    df["ilat"] = np.round((df["lat"] - res/2 - ll_lat) / res).astype(int)
   
    metiers = df["benthisMet"].unique()
    years = df["Year"].unique()

    year = nc.createVariable('time','f8',('time'))
    year.units=f'year CE'
    year.standard_name='year'
    year[:] = years

    for i, metier in enumerate(metiers):

        for j, loc in enumerate(["sar", "subsar"]):

          var = nc.createVariable(metier.lower() + "_" + loc,'f4',('time','lat','lon'), fill_value=fill_value)
          var.coordinates='lon lat'
          var.units='km km-1 a-1'

        mdf = df[df["benthisMet"] == metier]
        if len(mdf) < 1: continue
        print(f"Metier {metier} with {len(mdf)} data points")

        for y, year in enumerate(years):
            tdf = mdf[mdf["Year"] == year]
            if len(tdf) < 1: continue
            
            print(f"... in year {year} with {len(tdf)} data points")

            for j, loc in enumerate(["sar", "subsar"]):
                gvar = np.zeros((nlat, nlon)) + fill_value
                for i in tdf.index:
                    gvar[tdf["ilat"][i],tdf["ilon"][i]] = tdf[loc][i]
                    #print(gvar[tdf["ilat"][i],tdf["ilon"][i]])
       
                var = nc.variables.get(f'{metier.lower()}_{loc}')
                var[y,:,:] = gvar

    nc.close()

def main():
    if len(sys.argv) < 2: 
       filename = pathlib.Path('/Users/Lemmen/Downloads/ICES.2021.OSPAR_production_of_spatial_fishing_pressure_data_layers/benthic_metiers.csv')
       #filename = pathlib.Path('/Users/Lemmen/Downloads/ICES.2021.OSPAR_production_of_spatial_fishing_pressure_data_layers/test.csv')
    else:
       filename = pathlib.Path(sys.argv[1])

    df = pd.read_csv(filename, usecols = {'Year', 'lat', 'lon', 'benthisMet', 
       'sar', 'subsar',})   
    create_gridspec(df, filename)

if __name__ == "__main__":
    main()