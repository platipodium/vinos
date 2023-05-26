# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de

import requests
import tabula
import pandas as pd
import pathlib
import datetime
import io
import numpy as np

base_url = "https://www.ble.de/SharedDocs/Downloads/DE/Fischerei/Fischwirtschaft/"



def get_remote_or_local(year, month):

    filename = pathlib.Path(f"../data/ble/Monatsbericht_{year%1000:02d}_{month:02d}.pdf")

    if not filename.exists():

        url = f"{base_url}Monatsbericht{year}/Monatsbericht_{year%1000:02d}_{month:02d}.pdf?__blob=publicationFile&v=2"
        response = requests.get(url)
        if not response.ok:
            url = f"{base_url}Monatsbericht{year}/Monatsbericht{year%1000:02d}_{month:02d}.pdf?__blob=publicationFile&v=2"
            response = requests.get(url)
        if not response.ok:
           url = f"{base_url}Monatsbericht{year}/Monatsbericht{month:02d}{year:04d}.pdf?__blob=publicationFile&v=2"
           response = requests.get(url)
        if not response.ok:
           url = f"{base_url}Monatsbericht{year}/{year:04d}Monatsbericht{month:02d}.pdf?__blob=publicationFile&v=2"
           response = requests.get(url)
        if not response.ok:
           url = f"{base_url}Monatsbericht{year}/{year:04d}_{month:02d}_Monatsbericht.pdf?__blob=publicationFile&v=2"
           response = requests.get(url)
        if not response.ok:
            print(f"URL {url} was not found")
            return None

        pdf_data = response.content

        with open(filename,'wb') as fid:
            fid.write(pdf_data)

    if filename.exists():
        with open(filename, 'rb') as fid:
            pdf_data =  fid.read()

    return pdf_data

def float_or_nan(s: str) -> float:

    try:
        f = float(s)
    except:
        f = np.NaN
    return f

def data_from_pdf(pdf_data):

    # Extract the table data from page 5 of the PDF file

    if year == 2011:
        page = 13
    elif year < 2019:
        page = 12
    else:
        page = 5

    try:
        df = tabula.read_pdf(io.BytesIO(pdf_data),
                         pages=page, lattice=False, stream=True, guess=False,
                         encoding="utf-8", area=(136,0,500,213), pandas_options={"columns":("Species","t","k€")},
                         )
    except:
        return None
    while type(df) == list:
      if len(df) == 0:
          return None
      else : df=df[0]

    df["t"] = df["t"].astype(str).str.replace('.','').str.replace(',','.')
    df["k€"] = df["k€"].astype(str).str.replace('.','').str.replace(',','.')

    df["t"] = df["t"].apply(float_or_nan)
    df["k€"] = df["k€"].apply(float_or_nan)


    df["€ kg-1"] = df["k€"] / df["t"]
    return df

def data_from_csv(year, month):

    filename = pathlib.Path(f"../data/ble/national_landings_{year:04d}_{month:02d}.csv")
    if filename.exists():
        return pd.read_csv(filename, sep=";")

    return None


def get_all_csv():

    filenames = pathlib.Path(f"../data/ble/").glob("national_landings_*.csv")
    df = pd.DataFrame()

    for f in filenames:
        df = pd.concat([df, pd.read_csv(f, sep=";")])

    return df

if __name__ == "__main__":

    # Data is available from 2009 to 2023
    for year in range(2009,2017):
        for month in range(1,13):

            if datetime.date.today().year == year:
                if month >= datetime.date.today().month - 1:
                    continue
            df = data_from_csv(year, month)
            if type(df) == pd.core.frame.DataFrame: continue

            pdf_data = get_remote_or_local(year, month)
            if pdf_data == None:
                print('Could not extract data for {year}_{month}')
                continue
            df = data_from_pdf(pdf_data)
            if type(df) != pd.core.frame.DataFrame:
                continue
            df["year"] = year
            df["month"] = month

            filename = pathlib.Path(f"../data/ble/national_landings_{year:04d}_{month:02d}.csv")
            df.to_csv(filename, sep=";")
            print(df)

    df = get_all_csv()
    df["yearmonth"] = df.year + (df.month - 0.5)/12
    df = df.sort_values(by=["yearmonth"])

    for s in ("Speisekrabbe","Scholle","Seezunge"):
        df[df["Species"] == s].plot(x="yearmonth",y="€ kg-1", title=s)
