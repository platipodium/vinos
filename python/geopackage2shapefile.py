# SPDX-FileCopyrightText: 2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de

import argparse
import geopandas as gpd
import os


def convert_geopackage_to_shapefiles(geopackage_path, output_folder):
    # Read the GeoPackage file
    gdf = gpd.read_file(geopackage_path)

    # Get unique attribute names
    attribute_names = gdf.columns.tolist()

    # Create output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    # Write individual shapefiles for each attribute
    for attribute in attribute_names:
        # Filter GeoDataFrame by attribute
        attribute_gdf = gdf[[attribute, "geometry"]]

        # Remove rows with missing geometries
        attribute_gdf = attribute_gdf.dropna(subset=["geometry"])

        # Write shapefile
        output_shapefile = os.path.join(output_folder, f"{attribute}.shp")
        attribute_gdf.to_file(output_shapefile)


def main():
    parser = argparse.ArgumentParser(
        description="Convert GeoPackage files to individual Shapefiles for each attribute"
    )
    parser.add_argument(
        "input_geopackage",
        nargs="?",
        default="~/Downloads/EctpWZ3L_gpkg/EctpWZ3L.gpkg",
        help="Path to the input GeoPackage file",
    )
    parser.add_argument(
        "output_shapefile_folder",
        nargs="?",
        default="~/temp/EctpWZ3L",
        help="Path to the output folder where shapefiles will be saved (default: output_shapefile_folder)",
    )
    args = parser.parse_args()

    convert_geopackage_to_shapefiles(
        args.input_geopackage, args.output_shapefile_folder
    )


if __name__ == "__main__":
    main()
