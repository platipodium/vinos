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
    df = pd.read_csv('../netlogo/results/results/total_avg_shrimp_2030-1-1.csv', sep=',',
                     header=2, names=["tick","year","month","day","doy","at-sea","fuel","landings","count"])


    datestr = [f'{y}-{m}-{d}' for y,m,d in zip(df["year"],df["month"],df["day"])]
    #df["date"] = [datetime.datetime.strptime(s, '%Y-%m-%d').date() for s in datestr]
    df['date'] = pd.to_datetime(df[['year', 'month', 'day']])


    ddf = df.iloc[1:].copy()
    ddf.set_index('date', inplace=True)

    ddf["fuel"] = df["fuel"].iloc[1:].values - df["fuel"].iloc[:-1].values
    ddf["lpue"] = df["lpue"].iloc[1:].values - df["lpue"].iloc[:-1].values
    ddf["landings"] = df["landings"].iloc[1:].values - df["landings"].iloc[:-1].values


    ddf_monthly = ddf[['landings','lpue','fuel']].resample('M').sum()

    ddf_monthly.plot(y=["lpue","fuel"], label=["LPUE kg d-1", "Intensity l t-1"], kind='bar')
