# -*- coding: utf-8 -*-
"""
This script downloads German and Moroccan holidays using
the python holidays package

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import holidays
import pandas as pd
import pathlib
import sys

def save_holidays(country, df):

    filename = pathlib.Path(f'../data/holidays/holidays_{country}.csv')
    with open(filename, 'w') as fid:
        fid.write(f'; Do not edit this file, it was generated by `{sys.argv[0]}\n')
        fid.write(f'; SPDX-FileCop{}yrightText: 2023 Helmholtz-Zentrum hereon GmbH\n')
        fid.write(f'; SPDX-Lic{}ense-Identifier: CC0-1.0\n')
        fid.write(f'Date,Holiday\n')
        df.to_csv(fid, header=False, sep=',')
    pass

def get_holidays(years):

    de = holidays.DE(years=years)
    ma = holidays.MA(years=years)

    de = pd.DataFrame(index=de.keys(),data=de.values(), columns=['Holiday']).sort_index()
    ma = pd.DataFrame(index=ma.keys(),data=ma.values(), columns=['Holiday']).sort_index()

    save_holidays('DE', de)
    save_holidays('MA', ma)

    return de,ma
if __name__ == '__main__':

    years = range(1950, 2051)
    de, ma = get_holidays(years)
