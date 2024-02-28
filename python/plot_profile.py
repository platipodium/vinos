# SPDX-FileCopyrightText: 2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de


import argparse
import pandas as pd
import matplotlib.pyplot as plt


def plot_subplot(ax, data, column, title, color):
    # Sort data by column in descending order and select top 10
    data_sorted = data.sort_values(by=column, ascending=False).head(10)

    # Plotting
    bars = ax.bar(data_sorted["procedure"], data_sorted[column], color=color)

    # Make top 10 categories appear in bold font
    top_categories = data_sorted["procedure"]
    for bar, category in zip(bars, data["procedure"]):
        if category in top_categories:
            bar.set_fontweight("bold")

    # ax.set_ylabel(title, fontsize='xx-large')  # Doubled the font size
    ax.tick_params(
        axis="x", labelsize="x-large", rotation=25
    )  # Doubled the font size and rotate x-axis tick labels
    ax.tick_params(
        axis="y", labelsize="x-large"
    )  # Doubled the font size for y-axis tick labels

    # Convert title into legend entry and show legend in the northeast corner
    legend = ax.legend([title], loc="upper right", fontsize="xx-large")
    for text in legend.get_texts():
        text.set_color(color)
        text.set_weight("bold")


def plot_bars(data):
    columns = ["calls", "inclusive_time", "exclusive_time"]
    titles = ["Procedure Calls", "Inclusive Time", "Exclusive Time"]
    colors = ["skyblue", "lightgreen", "salmon"]

    fig, axes = plt.subplots(3, 1, figsize=(10, 18))

    for ax, column, title, color in zip(axes, columns, titles, colors):
        plot_subplot(ax, data, column, title, color)

    plt.tight_layout()
    plt.show()


def main():
    parser = argparse.ArgumentParser(description="Generate bar plots from CSV file.")
    parser.add_argument(
        "--filename",
        default="../netlogo/results/profiler_data.csv",
        help="Path to the CSV file (default: profile.csv)",
    )
    args = parser.parse_args()

    try:
        data = pd.read_csv(args.filename)
        plot_bars(data)
    except FileNotFoundError:
        print("Error: File not found.")


if __name__ == "__main__":
    main()
