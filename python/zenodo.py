# -*- coding: utf-8 -*-
"""
This script interacts with the Zenodo deposition API

SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: Apache-2.0
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
"""

import requests
import os

def main():

    ACCESS_TOKEN = os.environ["ZENODO_APIKEY"]
    headers = {"Content-Type": "application/json"}
    params = {'access_token': ACCESS_TOKEN,
              "q":"Apache-2.0"}
    r = requests.get('https://zenodo.org/api/licenses',
                     params=params,
    #                json={},
    #                '''
    #                Headers are not necessary here since "requests" automatically
    #                adds "Content-Type: application/json", because we're using
    #                the "json=" keyword argument
    #                headers=headers,
    #                '''
    #                headers=headers)
    )

    apache = r.json()["hits"]["hits"][0]

    params = {'access_token': ACCESS_TOKEN,
              "q":"*Viable North Sea*"
              }
    r = requests.get('https://zenodo.org/api/records',params=params,)


    return r

if __name__ == '__main__':

   r=main()
