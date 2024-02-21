# -*- coding: utf-8 -*-
"""
This script creates from an ESRII ASC raster data file
a png image

SPDX-FileCopyrightText: 2024 Helmholtz-Zentrum hereon GmbH
SPDX-FileCopyrightText: 2014-2021 Helmholtz-Zentrum Geesthacht
SPDX-License-Identifier: CC0-1.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

from osgeo import gdal
import pathlib
import sys
from PIL import Image
import numpy as np


def asc2png(filename):
    output_image = pathlib.Path(filename.stem + ".png")

    # Open the input raster file
    input_ds = gdal.Open(pathlib.Path(filename))

    # Read the raster band
    band = input_ds.GetRasterBand(1)
    data = band.ReadAsArray()
    data = np.uint8(data)

    # Create the output PNG image
    image = Image.fromarray(data)
    image.save(output_image)

    # Close the dataset
    input_ds = None

    print("Image creation complete.")


def main():
    if len(sys.argv) < 2:
        filename = pathlib.Path("effort-2017-01-08.asc")
    else:
        filename = pathlib.path(sys.argv[1])

    asc2png(filename)


if __name__ == "__main__":
    main()
