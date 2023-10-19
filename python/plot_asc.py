"""
This script creates plots from .asc or .nc files

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import shapefile
import rasterio
import geopandas as gpd
import numpy as np
import numpy.ma as ma
import xarray as xr


variables = {
    'shore_proximity': {'unit': 'km', 'cmap': 'Blues', 'title': 'Shore proxmity'},
    'area': {'unit': 'km$^2$', 'cmap': 'Greens', 'title': 'Cell area'},
    'bathymetry': {'min': 0, 'max': 80,'unit': 'm', 'cmap': 'ocean', 'title': 'Bathymetry'},
    'plaicebox': {'min': 0, 'max': 1,'unit': '', 'cmap': 'Grays', 'title': 'Plaice box'},
    'owf': {'min': 0, 'max': 1,'unit': '', 'cmap': 'Grays', 'title': 'OWF fraction'},
    'accessibility': {'min': 0, 'max': 1,'unit': '', 'cmap': 'Grays', 'title': 'Accessibilty'},
    'traffic': {'min': 0, 'max': 1000,'unit': '', 'cmap': 'Blues', 'title': 'Cargo traffic density'},
    'sole': {'min': 1, 'max': 500,'unit': 'kg km-2', 'cmap': 'Reds', 'title': 'Sole'},
    'plaice': {'min': 1, 'max': 500, 'unit': 'kg km-2', 'cmap': 'Reds', 'title': 'Plaice'},
    'shrimp': {'min': 1, 'max': 500, 'unit': 'kg km-2', 'cmap': 'Reds', 'title': 'Shrimp'},
    'emodnet_tbb_effort': {'max': 1000, 'min': 10, 'unit': 'h a-1', 'cmap': 'viridis', 'title': 'Effort'},
    'effort': {'max': 510, 'min': 10, 'unit': 'kW h a-1', 'cmap': 'viridis', 'title': 'Effort'},
    'delta_effort': {'max': 100, 'min': -100, 'unit': 'kW h a-1', 'cmap': 'coolwarm', 'title': '$\Delta$Effort'},
}

extent = [4.5, 9.3, 53.2, 55.1]


def add_nc(ax, nc_file, varname='var', var=None):
    # Read the NetCDF file using xarray
    ds = xr.open_dataset(nc_file)

    # Get the data variable (assuming a single variable in the NetCDF)
    #data_var = ds[varname]  # Replace 'variable_name' with the actual variable name

    # Get the data array as a NumPy array
    raster_data = ds[varname].values

    # Get the geographic coordinates from the NetCDF file
    lon = ds.lon.values
    lat = ds.lat.values

    # Create a masked array to handle NaN or missing values
    if 'missing_value' in ds[varname].attrs or (var and 'delta' in var):
        masked_raster_data = ma.masked_invalid(raster_data).astype(float)
    #else:
    #    masked_raster_data = ma.masked_where(raster_data < 0, raster_data).astype(float)



    zmin = np.nanmin(masked_raster_data)
    zmax = np.nanmax(masked_raster_data)
    cmap = 'viridis'
    unit = ''
    title = 'North Sea'


    if var != None:
        if 'min'  in variables[var]: zmin = variables[var]['min']
        if 'max'  in variables[var]: zmax = variables[var]['max']
        if 'cmap' in variables[var]: cmap = variables[var]['cmap']
        if 'unit' in variables[var]: unit = variables[var]['unit']
        if 'title' in variables[var]: title = variables[var]['title']

    if 'delta' in var:
      masked_raster_data = ma.masked_where(np.abs(masked_raster_data) < 0.1*zmax, masked_raster_data)

    else:
      masked_raster_data = ma.masked_where(masked_raster_data < zmin, masked_raster_data)

    contour_levels = np.linspace(zmin, zmax, 8)


    # Create a meshgrid for the lon and lat
    lon, lat = np.meshgrid(lon, lat)

    # Display contour lines of the masked raster on the existing map
    contour = ax.contourf(lon, lat, masked_raster_data, transform=ccrs.PlateCarree(), cmap=cmap,
                          levels=contour_levels, alpha=0.5)
    mesh = ax.pcolormesh(lon, lat, masked_raster_data, transform=ccrs.PlateCarree(), cmap=cmap, alpha=0.5)

    # Add a colorbar for the contour plot
    cbar = plt.colorbar(contour, ax=ax, orientation='vertical', label=unit)
    ax.set_title(title)


def combine_asc(asc_file1, asc_file2, operator = '-'):

    data_1, lon, lat = read_asc(asc_file1)
    data_2, lon, lat = read_asc(asc_file2)

    if operator == '-':
      return data_1 - data_2


def read_asc(asc_file):
    # Read the ASC raster file using rasterio
    with rasterio.open(asc_file) as src:
        # Display the raster on the existing map
        raster_data = src.read(1)  # Assuming a single-band raster
        raster_data = np.flipud(raster_data)

        masked_raster_data = ma.masked_where(raster_data == src.nodata, raster_data).astype(float)

        # Get the geographic transform to properly position the raster
        transform = src.transform

        # Create an extent based on the raster's shape
        extent = [transform[2], transform[2] + transform[0] * src.width,
                  transform[5] + transform[4] * src.height, transform[5]]

        lon = np.linspace(extent[0], extent[1], masked_raster_data.shape[1])
        lat = np.linspace(extent[2], extent[3], masked_raster_data.shape[0])


    return masked_raster_data, lon, lat


def plot_grid(ax, data, lon, lat, var=None):

    zmin = np.nanmin(data)
    zmax = np.nanmax(data)
    cmap = 'viridis'
    unit = ''
    title = 'North Sea'

    if var != None:
        if 'min'  in variables[var]: zmin = variables[var]['min']
        if 'max'  in variables[var]: zmax = variables[var]['max']
        if 'cmap' in variables[var]: cmap = variables[var]['cmap']
        if 'unit' in variables[var]: unit = variables[var]['unit']
        if 'title' in variables[var]: title = variables[var]['title']

    contour_levels = np.linspace(zmin, zmax, 8)

    data[data>zmax] = zmax
    #data[data<zmin] = zmin

    if var != None and 'delta' in var:
      #  masked_raster_data = ma.masked_where(np.abs(masked_raster_data) < 0.3*zmax, masked_raster_data)
      zmax = np.max([np.abs(zmax),np.abs(zmin)])
      zmin = -zmax
      data[data>zmax] = zmax
      data[data<zmin] = zmin


    # Display contour lines of the raster on the existing map
    contour = ax.contourf(lon, lat,
                    data, levels=contour_levels, transform=ccrs.PlateCarree(), cmap=cmap, alpha=0.5)

    #mesh = ax.pcolormesh(lon, lat, masked_raster_data, transform=ccrs.PlateCarree(), cmap=cmap, alpha=0.5)

    cbar = plt.colorbar(contour, ax=ax, orientation='vertical', label=unit)
    ax.set_title(title)
    plt.tight_layout()


def add_asc(ax, asc_file1, asc_file2=None, operator='-', var=None):


    masked_raster_data, lon, lat = read_asc(asc_file1)
    if asc_file2 != None:
        masked_raster_data=combine_asc(asc_file1, asc_file2, operator=operator)

    plot_grid(ax, masked_raster_data, lon, lat, var=var)


def basemap():


    # Load and plot the shapefile to get its extent
    shapefile_path = '../data/eez/eez.shp'
    sf = shapefile.Reader(shapefile_path)
    shapes = sf.shapes()

    # Find the minimum and maximum longitude and latitude values from the shapefile
    min_lon = min(p[0] for shape in shapes for p in shape.points)
    max_lon = max(p[0] for shape in shapes for p in shape.points)
    min_lat = min(p[1] for shape in shapes for p in shape.points)
    max_lat = max(p[1] for shape in shapes for p in shape.points)

    fig, ax = plt.subplots(subplot_kw={
        'projection': ccrs.LambertConformal(central_longitude=(min_lon + max_lon) / 2, central_latitude=(min_lat + max_lat) / 2)
        }, figsize=(4,2.3))

    # Add coastlines, land, and the EEZ boundary
    ax.add_feature(cfeature.COASTLINE)
    #ax.add_feature(cfeature.LAND, edgecolor='black')
    #ax.add_feature(cfeature.BORDERS, linestyle=':')
    #ax.add_feature(cfeature.NaturalEarthFeature('physical', 'ocean', '50m'), facecolor='aqua', edgecolor='none')

    #extent = [min_lon-0.2, 9.7, min_lat-0.2, max_lat+0.2]
    # Set the extent to cover the North Sea
    ax.set_extent(extent)

    # Add a title
    #ax.set_title("German Exclusive Economic Zone (EEZ)")

    for shape in shapes:
        x, y = zip(*shape.points)
        #ax.plot(x, y, 'grey', transform=ccrs.PlateCarree())

    return ax


if __name__ == '__main__':


    for v in [ 'shrimp', 'plaice', 'sole',
            'accessibility', 'bathymetry','traffic',
            'area', 'shore_proximity', 'owf',
            'plaicebox'
            ]:
      continue
      ax = basemap()
      add_asc(ax, f'../netlogo/results/{v}.asc', var=v)
      plt.savefig(f'{v}.png', dpi=400)


    ax = basemap()
    add_asc(ax,'../netlogo/results/effort_0361_20301229.asc', var='effort')
    ax.set_title('Effort 2030')
    plt.savefig('effort_2030.png', dpi=400)

    ax = basemap()
    add_asc(ax,'../netlogo/results/effort_0360_20201227.asc', var='effort')
    ax.set_title('Effort 2020')
    plt.savefig('effort_2020.png', dpi=400)


    mask, lon, lat = read_asc(f'../netlogo/results/plaicebox.asc')
    tbb, lon, lat = read_asc(f'../netlogo/results/emodnet_tbb_effort.asc')
    data = tbb * (1-mask)

    ax = basemap()
    plot_grid(ax, data, lon, lat, var="effort")
    ax.set_title('EMODnet effort')
    plt.savefig('effort_emodnet.png', dpi=400)

    tbb, lon, lat = read_asc(f'../netlogo/results/effort_0360_20201227.asc')
    data1 = tbb * (1-mask)

    ax = basemap()
    plot_grid(ax, data1, lon, lat, var="effort")
    ax.set_title('Simulated effort')
    plt.savefig('effort_2020.png', dpi=400)

    data2 = data1 - data
    ax = basemap()
    plot_grid(ax, data2, lon, lat, var="delta_effort")
    plt.savefig('delta_effort_emodnet-2020.png', dpi=400)
