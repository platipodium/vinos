import pandas as pdimport sysdef format_reuse(df: pd.DataFrame) -> str:        text = ''    for index, row in df.iterrows():        copyright = row.get('FileCopyrightText').replace('<text>','').replace('</text>',                '').replace('SPDX-FileCopyrightText: ','')        #print(f"{row['FileName']}:\nLicense: {row['LicenseInfoInFile']}\nCopyright: {copyright}\n")        text += f"{row['FileName']}:\nLicense: {row['LicenseInfoInFile']}\nCopyright: {copyright}\n\n"    return textdef process_reuse() -> pd.DataFrame:    text = sys.stdin.read()    paragraphs = text.split("\n\n")    data = {}    for paragraph in paragraphs:        lines = paragraph.strip().split("\n")        if len(lines) < 1: continue            try:             first_word = lines[0].split()[0]        except:            continue                if not first_word == "FileName:": continue        first_value = lines[0].split()[1]            # create a dictionary to store the values        values = {}            # loop through the lines and add the values to the dictionary        # Need copyright_counter        counters={}        for line in lines:            try:              key, value = line.split(": ", 1)              if key not in values:                  counters[key] = 0                  values[key] = value              else:                  counters[key] += 1                  values[key] = values[key] + ', ' + value                             except:              continue        #print(first_value)            # add the values dictionary to the data dictionary using the first word as the key        data[first_value] = values           return pd.DataFrame.from_dict(data, orient='index')    # print the dataframe    if __name__ == '__main__':    df = process_reuse()    formatted = format_reuse(df)    print(f'''# This file was autogenerated by {sys.argv[0]}, please do not edit by hand# To produce this content, run `reuse spdx | python {sys.argv[0]} ## SPDX-FileCopyRightText: 2023 Helmholtz-Zentrum hereon GmbH# SPDX-LicenseRef: CC0-1.0#''')    print(formatted)
