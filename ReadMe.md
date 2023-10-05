<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

<!-- The open code badge takes up too much space
[![Open Code Badge](https://www.comses.net/static/images/icons/open-code-badge.png)](https://www.comses.net/codebases/f654945f-8129-46a8-9c2d-f2a1b923f543/releases/1.1.0/) -->

[![status](https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138/status.svg)](https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/projects/7240/badge)](https://bestpractices.coreinfrastructure.org/projects/7240)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](./doc/contributing/code_of_conduct.md)
[![REUSE status](https://api.reuse.software/badge/github.com/fsfe/reuse-tool)](https://api.reuse.software/info/codebase.helmholtz.cloud/mussel/netlogo-northsea-species)
[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier/prettier)

<!--  [![Pipeline](https://codebase.helmholtz.cloud/mussel/netlogo-northsea-species/badges/main/pipeline.svg)](https://codebase.helmholtz.cloud/mussel/netlogo-northsea-species/-/pipelines) -->

# Viable North Sea (ViNoS): A NetLogo Agent-based Model of German Small-scale Fisheries

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German Small-scale Fisheries. As a Social-Ecological Systems (SES) model it focusses on the adaptive behaviour of fishers facing regulatory, economic, and resource changes. Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, and brown shrimp.

Fishers in the North Sea face area competition with other uses of the sea---long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF). German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045. Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water. And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

## Installation

The simulation model is implemented in the NetLogo framework, a graphical simulator and programming environment developed for educational purposes. Please install NetLogo version 6.3 or later from https://ccl.northwestern.edu/netlogo/download.shtml. On
Windows and macOS systems, double-clicking the NetLogo application or the model code [./netlogo/vinos.nlogo](./netlogo/vinos.nlogo) will open NetLogo's integrated development environment. On Linux, start NetLogo with the `netlogo-gui.sh` shell script provided by NetLogo.

> If NetLogo gets stuck during startup on macOS with Apple Silicon, you might have run into a Java problem. See https://github.com/NetLogo/NetLogo/issues/2080, install an updated Java runtime, export `JAVA_HOME` and start NetLogo with the `netlogo-gui.sh` shell script.

## Using the model

Upon opening the model, all data are loaded, variables are initialized with default values and the `Interface` tab of the IDE is shown, with a map shown in the `view` panel, and sliders and switches to change parameters. Upon clicking the `go` button, the model advances and the `view` as well as the line and bar plots are updated.

Different spatial results can be shown by selecting in the chooser (NetLogo's term for dropdown menus) other variables than bathymetry. We typically look at fishing effort. Different statistical results about the boats can be shown by selection in the chooser for boat properties. You need to hit the `update` button after changing a chooser's value.

Please refer to the `Info` tab in the graphical NetLogo model to learn quickly more about the model and it's mathematical implementation. There is a full documentation of the agent-based model in ODD format available in
[./doc/odd/paper.md](./doc/odd/paper.md).

## Evaluating a model simulation

The typical evaluation of a NetLogo model is visual inspection, as its canonical use is for education or participatory modeling. So go explore the changes in the map and the line and bar plots as you change parameters (a rising oil price, perhaps?).

The model does write out geospatial data for later analysis with third-party GIS software in the directory [./netlogo/results/](./netlogo/results/). Currently, static maps for water depth, accessibility, and OWF fraction are written out, as well as weekly maps of fishing effort. The output format is ESRII ASCII `.asc` raster data. Fleet statistical data is written out as [./netlogo/results/total_avg.csv](./netlogo/results/total_avg.csv) comma-separated value tabular format.

## Data and supplementary routines

The simulation model uses open data available in the [./data](./data) folder. Some of the routines to convert data into a format usable by the NetLogo model are available as `R` or `python` routines in the folders [./R](./R), and [./python](./python), respectively. You do not need `R` or `python` to run the simulation, unless you would like to recreate some of the input data or project metadata.

## Licenses

The NetLogo model is copyrighted by [Helmholtz-Zentrum hereon GmbH](https://www.hereon.de), [Universität Hamburg](https://www.uni-hamburg.de), and [Hochschule Bremerhaven](https://www.hs-bremerhaven.de). It is available under
the permissive open source Apache 2.0 license. You may freely use, distribute, and modify the model; if you
do so, you must acknowledge us. Please find the full license terms under [./LICENSES/APACHE-2.0.txt](./LICENSES/APACHE-2.0.txt)

The results from model simulations using this software are the intellectual property of the person operating the model. They are free to choose any license, subject to the constraints imposed by the data used to produce these results. If any of your results critically depend on data (as in: are modifications of) that carries a strong copyleft (e.g. the Creative Commons Share-Alike license class), you have to publish your results under this license.

Some data and utility routines were also contributed by the Thünen Institute, by Hochschule Bremerhaven,
non-governmental organizations and government agencies; some are available under licenses different
from Apache 2.0. Please refer to the license information available for each individual file in
this project for details, and to the full terms of each license available in [./LICENSES/](./LICENSES).
You may use [REUSE.software](https://reuse.software) to view all licenses.

## Funding

Funding for this software development was obtained by the German Federal Ministry for Education
and Research (BMBF) in the project Multiple Stressors on North Sea Life (MuSSeL) in the
framework of the agenda Küstenforschung Nordsee-Ostsee (KüNO III) within the
ministry's Forschung für Nachhaltigkeit (FONA) program; the grant number is 03F0862A through E.

MuSSeL is a collaborative project by [Hereon](https://ror.org/03qjp1d79), [Universität Hamburg](https://ror.org/00g30e956), [Hochschule Bremerhaven](https://ror.org/001yqrb02), [Thünen Institut](https://ror.org/00mr84n67) and the [Bundesamt für Seeschiffahrt und Hydrografie](https://ror.org/03ycvrj88).

## Contributing and reporting

We issue [release notes](./ReleaseNotes.md) along with each major and minor version. We recommend to use bleeding edge (latest git commit an branch main) during the stabilization phase of the model. We hope you can make good use of the software and find it useful and enjoyable.

We appreciate your feedback, bug reports and improvement suggestions on our [issue tracker](https://codebase.helmholtz.cloud/mussel/netlogo-northsea-species/-/issues). We also welcome your contributions, subject to our Contributor
Covenant [code of conduct](./doc/contributing/code_of_conduct.md) and our [contributor license agreement](./doc/contributing/contributing-license.md). The best way to contribute is by (1) creating a fork off our repository, (2) committing your changes on your fork and then (3) creating a pull request ("PR") to push your changes back to us.

To file an issue or to contribute, you are asked to (1) authenticate with an existing identity and (2) to register on the HIFIS GitLab instance and sign in. When asked, click "Sign in with Helmholtz AAI". On the following page "Login to Helmholtz AAI OAuth2 Authorization Server", search for one of your existing authentication providers (this may be your university, company, ORCID, GitHub, or many others) and provide their login credentials for authorization.

If you are not already registered on the HIFIS GitLab instance, a confirmation email will be sent to the primary email address registered with your authentication provider. After clicking the confirmation link, you will also be asked to provide a name on this Gitlab instance; this will be your nickname.
