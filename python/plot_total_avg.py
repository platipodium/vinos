"""
This script creates plots from .asc or .nc files

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import pandas as pd
import numpy as np
import datetime

def main():

    pass

if __name__ == "__main__":
    main()
    df = pd.read_csv('../netlogo/results/total_avg.csv', sep=',',
                     header=2, names=["tick","year","month","day","doy","at-sea","fuel","landings","lpue"])


    datestr = [f'{y}-{m}-{d}' for y,m,d in zip(df["year"],df["month"],df["day"])]
    df["date"] = [datetime.datetime.strptime(s, '%Y-%m-%d').date() for s in datestr]


    ddf = df.iloc[1:,:]

    ddf["fuel"] = df["fuel"].iloc[1:].values - df["fuel"].iloc[:-1].values
    ddf["lpue"] = df["lpue"].iloc[1:].values - df["lpue"].iloc[:-1].values


    ddf["lpue"] = ddf["lpue"] * 365.25
    ddf["fuel"] = ddf["fuel"] * 365.25

    ddf.plot(x="date", y=["lpue","fuel"], label=["LPUE kg d-1", "Intensity l t-1"])
