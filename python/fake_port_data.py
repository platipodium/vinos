# -*- coding: utf-8 -*-
"""
This script creates fake fishery data to substitute for fisheries
data that cannot (at this moment) provided to the public for 
data protection issues

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import sys
import numpy as np
import datetime as dt
import pathlib

def write_header(fid): 
  fid.write(f'''
# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
# File created with {sys.argv[0]} on {dt.datetime.now()}
#
# Warning: this file contains artificial surrogate data!
#
''')

def write_data(fid, means=(0.9, 1.1, 0.8, 1.2)):
  # Variation factors for subgroups 1-4
  sfactors = (0.11, 0.09, 0.65, 0.5)
  fid.write(f'sub_grp,median,mean,sd,min,max\n')
  [ fid.write(f'{i+1},{means[i]},{means[i]},{sfactors[i]*means[i]},{0.5*means[i]},{2*means[i]}\n') 
    for i in range(4)]

def write_files():

  # provide for each variable to write metadata and mean
  vardict = {
    "VE_LEN":{"description": "Vessel length in m", "means": (18, 23, 16, 24)},
    "VE_KW":{"description": "Vessel engine power in kW", "means": (220, 220, 190, 220)},
    "distance_to_port":{"description": "Vessel distance from port in m", "means": (75, 125, 35, 250)},
    "triplength":{"description": "Vessel triplength in j", "means": (30, 45, 15, 65)},
    "LPUE":{"description": "Landings per unit effort", "means": (40, 45, 55, 5)},
    "total_fishinghours":{"description": "Vessel annual fishing in h", "means": (1600, 2200, 1000, 2100)},
  }

  for key,value in vardict.items():
    filename = pathlib.Path('../data/orey_etal_data')
    filename = filename / f'fake_{key}.csv'
    with open(filename,'w') as fid:
      write_header(fid)
      print(value)
      fid.write(f'# {value.get("description")}\n')
      write_data(fid, means=value.get("means"))

if __name__ == '__main__':
  write_files()
