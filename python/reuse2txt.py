# -*- coding: utf-8 -*-
"""
This script converts output from `reuse spdx` to human-readable
text as markdown.

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import pandas as pd
import sys
import datetime
import pathlib
import re

def get_copyright_list(df: pd.DataFrame) -> list[str]:
    copyrights = set()
    for _, row in df.iterrows():
        #for
        try:
            copyright = row.get('FileCopy' + 'rightText').replace('<text>','').replace('</text>',
                '').replace('SPDX-FileCopy' + 'rightText: ','')
            pattern = re.compile(r'^\s*\d+(?:-\d*)?\s*')
            copyright = pattern.sub("",copyright)

            #print(row.get('FileCopy'+'rightText'), row.get('FileName'))
        except:
            continue
        copyrights.add(copyright)


    return sorted(list(copyrights))

def get_license_list(df: pd.DataFrame) -> list[str]:
    licenses = set()
    for _, row in df.iterrows():
        licenseinfo = row['LicenseInfoInFile']
        if not type(licenseinfo) is str: continue
        for li in licenseinfo.split(','):
          if 'LicenseRef-' in li:
            license = li.replace('LicenseRef-','').replace(" ","")
            licensestring = f'[{license}](./LICENSES/{li.replace(" ","")}.txt)'
          else:
            license = li.replace(" ","")
            licensestring = f'![OSI approved](https://149753425.v2.pressablecdn.com/wp-content/uploads/2009/06/OSIApproved_100X125.png){{width=10%}} [{license}](./LICENSES/{li.replace(" ","")}.txt)'
          licenses.add(licensestring)

    return sorted(list(licenses))


def format_reuse(df: pd.DataFrame) -> str:

    text = ''
    stem = ''
    licenses = set()
    for _, row in df.iterrows():

        if not 'FileName' in row: continue
        path=pathlib.Path(row['FileName'])
        stem = path.stem

        if not 'LicenseInfoInFile': continue
        try:
            license = row['LicenseInfoInFile'].replace('LicenseRef-','')
        except:
            #print(f'Cannot identify license in row "{row}"')
            continue
        copyright = row.get('FileCopy'+'rightText').replace('<text>','').replace('</text>',
                '').replace('SPDX-FileCopy'+'rightText: ','')
        text += f"* {row['FileName']}:\nLicense: {license}\nCopyright: {copyright}\n"
    return text

def process_reuse() -> pd.DataFrame:

    text = sys.stdin.read()
    paragraphs = text.split("\n\n")
    data = {}

    for paragraph in paragraphs:
        lines = paragraph.strip().split("\n")
        if len(lines) < 1: continue

        try:
            first_word = lines[0].split()[0]
        except:
            continue

        if not first_word == "FileName:": continue
        first_value = lines[0].split()[1]

        # create a dictionary to store the values
        values = {}

        # loop through the lines and add the values to the dictionary
        # Need copyright_counter
        counters={}
        for line in lines:
            try:
              key, value = line.split(": ", 1)
              if key not in values:
                  counters[key] = 0
                  values[key] = value
              else:
                  counters[key] += 1
                  values[key] = values[key] + ', ' + value
            except:
              continue

        #print(first_value)
        # add the values dictionary to the data dictionary using the first word as the key
        data[first_value] = values


    return pd.DataFrame.from_dict(data, orient='index')

if __name__ == '__main__':

    df = process_reuse()
    formatted = format_reuse(df)
    print(f'''<!--
SPDX-FileCopyRightText: {datetime.date.today().year} Helmholtz-Zentrum hereon GmbH
SPDX-LicenseRef: CC0-1.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

This file was autogenerated by `{sys.argv[0]}`, please do not edit by hand.
To produce this content, run `reuse spdx | python {sys.argv[0]}`
-->''')
    print(f'''
# Licenses used

While the NetLogo software itself is distributed under the Apache-2.0 permissive
license, many other licenses are used by this project, all of them open source,
and most of them under open source licenses approved by the Open Software
Initiative.

You can find the full license text for each license used
in the  [LICENSES](./LICENSES/) folder:
''')

    licenses = get_license_list(df)
    for l in licenses:
        print(f'* {l}')

    print(f'''
## Copyright holders

The following organizations and individuals own copyrights to (parts of) this project.
''')
    copyrights = get_copyright_list(df)
    for c in copyrights:
        print(f'* {c}')

    print(f'''
## License and copyright manifest

Each file carries a license attribution, please consult the following list to identify
the license applicable to an individual file:
''')

    print(formatted)
