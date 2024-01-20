# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de

import pandas as pd
import pathlib
import datetime
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import seaborn as sns
from statsmodels.tsa.arima.model import ARIMA


def extrapolate_timeseries(df: pd.DataFrame) -> pd.DataFrame:
    model = ARIMA(
        df["Crangon"], order=(1, 0, 0)
    )  # You can adjust the order of the model as needed
    model_fit = model.fit()

    future_date = datetime.datetime.strptime("2050-12", "%Y-%m")
    future_steps = round((future_date - df.index[-1]).days / 30)
    forecast = model_fit.forecast(steps=future_steps)
    future_dates = pd.date_range(
        start=df.index[-1] + datetime.timedelta(days=30), periods=future_steps
    )

    # Create a DataFrame for the extrapolated values
    extrapolated_df = pd.DataFrame({"Crangon": forecast[0]}, index=future_dates)

    return pd.concat([df, extrapolated_df])


def plot_seasonal(df):
    plt.figure(figsize=(8, 4), tight_layout=True)
    one_year = df[df.year == 2010]["Pleuronectes"]
    groups = one_year.groupby(pd.Grouper(freq="M"))
    months = pd.concat([pd.DataFrame(x[1].values) for x in groups], axis=1)
    months = pd.DataFrame(months)
    months.columns = range(1, 13)
    months.boxplot()


def plot_timeseries(df):
    fig = plt.figure(figsize=(8, 4), tight_layout=True)
    ax = sns.lineplot(x=df.index, y="Crangon", data=df, linewidth=2.5, label="Crangon")
    ax = sns.lineplot(x=df.index, data=df, y="Solea", linewidth=2.5, label="Solea")
    ax = sns.lineplot(
        x=df.index, data=df, y="Pleuronectes", linewidth=2.5, label="Pleuronectes"
    )
    ax.set(xlabel="Year", ylabel="€ kg$^{-1}$", title="Price evolution", ylim=(0, 20))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y-%m"))
    ax.xaxis.set_major_locator(mdates.YearLocator())
    fig.autofmt_xdate()
    plt.legend()

    # ax.legend(title='Players', title_fontsize = 13)
    plt.show()


if __name__ == "__main__":
    df = pd.read_csv(
        "../data/ble/ble_national_landings_monthly.csv",
        delimiter=",",
        comment="#",
        parse_dates=[0],
    )
    df.loc[df["Pleuronectes"] > 20, "Pleuronectes"] = np.nan

    df.set_index("year_month", inplace=True)

    df["year"] = df.index.year
    df["month"] = df.index.month

    plot_timeseries(df)
    plot_seasonal(df)
    # df_e = extrapolate_timeseries(df)
