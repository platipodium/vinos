# -*- coding: utf-8 -*-
"""
This script creates from a C-Square point data file
an ESRII ASCII (.asc) data file.

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import sys
import numpy as np
import time
import pandas as pd
import pathlib
import csv


def create_asc(df, filename: pathlib.Path, bbox=(3, 53, 10, 56)):
    res = 0.05
    fill_value = -9999.0

    df = df[df["lon"] >= bbox[0]]
    df = df[df["lat"] >= bbox[1]]
    df = df[df["lon"] <= bbox[2]]
    df = df[df["lat"] <= bbox[3]].reset_index()

    n = len(df)
    if n < 1:
        return

    ll_lon = df["lon"].min() - res / 2
    ll_lat = df["lat"].min() - res / 2
    ur_lon = df["lon"].max() + res / 2
    ur_lat = df["lat"].max() + res / 2

    nlon = int(round((ur_lon - ll_lon) / res))
    nlat = int(round((ur_lat - ll_lat) / res))

    header = {
        "NCOLS": nlon,
        "NROWS": nlat,
        "XLLCORNER": ll_lon,
        "YLLCORNER": ll_lat,
        "CELLSIZE": res,
        "NODATA_VALUE": fill_value,
    }

    basename = pathlib.Path(str(filename).replace(".csv", ".asc"))

    license = {
        "Original file": str(filename),
        "History": f"Created {time.ctime(time.time())}  by {sys.argv[0]}",
        "SPDX-FileContributor": "Carsten Lemmen <carsten.lemmen@hereon.de",
        "SPDX-FileCopyrightText": [
            "2023-2024 Helmholtz-Zentrum hereon GmbH",
            "2021-2023 International Council for the Exploration of the Seas",
        ],
        "SPDX-License-Identifier": "CC-by-4.0",
        "Units": "km km-1 a-1",
        "Institution-ID": ["https://ror.org/03qjp1d79", "https://ror.org/03hg53255"],
    }

    # define the index
    df["ilon"] = np.round((df["lon"] - res / 2 - ll_lon) / res).astype(int)
    df["ilat"] = np.round((df["lat"] - res / 2 - ll_lat) / res).astype(int)

    if "metier" in str(filename):
        metiers = df["benthisMet"].unique()
    elif "fishing_category" in str(filename):
        metiers = df["fishingCategory"].unique()
    else:
        metiers = ["all"]

    years = df["Year"].unique()

    for i, metier in enumerate(metiers):
        license["Metier"] = metier

        if "fishing_category" in str(filename):
            mdf = df[df["fishingCategory"] == metier]
        elif "metier" in str(filename):
            mdf = df[df["benthisMet"] == metier]
        else:
            mdf = df

        if len(mdf) < 1:
            continue
        print(f"Metier {metier} with {len(mdf)} data points")

        for y, year in enumerate(years):
            tdf = mdf[mdf["Year"] == year]
            if len(tdf) < 1:
                continue

            license["Year"] = year

            print(f"... in year {year} with {len(tdf)} data points")

            for j, loc in enumerate(["sar", "subsar"]):
                license["Location"] = loc

                gvar = np.zeros((nlat, nlon)) + fill_value
                for i in tdf.index:
                    gvar[tdf["ilat"][i], tdf["ilon"][i]] = tdf[loc][i]

                filename = pathlib.Path(
                    str(basename).replace(".asc", f"_{metier.upper()}_{loc}_{year}.asc")
                )
                with open(filename, "w") as fid:
                    [
                        fid.writelines(f"{key}\t{str(value)}\n")
                        for key, value in header.items()
                    ]
                    np.savetxt(fid, gvar, delimiter="\t")
                filename = pathlib.Path(str(basename).replace(".asc", ".asc.license"))
                with open(filename, "w") as fid:
                    [
                        fid.writelines(f"{key}\t{str(value)}\n")
                        for key, value in license.items()
                    ]

        # Here aggregate over years
        # ydf = df.groupby('Year').agg('mean', 'benthisMetydf)
        # for loc in ['subsurface','surface','sar','subsar','kWH_low','kWH_upp','kWH_cov',
        #             'Hour_low','Hour_upp','Hour_cov','TotWt_low','TotWt_upp','TotWt_cov',
        #             'TotVal_low','TotVal_upp','TotVal_cov'] :

        #     gvar = np.zeros((nlat, nlon)) + fill_value
        #     for i in ydf.index:
        #             gvar[ydf["ilat"][i],ydf["ilon"][i]] = ydf[loc][i]


def main():
    if len(sys.argv) < 2:
        filename = pathlib.Path(
            "/Users/Lemmen/Downloads/ICES.2021.OSPAR_production_of_spatial_fishing_pressure_data_layers/benthic_metiers.csv"
        )
        # filename = pathlib.Path('/Users/Lemmen/Downloads/ICES.2021.OSPAR_production_of_spatial_fishing_pressure_data_layers/test.csv')
    else:
        filename = pathlib.Path(sys.argv[1])

    if "metiers" in str(filename):
        usecols = {
            "Year",
            "lat",
            "lon",
            "benthisMet",
            "subsurface",
            "surface",
            "sar",
            "subsar",
            "kWH_low",
            "kWH_upp",
            "kWH_cov",
            "Hour_low",
            "Hour_upp",
            "Hour_cov",
            "TotWt_low",
            "TotWt_upp",
            "TotWt_cov",
            "TotVal_low",
            "TotVal_upp",
            "TotVal_cov",
        }
    elif "total" in str(filename):
        usecols = {
            "Year",
            "lat",
            "lon",
            "sar",
            "subsar",
        }
    elif "fishing_category" in str(filename):
        usecols = {
            "Year",
            "lat",
            "lon",
            "fishingCategory",
            "sar",
            "subsar",
        }
    else:
        usecols = {}

    df = pd.read_csv(filename, usecols=usecols)
    create_asc(df, filename)


if __name__ == "__main__":
    main()
