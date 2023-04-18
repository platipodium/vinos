<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

 [![status](https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138/status.svg)](https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138)
 [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
 [![OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/projects/7240/badge)](https://bestpractices.coreinfrastructure.org/projects/7240)
 [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](./doc/contributing/code_of_conduct.md)


# Viable North Sea (ViNoS): A NetLogo Agent-based Model of German Small-scale Fisheries

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German Small-scale Fisheries.  As a Social-Ecological Systems (SES) model it focusses on the adaptive behaviour of fishers facing regulatory, economic, and resource changes. Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, and brown shrimp.

Fishers in the North Sea face area competition with other uses of the sea---long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF).  German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.  Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water.  And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

## Implementation

The simulation model is implemented in the NetLogo framework, a graphical simulator and programming
environment developed for educational purposes.  The model can be found in the folder `netlogo` and
can be started with a double-click on most operating systems after installation of NetLogo,
available from https://ccl.northwestern.edu/netlogo/.

## Data and supplementary routines

The simulation model uses open data available in the `data` folder.  Some of the routines to convert
data into a format usable by the NetLogo model are available as R routines the folder `R`, and
`python`, respectively.   You do not need R or python to run the simulation, unless you would like
to recreate some of the data.

## Using the model

To use the model, please install NetLogo from https://ccl.northwestern.edu/netlogo/download.shtml.  On
Windows and macOS systems, double-clicking the NetLogo application or the code (in the projects's
`netlogo` folder) with the extension `.nlogo` will open NetLogo's integrated development environment.
On Linux, start NetLogo with the `netlogo-gui.sh` shell script provided by NetLogo.

Please refer to the `Info` tab in the graphical NetLogo model to learn quickly more about the model, it's
mathematical implementation and how to use it.  There is a full documentation in ODD format available in
`doc/odd/paper.md`.

## Licenses

The NetLogo model is copyrighted by [Helmholtz-Zentrum Hereon](https://www.hereon.de), [University of Hamburg](https://www.uni-hamburg.de), and [Hochschule Bremerhaven](https://www.hs-bremerhaven.de).  It is available under
the open source Apache 2.0 license.  You may freely use, distribute, and modify the model;  if you
do so, you must acknowledge us. Please find the full license terms under [./LICENSES/APACHE-2.0.txt](./LICENSES/APACHE-2.0.txt)

Some data and utility routines were also contributed by the Thünen Institute, by Hochschule Bremerhaven,
non-governmental organizations and government agencies; some are available under licenses different
from Apache 2.0.  Please refer to the license information available for each individual file in
this project for details, and to the full terms of each license availalbe in [./LICENSES/](./LICENSES).
You may use [REUSE.software](https://reuse.software) to view all licenses.

## Funding

Funding for this software development was obtained by the German Federal Ministry for Education
and Research  (BMBF) in the project Multiple Stressors on North Sea Life (MuSSeL) in the
framework of the agenda Küstenforschung Nordsee-Ostsee (KüNO III) within the
ministry's Forschung für Nachhaltigkeit (FONA) program.

## Contributing and reporting

We hope you can make good use of the software and find it useful and enjoyable. We appreciate
your feedback, bug reports and improvement suggestions on our [issue tracker](https://codebase.helmholtz.cloud/mussel/netlogo-northsea-species/-/issues).  We also welcome your contributions, subject to our Contributor
Covenant [code of conduct](./doc/contributing/code_of_conduct.md) and our [contributor license agreement](./doc/contributing/contributing-license.md).  The best way to contribute is by (1) creating a fork off our repository, (2) committing your changes on your fork and then (3) creating a pull request ("PR") to push your changes back to us.

To file an issue or to contribute, you are asked (1) to authenticate and (2) to register:  When asked, **scroll all the way down** and click `Sign in with Helmholtz AAI`.  On the following page "Login to Helmholtz AAI OAuth2 Authorization Server", search for one of your existing authentication providers (this may be your university, company, ORCID, github, or many others) and log in.  You are then asked to provide name and email address for registration on the HIFIS GitLab instance.
